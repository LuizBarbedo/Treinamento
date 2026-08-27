import { supabase } from './supabase'

const baseUrl = (import.meta.env.VITE_OLLAMA_BASE_URL || '/ollama-api').replace(/\/$/, '')
const apiKey = import.meta.env.VITE_OLLAMA_API_KEY
const modelName = import.meta.env.VITE_OLLAMA_MODEL || 'deepseek-v4-flash:0731'

/**
 * Busca os trechos de materiais mais relevantes para a pergunta do aluno
 * (RAG via full-text search no Postgres, filtrado por disciplina).
 */
async function retrieveRelevantChunks(disciplineId, query) {
  const { data, error } = await supabase.rpc('search_material_chunks', {
    p_discipline_id: disciplineId,
    p_query: query,
    p_limit: 5
  })

  if (error) {
    console.error('Erro ao buscar trechos de materiais:', error)
    return []
  }
  return data || []
}

/**
 * Monta o system prompt restringindo o agente ao conteúdo da disciplina.
 */
function buildSystemPrompt(discipline, lessons, materials, relevantChunks) {
  const lessonsList = lessons
    .map((l, i) => `  ${i + 1}. ${l.title}${l.description ? ' - ' + l.description : ''}`)
    .join('\n')

  const materialsList = materials
    .map((m) => `  - ${m.title} (${m.type})`)
    .join('\n')

  const chunksList = relevantChunks
    .map((c) => `  - Trecho de "${c.material_title}":\n    """\n${c.content}\n    """`)
    .join('\n\n')

  return `Você é um assistente de ensino especializado EXCLUSIVAMENTE na disciplina "${discipline.name}".

DESCRIÇÃO DA DISCIPLINA:
${discipline.description || 'Sem descrição.'}

CONTEÚDO DAS AULAS:
${lessonsList || '  Nenhuma aula cadastrada.'}

MATERIAIS DE APOIO:
${materialsList || '  Nenhum material cadastrado.'}

TRECHOS RELEVANTES ENCONTRADOS NOS MATERIAIS PARA A PERGUNTA ATUAL DO ALUNO:
${chunksList || '  Nenhum trecho relevante encontrado para esta pergunta.'}

REGRAS OBRIGATÓRIAS:
1. Responda APENAS perguntas relacionadas ao conteúdo desta disciplina: "${discipline.name}".
2. Se o aluno perguntar sobre QUALQUER outro assunto que não esteja relacionado a esta disciplina, responda educadamente: "Desculpe, só posso ajudar com dúvidas sobre ${discipline.name}. Por favor, faça uma pergunta relacionada ao conteúdo desta disciplina."
3. Seja didático, claro e objetivo nas respostas.
4. Use exemplos práticos quando possível.
5. Quando houver "Trechos relevantes" acima, priorize essa informação como fonte da verdade e baseie a resposta neles. Se não houver trechos relevantes ou a dúvida não estiver coberta por eles, diga que não tem certeza e sugira que o aluno consulte o material de apoio completo.
6. Responda sempre em português do Brasil.
7. Mantenha as respostas concisas (máximo 3 parágrafos, a não ser que o aluno peça mais detalhes).
8. NÃO responda perguntas sobre política, religião, entretenimento, esportes ou qualquer tema fora do escopo da disciplina.`
}

/**
 * Envia uma mensagem para o Ollama (Cloud/Turbo) com o contexto da disciplina.
 */
export async function sendMessage(message, discipline, lessons, materials, chatHistory) {
  if (!apiKey) {
    return 'Agente de IA não configurado. Adicione a VITE_OLLAMA_API_KEY no arquivo .env.'
  }

  try {
    const relevantChunks = await retrieveRelevantChunks(discipline.id, message)
    const systemPrompt = buildSystemPrompt(discipline, lessons, materials, relevantChunks)

    const messages = [
      { role: 'system', content: systemPrompt },
      {
        role: 'assistant',
        content: `Olá! Sou seu assistente para a disciplina **${discipline.name}**. Como posso ajudar com suas dúvidas sobre o conteúdo? 😊`
      },
      ...chatHistory.map((msg) => ({
        role: msg.role === 'user' ? 'user' : 'assistant',
        content: msg.text
      })),
      { role: 'user', content: message }
    ]

    const res = await fetch(`${baseUrl}/api/chat`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${apiKey}`
      },
      body: JSON.stringify({ model: modelName, messages, stream: false })
    })

    if (!res.ok) {
      const status = res.status
      const error = new Error(`Ollama respondeu com status ${status}`)
      error.status = status
      throw error
    }

    const data = await res.json()
    return data.message?.content?.trim() || 'Desculpe, não consegui gerar uma resposta.'
  } catch (error) {
    console.error('Erro ao chamar Ollama:', error)
    if (error.status === 401 || error.status === 403) {
      return 'Chave de API inválida. Verifique a VITE_OLLAMA_API_KEY no arquivo .env.'
    }
    return 'Desculpe, ocorreu um erro ao processar sua pergunta. Tente novamente.'
  }
}
