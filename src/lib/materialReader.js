import * as pdfjsLib from 'pdfjs-dist'
import pdfjsWorker from 'pdfjs-dist/build/pdf.worker.min.mjs?url'
import mammoth from 'mammoth'

pdfjsLib.GlobalWorkerOptions.workerSrc = pdfjsWorker

const MAX_CHARS_PER_MATERIAL = 200000
const CHUNK_SIZE = 800
const CHUNK_OVERLAP = 100

async function extractPdfText(url) {
  const res = await fetch(url)
  const buffer = await res.arrayBuffer()
  const pdf = await pdfjsLib.getDocument({ data: buffer }).promise

  let text = ''
  for (let i = 1; i <= pdf.numPages && text.length < MAX_CHARS_PER_MATERIAL; i++) {
    const page = await pdf.getPage(i)
    const content = await page.getTextContent()
    text += content.items.map((item) => item.str).join(' ') + '\n'
  }
  return text.slice(0, MAX_CHARS_PER_MATERIAL)
}

async function extractWordText(url) {
  const res = await fetch(url)
  const buffer = await res.arrayBuffer()
  const { value } = await mammoth.extractRawText({ arrayBuffer: buffer })
  return value.slice(0, MAX_CHARS_PER_MATERIAL)
}

/**
 * Extrai o texto de um material (PDF ou Word) hospedado no Storage.
 * Materiais do tipo 'link'/'livro'/'artigo' não têm arquivo local e ficam de fora.
 */
export async function extractMaterialText(material) {
  if (!material.url) return null

  try {
    if (material.type === 'pdf') {
      return await extractPdfText(material.url)
    }
    if (material.type === 'word') {
      return await extractWordText(material.url)
    }
  } catch (error) {
    console.error(`Erro ao ler o conteúdo do material "${material.title}":`, error)
  }
  return null
}

/**
 * Quebra um texto longo em pedaços pesquisáveis, com sobreposição entre
 * eles para não cortar uma ideia no meio.
 */
export function chunkText(text, chunkSize = CHUNK_SIZE, overlap = CHUNK_OVERLAP) {
  const normalized = text.replace(/\s+/g, ' ').trim()
  if (!normalized) return []

  const chunks = []
  let start = 0
  while (start < normalized.length) {
    const end = Math.min(start + chunkSize, normalized.length)
    chunks.push(normalized.slice(start, end).trim())
    if (end === normalized.length) break
    start = end - overlap
  }
  return chunks.filter(Boolean)
}
