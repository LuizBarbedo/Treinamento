const baseUrl = import.meta.env.VITE_OLLAMA_BASE_URL || 'https://ollama.com'
const apiKey = import.meta.env.VITE_OLLAMA_API_KEY
const modelName = import.meta.env.VITE_OLLAMA_MODEL || 'qwen3.6:120b'

/**
 * Monta o system prompt restringindo o agente ao conteúdo da disciplina.
 */
function buildSystemPrompt(discipline, lessons, materials) {
  const lessonsList = lessons
    .map((l, i) => `  ${i + 1}. ${l.title}${l.description ? ' - ' + l.description : ''}`)
    .join('\n')

  const materialsList = materials
    .map((m) => `  - ${m.title} (${m.type})`)
    .join('\n')

  return `Você é um assistente de ensino especializado EXCLUSIVAMENTE na disciplina "${discipline.name}".

DESCRIÇÃO DA DISCIPLINA:
${discipline.description || 'Sem descrição.'}

CONTEÚDO DAS AULAS:
${lessonsList || '  Nenhuma aula cadastrada.'}

MATERIAIS DE APOIO:
${materialsList || '  Nenhum material cadastrado.'}

REGRAS OBRIGATÓRIAS:
1. Responda APENAS perguntas relacionadas ao conteúdo desta disciplina: "${discipline.name}".
2. Se o aluno perguntar sobre QUALQUER outro assunto que não esteja relacionado a esta disciplina, responda educadamente: "Desculpe, só posso ajudar com dúvidas sobre ${discipline.name}. Por favor, faça uma pergunta relacionada ao conteúdo desta disciplina."
3. Seja didático, claro e objetivo nas respostas.
4. Use exemplos práticos quando possível.
5. Se não souber a resposta com certeza, diga que não tem certeza e sugira que o aluno consulte o material de apoio.
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
    const systemPrompt = buildSystemPrompt(discipline, lessons, materials)

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
