import { GoogleGenerativeAI } from '@google/generative-ai'

const apiKey = import.meta.env.VITE_GEMINI_API_KEY

let genAI = null
let model = null

if (apiKey && !apiKey.includes('SUA_')) {
  genAI = new GoogleGenerativeAI(apiKey)
  model = genAI.getGenerativeModel({ model: 'gemini-2.0-flash' })
}

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
 * Envia uma mensagem para o Gemini com o contexto da disciplina.
 */
export async function sendMessage(message, discipline, lessons, materials, chatHistory) {
  if (!model) {
    return 'Agente de IA não configurado. Adicione a VITE_GEMINI_API_KEY no arquivo .env.'
  }

  try {
    const systemPrompt = buildSystemPrompt(discipline, lessons, materials)

    // Montar o histórico para a conversa
    const contents = [
      { role: 'user', parts: [{ text: systemPrompt + '\n\nEntendido, estou pronto para ajudar!' }] },
      { role: 'model', parts: [{ text: `Olá! Sou seu assistente para a disciplina **${discipline.name}**. Como posso ajudar com suas dúvidas sobre o conteúdo? 😊` }] },
    ]

    // Adicionar histórico da conversa
    for (const msg of chatHistory) {
      contents.push({
        role: msg.role === 'user' ? 'user' : 'model',
        parts: [{ text: msg.text }]
      })
    }

    // Adicionar a mensagem atual
    contents.push({ role: 'user', parts: [{ text: message }] })

    const result = await model.generateContent({ contents })
    const response = result.response.text()
    return response
  } catch (error) {
    console.error('Erro ao chamar Gemini:', error)
    if (error.message?.includes('API_KEY')) {
      return 'Chave de API inválida. Verifique a VITE_GEMINI_API_KEY no arquivo .env.'
    }
    return 'Desculpe, ocorreu um erro ao processar sua pergunta. Tente novamente.'
  }
}
