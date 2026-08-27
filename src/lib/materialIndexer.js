import { supabase } from './supabase'
import { extractMaterialText, chunkText } from './materialReader'

/**
 * Extrai o texto de um material, quebra em chunks e (re)grava no índice de
 * busca (material_chunks). Materiais sem conteúdo extraível (links, etc.)
 * simplesmente não geram chunks.
 */
export async function indexMaterial(material, disciplineId) {
  const text = await extractMaterialText(material)

  // Sempre limpa os chunks antigos primeiro (cobre edição/reenvio de arquivo)
  await supabase.from('material_chunks').delete().eq('material_id', material.id)

  if (!text) return { indexed: 0 }

  const chunks = chunkText(text)
  if (chunks.length === 0) return { indexed: 0 }

  const rows = chunks.map((content, chunk_index) => ({
    material_id: material.id,
    discipline_id: disciplineId,
    chunk_index,
    content
  }))

  const { error } = await supabase.from('material_chunks').insert(rows)
  if (error) {
    console.error(`Erro ao indexar material "${material.title}":`, error)
    return { indexed: 0, error }
  }

  return { indexed: rows.length }
}

/**
 * Reprocessa todos os materiais de uma disciplina (útil para materiais
 * cadastrados antes deste recurso existir).
 */
export async function reindexAllMaterials(materials, disciplineId, onProgress) {
  let total = 0
  for (const material of materials) {
    const { indexed } = await indexMaterial(material, disciplineId)
    total += indexed
    onProgress?.(material)
  }
  return total
}
