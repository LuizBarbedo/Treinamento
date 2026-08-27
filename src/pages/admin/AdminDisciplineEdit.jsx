import { useEffect, useState, useRef } from 'react'
import { useParams, Link } from 'react-router-dom'
import { supabase } from '../../lib/supabase'
import { FiArrowLeft, FiSave, FiPlus, FiTrash2, FiEdit2, FiCheck, FiUpload, FiFile, FiSearch } from 'react-icons/fi'
import './AdminDisciplineEdit.css'

export default function AdminDisciplineEdit() {
  const { id } = useParams()
  const [discipline, setDiscipline] = useState(null)
  const [lessons, setLessons] = useState([])
  const [materials, setMaterials] = useState([])
  const [questions, setQuestions] = useState([])
  const [activeTab, setActiveTab] = useState('info')
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const quizFormRef = useRef(null)

  // Discipline form
  const [discForm, setDiscForm] = useState({ name: '', description: '', icon: '📚', order_index: 0 })

  // Lesson form
  const [lessonForm, setLessonForm] = useState({ title: '', description: '', video_url: '', order_index: 0 })
  const [editingLessonId, setEditingLessonId] = useState(null)
  const [showLessonForm, setShowLessonForm] = useState(false)

  // Material form
  const [materialForm, setMaterialForm] = useState({ title: '', type: 'link', url: '' })
  const [editingMaterialId, setEditingMaterialId] = useState(null)
  const [showMaterialForm, setShowMaterialForm] = useState(false)
  const [uploadingFile, setUploadingFile] = useState(false)
  const [selectedFile, setSelectedFile] = useState(null)
  const fileInputRef = useRef(null)
  const [indexingStatus, setIndexingStatus] = useState('')

  // Quiz form
  const [quizForm, setQuizForm] = useState({
    question: '', options: ['', '', '', ''], correct_option: 0, lesson_id: null, order_index: 0, correction_comment: ''
  })
  const [editingQuestionId, setEditingQuestionId] = useState(null)
  const [showQuizForm, setShowQuizForm] = useState(false)

  useEffect(() => {
    fetchAll()
  }, [id])

  const fetchAll = async () => {
    const [discRes, lessRes, matRes, quizRes] = await Promise.all([
      supabase.from('disciplines').select('*').eq('id', id).single(),
      supabase.from('lessons').select('*').eq('discipline_id', id).order('order_index'),
      supabase.from('materials').select('*').eq('discipline_id', id).order('created_at'),
      supabase.from('quiz_questions').select('*').eq('discipline_id', id).order('order_index')
    ])

    if (discRes.data) {
      setDiscipline(discRes.data)
      setDiscForm({
        name: discRes.data.name,
        description: discRes.data.description || '',
        icon: discRes.data.icon || '📚',
        order_index: discRes.data.order_index || 0
      })
    }
    setLessons(lessRes.data || [])
    setMaterials(matRes.data || [])
    setQuestions(quizRes.data || [])
    setLoading(false)
  }

  // ═══════════════════════════════════════
  // DISCIPLINE INFO
  // ═══════════════════════════════════════
  const saveDiscipline = async () => {
    if (!discForm.name.trim()) return alert('Nome é obrigatório')
    setSaving(true)
    await supabase.from('disciplines').update(discForm).eq('id', id)
    setDiscipline(prev => ({ ...prev, ...discForm }))
    setSaving(false)
    alert('Disciplina atualizada com sucesso!')
  }

  // ═══════════════════════════════════════
  // LESSONS CRUD
  // ═══════════════════════════════════════
  const resetLessonForm = () => {
    setLessonForm({ title: '', description: '', video_url: '', order_index: 0 })
    setEditingLessonId(null)
    setShowLessonForm(false)
  }

  const editLesson = (lesson) => {
    setLessonForm({
      title: lesson.title,
      description: lesson.description || '',
      video_url: lesson.video_url || '',
      order_index: lesson.order_index || 0
    })
    setEditingLessonId(lesson.id)
    setShowLessonForm(true)
  }

  const saveLesson = async () => {
    if (!lessonForm.title.trim()) return alert('Título é obrigatório')
    setSaving(true)

    if (editingLessonId) {
      await supabase.from('lessons').update(lessonForm).eq('id', editingLessonId)
    } else {
      const maxOrder = lessons.length > 0
        ? Math.max(...lessons.map(l => l.order_index || 0))
        : 0
      await supabase.from('lessons').insert({
        ...lessonForm,
        discipline_id: id,
        order_index: lessonForm.order_index || maxOrder + 1
      })
    }

    setSaving(false)
    resetLessonForm()
    fetchAll()
  }

  const deleteLesson = async (lessonId, title) => {
    if (!confirm(`Excluir aula "${title}"?\n\nOs quizzes associados também serão removidos.`)) return
    await supabase.from('lessons').delete().eq('id', lessonId)
    fetchAll()
  }

  // ═══════════════════════════════════════
  // MATERIALS CRUD
  // ═══════════════════════════════════════
  const resetMaterialForm = () => {
    setMaterialForm({ title: '', type: 'link', url: '' })
    setEditingMaterialId(null)
    setShowMaterialForm(false)
    setSelectedFile(null)
    if (fileInputRef.current) fileInputRef.current.value = ''
  }

  const editMaterial = (mat) => {
    setMaterialForm({
      title: mat.title,
      type: mat.type || 'link',
      url: mat.url || ''
    })
    setEditingMaterialId(mat.id)
    setShowMaterialForm(true)
  }

  const handleFileSelect = (e) => {
    const file = e.target.files[0]
    if (!file) return

    const allowedTypes = [
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    ]

    if (!allowedTypes.includes(file.type)) {
      alert('Tipo de arquivo não permitido. Envie apenas PDF ou Word (.doc, .docx).')
      e.target.value = ''
      return
    }

    if (file.size > 50 * 1024 * 1024) {
      alert('Arquivo muito grande. O limite é 50MB.')
      e.target.value = ''
      return
    }

    setSelectedFile(file)

    // Auto-detectar tipo
    if (file.type === 'application/pdf') {
      setMaterialForm(f => ({ ...f, type: 'pdf' }))
    } else {
      setMaterialForm(f => ({ ...f, type: 'word' }))
    }

    // Auto-preencher título se vazio
    if (!materialForm.title.trim()) {
      const nameWithoutExt = file.name.replace(/\.[^/.]+$/, '')
      setMaterialForm(f => ({ ...f, title: nameWithoutExt }))
    }
  }

  const uploadFile = async (file) => {
    const fileExt = file.name.split('.').pop()
    const fileName = `${id}/${Date.now()}_${Math.random().toString(36).substring(7)}.${fileExt}`

    const { data, error } = await supabase.storage
      .from('materials')
      .upload(fileName, file, {
        cacheControl: '3600',
        upsert: false
      })

    if (error) throw error

    const { data: publicUrlData } = supabase.storage
      .from('materials')
      .getPublicUrl(fileName)

    return { url: publicUrlData.publicUrl, filePath: fileName }
  }

  const saveMaterial = async () => {
    if (!materialForm.title.trim()) return alert('Título é obrigatório')

    const isFileUpload = materialForm.type === 'pdf' || materialForm.type === 'word'

    if (!isFileUpload && !materialForm.url.trim()) {
      return alert('URL é obrigatória para materiais do tipo link, livro ou artigo.')
    }

    if (isFileUpload && !selectedFile && !editingMaterialId) {
      return alert('Selecione um arquivo para enviar.')
    }

    setSaving(true)
    setUploadingFile(!!selectedFile)

    try {
      let materialData = {
        title: materialForm.title,
        type: materialForm.type,
        url: materialForm.url
      }

      // Upload do arquivo se selecionado
      if (selectedFile) {
        const { url, filePath } = await uploadFile(selectedFile)
        materialData.url = url
        materialData.file_path = filePath
      }

      let savedMaterial = null

      if (editingMaterialId) {
        // Se está editando e tem novo arquivo, deletar o antigo do storage
        if (selectedFile) {
          const oldMat = materials.find(m => m.id === editingMaterialId)
          if (oldMat?.file_path) {
            await supabase.storage.from('materials').remove([oldMat.file_path])
          }
        }
        const { data } = await supabase.from('materials').update(materialData).eq('id', editingMaterialId).select().single()
        savedMaterial = data
      } else {
        const { data } = await supabase.from('materials').insert({ ...materialData, discipline_id: id }).select().single()
        savedMaterial = data
      }

      resetMaterialForm()
      fetchAll()

      // Indexa o conteúdo do material (PDF/Word) para a busca do chat de IA,
      // em background, sem travar o formulário
      if (savedMaterial && (savedMaterial.type === 'pdf' || savedMaterial.type === 'word')) {
        setIndexingStatus(`Indexando "${savedMaterial.title}" para busca da IA...`)
        import('../../lib/materialIndexer')
          .then(({ indexMaterial }) => indexMaterial(savedMaterial, id))
          .finally(() => setIndexingStatus(''))
      }
    } catch (err) {
      console.error('Erro ao salvar material:', err)
      alert('Erro ao salvar material. Tente novamente.')
    }

    setSaving(false)
    setUploadingFile(false)
  }

  const reindexMaterials = async () => {
    const fileMaterials = materials.filter(m => m.type === 'pdf' || m.type === 'word')
    if (fileMaterials.length === 0) {
      return alert('Nenhum material em PDF/Word para indexar.')
    }
    setIndexingStatus(`Reprocessando 0/${fileMaterials.length} materiais...`)
    const { reindexAllMaterials } = await import('../../lib/materialIndexer')
    let done = 0
    await reindexAllMaterials(fileMaterials, id, () => {
      done += 1
      setIndexingStatus(`Reprocessando ${done}/${fileMaterials.length} materiais...`)
    })
    setIndexingStatus('')
  }

  const deleteMaterial = async (matId, title) => {
    if (!confirm(`Excluir material "${title}"?`)) return

    // Deletar arquivo do storage se existir
    const mat = materials.find(m => m.id === matId)
    if (mat?.file_path) {
      await supabase.storage.from('materials').remove([mat.file_path])
    }

    await supabase.from('materials').delete().eq('id', matId)
    fetchAll()
  }

  // ═══════════════════════════════════════
  // QUIZ QUESTIONS CRUD
  // ═══════════════════════════════════════
  const resetQuizForm = () => {
    setQuizForm({
      question: '', options: ['', '', '', ''], correct_option: 0, lesson_id: null, order_index: 0, correction_comment: ''
    })
    setEditingQuestionId(null)
    setShowQuizForm(false)
  }

  const editQuestion = (q) => {
    setQuizForm({
      question: q.question,
      options: [...(q.options || ['', '', '', ''])],
      correct_option: q.correct_option,
      lesson_id: q.lesson_id || null,
      order_index: q.order_index || 0,
      correction_comment: q.correction_comment || ''
    })
    setEditingQuestionId(q.id)
    setShowQuizForm(true)
    setTimeout(() => {
      quizFormRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }, 50)
  }

  const saveQuestion = async () => {
    if (!quizForm.question.trim()) return alert('Pergunta é obrigatória')
    if (quizForm.options.some(o => !o.trim())) return alert('Todas as opções devem ser preenchidas')
    setSaving(true)

    const data = {
      question: quizForm.question,
      options: quizForm.options,
      correct_option: quizForm.correct_option,
      lesson_id: quizForm.lesson_id || null,
      order_index: quizForm.order_index,
      correction_comment: quizForm.correction_comment || null
    }

    if (editingQuestionId) {
      await supabase.from('quiz_questions').update(data).eq('id', editingQuestionId)
    } else {
      await supabase.from('quiz_questions').insert({ ...data, discipline_id: id })
    }

    setSaving(false)
    resetQuizForm()
    fetchAll()
  }

  const deleteQuestion = async (qId) => {
    if (!confirm('Excluir esta questão?')) return
    await supabase.from('quiz_questions').delete().eq('id', qId)
    fetchAll()
  }

  const updateQuizOption = (index, value) => {
    setQuizForm(prev => {
      const options = [...prev.options]
      options[index] = value
      return { ...prev, options }
    })
  }

  const addQuizOption = () => {
    setQuizForm(prev => ({ ...prev, options: [...prev.options, ''] }))
  }

  const removeQuizOption = (index) => {
    setQuizForm(prev => {
      const options = prev.options.filter((_, i) => i !== index)
      let correct_option = prev.correct_option
      if (correct_option === index) correct_option = 0
      else if (correct_option > index) correct_option -= 1
      return { ...prev, options, correct_option }
    })
  }

  // Separate questions by type
  const generalQuestions = questions.filter(q => !q.lesson_id)
  const lessonQuestionsGrouped = lessons.map(l => ({
    lesson: l,
    questions: questions.filter(q => q.lesson_id === l.id)
  })).filter(g => g.questions.length > 0)

  if (loading) {
    return <div className="loading-screen"><div className="spinner"></div></div>
  }

  if (!discipline) {
    return <div className="error-state">Disciplina não encontrada.</div>
  }

  return (
    <div className="admin-disc-edit">
      {/* Header */}
      <div className="admin-edit-header">
        <Link to="/admin/disciplinas" className="back-link">
          <FiArrowLeft /> Voltar às Disciplinas
        </Link>
        <h1>{discipline.icon} {discipline.name}</h1>
        <p className="admin-subtitle">Gerencie o conteúdo desta disciplina</p>
      </div>

      {/* Tabs */}
      <div className="admin-tabs">
        {[
          { key: 'info', label: '📋 Informações' },
          { key: 'aulas', label: `🎬 Aulas (${lessons.length})` },
          { key: 'materiais', label: `📎 Materiais (${materials.length})` },
          { key: 'quiz', label: `📝 Quiz (${questions.length})` },
        ].map(tab => (
          <button
            key={tab.key}
            className={`admin-tab ${activeTab === tab.key ? 'active' : ''}`}
            onClick={() => setActiveTab(tab.key)}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* ═══ INFO TAB ═══ */}
      {activeTab === 'info' && (
        <div className="admin-section">
          <div className="admin-form-card">
            <div className="form-grid">
              <div className="form-group">
                <label>Ícone (emoji)</label>
                <input
                  value={discForm.icon}
                  onChange={e => setDiscForm(f => ({ ...f, icon: e.target.value }))}
                  placeholder="📚"
                />
              </div>
              <div className="form-group">
                <label>Ordem de exibição</label>
                <input
                  type="number"
                  value={discForm.order_index}
                  onChange={e => setDiscForm(f => ({ ...f, order_index: parseInt(e.target.value) || 0 }))}
                />
              </div>
              <div className="form-group form-full">
                <label>Nome *</label>
                <input
                  value={discForm.name}
                  onChange={e => setDiscForm(f => ({ ...f, name: e.target.value }))}
                  placeholder="Nome da disciplina"
                />
              </div>
              <div className="form-group form-full">
                <label>Descrição</label>
                <textarea
                  value={discForm.description}
                  onChange={e => setDiscForm(f => ({ ...f, description: e.target.value }))}
                  placeholder="Descrição da disciplina"
                  rows={3}
                />
              </div>
            </div>
            <div className="form-actions">
              <button className="btn-primary" onClick={saveDiscipline} disabled={saving}>
                <FiSave /> {saving ? 'Salvando...' : 'Salvar Alterações'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ═══ AULAS TAB ═══ */}
      {activeTab === 'aulas' && (
        <div className="admin-section">
          <div className="section-toolbar">
            <h3>🎬 Aulas da Disciplina</h3>
            <button className="btn-primary" onClick={() => { resetLessonForm(); setShowLessonForm(true) }}>
              <FiPlus /> Nova Aula
            </button>
          </div>

          {showLessonForm && (
            <div className="admin-form-card">
              <h3>{editingLessonId ? '✏️ Editar Aula' : '➕ Nova Aula'}</h3>
              <div className="form-grid">
                <div className="form-group" style={{ gridColumn: 'span 1' }}>
                  <label>Título *</label>
                  <input
                    value={lessonForm.title}
                    onChange={e => setLessonForm(f => ({ ...f, title: e.target.value }))}
                    placeholder="Título da aula"
                  />
                </div>
                <div className="form-group">
                  <label>Ordem</label>
                  <input
                    type="number"
                    value={lessonForm.order_index}
                    onChange={e => setLessonForm(f => ({ ...f, order_index: parseInt(e.target.value) || 0 }))}
                  />
                </div>
                <div className="form-group form-full">
                  <label>URL do Vídeo</label>
                  <input
                    value={lessonForm.video_url}
                    onChange={e => setLessonForm(f => ({ ...f, video_url: e.target.value }))}
                    placeholder="https://youtube.com/watch?v=... ou URL do Google Drive"
                  />
                </div>
                <div className="form-group form-full">
                  <label>Descrição</label>
                  <textarea
                    value={lessonForm.description}
                    onChange={e => setLessonForm(f => ({ ...f, description: e.target.value }))}
                    placeholder="Descrição da aula"
                    rows={2}
                  />
                </div>
              </div>
              <div className="form-actions">
                <button className="btn-secondary" onClick={resetLessonForm}>Cancelar</button>
                <button className="btn-primary" onClick={saveLesson} disabled={saving}>
                  {saving ? 'Salvando...' : editingLessonId ? 'Salvar' : 'Adicionar Aula'}
                </button>
              </div>
            </div>
          )}

          <div className="admin-list">
            {lessons.map((lesson) => {
              const lessonQuestionCount = questions.filter(q => q.lesson_id === lesson.id).length
              return (
                <div key={lesson.id} className="admin-list-item admin-lesson-item">
                  <span className="item-order">{lesson.order_index}</span>
                  <div className="item-info">
                    <strong>{lesson.title}</strong>
                    {lesson.description && <small>{lesson.description}</small>}
                    {lesson.video_url && <small className="item-url">🎬 {lesson.video_url}</small>}
                    <div className="lesson-quiz-badge-row">
                      <span className={`lesson-quiz-count ${lessonQuestionCount > 0 ? 'has-questions' : 'no-questions'}`}>
                        📝 {lessonQuestionCount} {lessonQuestionCount === 1 ? 'questão' : 'questões'} no quiz
                      </span>
                      <button
                        className="btn-add-quiz-shortcut"
                        onClick={() => {
                          setQuizForm({
                            question: '', options: ['', '', '', ''], correct_option: 0,
                            lesson_id: lesson.id, order_index: lessonQuestionCount + 1, correction_comment: ''
                          })
                          setEditingQuestionId(null)
                          setShowQuizForm(true)
                          setActiveTab('quiz')
                        }}
                      >
                        + Adicionar questão
                      </button>
                    </div>
                  </div>
                  <div className="item-actions">
                    <button className="btn-icon btn-edit" onClick={() => editLesson(lesson)} title="Editar">
                      <FiEdit2 />
                    </button>
                    <button className="btn-icon btn-delete" onClick={() => deleteLesson(lesson.id, lesson.title)} title="Excluir">
                      <FiTrash2 />
                    </button>
                  </div>
                </div>
              )
            })}
            {lessons.length === 0 && (
              <div className="list-empty">Nenhuma aula cadastrada. Adicione a primeira aula!</div>
            )}
          </div>
        </div>
      )}

      {/* ═══ MATERIAIS TAB ═══ */}
      {activeTab === 'materiais' && (
        <div className="admin-section">
          <div className="section-toolbar">
            <h3>📎 Materiais de Apoio</h3>
            <button className="btn-secondary" onClick={reindexMaterials} disabled={!!indexingStatus} title="Reindexa PDFs/Word já cadastrados para a busca do chat de IA">
              <FiSearch /> Reprocessar índice de busca
            </button>
            <button className="btn-primary" onClick={() => { resetMaterialForm(); setShowMaterialForm(true) }}>
              <FiPlus /> Novo Material
            </button>
          </div>

          {showMaterialForm && (
            <div className="admin-form-card">
              <h3>{editingMaterialId ? '✏️ Editar Material' : '➕ Novo Material'}</h3>
              <div className="form-grid">
                <div className="form-group" style={{ gridColumn: 'span 1' }}>
                  <label>Título *</label>
                  <input
                    value={materialForm.title}
                    onChange={e => setMaterialForm(f => ({ ...f, title: e.target.value }))}
                    placeholder="Título do material"
                  />
                </div>
                <div className="form-group">
                  <label>Tipo</label>
                  <select
                    value={materialForm.type}
                    onChange={e => {
                      setMaterialForm(f => ({ ...f, type: e.target.value }))
                      if (e.target.value !== 'pdf' && e.target.value !== 'word') {
                        setSelectedFile(null)
                        if (fileInputRef.current) fileInputRef.current.value = ''
                      }
                    }}
                  >
                    <option value="link">Link</option>
                    <option value="pdf">PDF</option>
                    <option value="word">Word</option>
                    <option value="livro">Livro</option>
                    <option value="artigo">Artigo</option>
                  </select>
                </div>

                {/* Upload de arquivo para PDF e Word */}
                {(materialForm.type === 'pdf' || materialForm.type === 'word') && (
                  <div className="form-group form-full">
                    <label>Arquivo ({materialForm.type === 'pdf' ? 'PDF' : 'Word (.doc, .docx)'})</label>
                    <div className="file-upload-area">
                      <input
                        ref={fileInputRef}
                        type="file"
                        accept={materialForm.type === 'pdf'
                          ? '.pdf,application/pdf'
                          : '.doc,.docx,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                        }
                        onChange={handleFileSelect}
                        className="file-input-hidden"
                        id="material-file-input"
                      />
                      <label htmlFor="material-file-input" className="file-upload-label">
                        <FiUpload />
                        <span>
                          {selectedFile
                            ? selectedFile.name
                            : `Clique para selecionar um arquivo ${materialForm.type === 'pdf' ? 'PDF' : 'Word'}`
                          }
                        </span>
                      </label>
                      {selectedFile && (
                        <div className="file-selected-info">
                          <FiFile />
                          <span>{selectedFile.name}</span>
                          <span className="file-size">
                            ({(selectedFile.size / (1024 * 1024)).toFixed(2)} MB)
                          </span>
                          <button
                            type="button"
                            className="btn-remove-file"
                            onClick={() => {
                              setSelectedFile(null)
                              if (fileInputRef.current) fileInputRef.current.value = ''
                            }}
                          >
                            <FiTrash2 />
                          </button>
                        </div>
                      )}
                      {editingMaterialId && !selectedFile && (
                        <small className="file-edit-hint">
                          Selecione um novo arquivo para substituir o atual, ou deixe em branco para manter.
                        </small>
                      )}
                    </div>
                  </div>
                )}

                {/* URL para links, livros e artigos */}
                {materialForm.type !== 'pdf' && materialForm.type !== 'word' && (
                  <div className="form-group form-full">
                    <label>URL</label>
                    <input
                      value={materialForm.url}
                      onChange={e => setMaterialForm(f => ({ ...f, url: e.target.value }))}
                      placeholder="https://..."
                    />
                  </div>
                )}
              </div>
              <div className="form-actions">
                <button className="btn-secondary" onClick={resetMaterialForm}>Cancelar</button>
                <button className="btn-primary" onClick={saveMaterial} disabled={saving || uploadingFile}>
                  {uploadingFile ? 'Enviando arquivo...' : saving ? 'Salvando...' : editingMaterialId ? 'Salvar' : 'Adicionar Material'}
                </button>
              </div>
            </div>
          )}

          {indexingStatus && (
            <div className="list-empty" style={{ padding: '0.5rem 0' }}>🔎 {indexingStatus}</div>
          )}

          <div className="admin-list">
            {materials.map(mat => (
              <div key={mat.id} className="admin-list-item">
                <span className="item-type-badge">{mat.type}</span>
                <div className="item-info">
                  <strong>{mat.title}</strong>
                  {mat.file_path
                    ? <small className="item-url">📎 Arquivo enviado</small>
                    : mat.url && <small className="item-url">🔗 {mat.url}</small>
                  }
                </div>
                <div className="item-actions">
                  <button className="btn-icon btn-edit" onClick={() => editMaterial(mat)} title="Editar">
                    <FiEdit2 />
                  </button>
                  <button className="btn-icon btn-delete" onClick={() => deleteMaterial(mat.id, mat.title)} title="Excluir">
                    <FiTrash2 />
                  </button>
                </div>
              </div>
            ))}
            {materials.length === 0 && (
              <div className="list-empty">Nenhum material cadastrado. Adicione o primeiro material!</div>
            )}
          </div>
        </div>
      )}

      {/* ═══ QUIZ TAB ═══ */}
      {activeTab === 'quiz' && (
        <div className="admin-section">
          <div className="section-toolbar">
            <h3>📝 Questões do Quiz</h3>
            <button className="btn-primary" onClick={() => { resetQuizForm(); setShowQuizForm(true) }}>
              <FiPlus /> Nova Questão
            </button>
          </div>

          {showQuizForm && (
            <div className="admin-form-card" ref={quizFormRef}>
              <h3>{editingQuestionId ? '✏️ Editar Questão' : '➕ Nova Questão'}</h3>
              <div className="form-grid">
                <div className="form-group" style={{ gridColumn: 'span 1' }}>
                  <label>Associar a Aula</label>
                  <select
                    value={quizForm.lesson_id || ''}
                    onChange={e => setQuizForm(f => ({ ...f, lesson_id: e.target.value || null }))}
                  >
                    <option value="">Quiz Final da Disciplina</option>
                    {lessons.map(l => (
                      <option key={l.id} value={l.id}>Aula: {l.title}</option>
                    ))}
                  </select>
                </div>
                <div className="form-group">
                  <label>Ordem</label>
                  <input
                    type="number"
                    value={quizForm.order_index}
                    onChange={e => setQuizForm(f => ({ ...f, order_index: parseInt(e.target.value) || 0 }))}
                  />
                </div>
                <div className="form-group form-full">
                  <label>Pergunta *</label>
                  <textarea
                    value={quizForm.question}
                    onChange={e => setQuizForm(f => ({ ...f, question: e.target.value }))}
                    rows={2}
                    placeholder="Digite a pergunta..."
                  />
                </div>
                <div className="form-group form-full">
                  <label>Comentário de Correção (aparece ao final do quiz)</label>
                  <textarea
                    value={quizForm.correction_comment}
                    onChange={e => setQuizForm(f => ({ ...f, correction_comment: e.target.value }))}
                    rows={2}
                    placeholder="Explicação que aparece ao aluno após finalizar o quiz (opcional)"
                  />
                </div>
                {quizForm.options.map((opt, i) => (
                  <div key={i} className="form-group form-half">
                    <label>
                      Opção {String.fromCharCode(65 + i)}
                      {quizForm.correct_option === i && ' ✅ Correta'}
                    </label>
                    <div className="option-input-row">
                      <input
                        value={opt}
                        onChange={e => updateQuizOption(i, e.target.value)}
                        placeholder={`Opção ${String.fromCharCode(65 + i)}`}
                      />
                      <button
                        type="button"
                        className={`btn-correct ${quizForm.correct_option === i ? 'active' : ''}`}
                        onClick={() => setQuizForm(f => ({ ...f, correct_option: i }))}
                        title="Marcar como correta"
                      >
                        <FiCheck />
                      </button>
                      {i >= 4 && (
                        <button
                          type="button"
                          className="btn-remove-option"
                          onClick={() => removeQuizOption(i)}
                          title="Remover esta opção"
                        >
                          <FiTrash2 />
                        </button>
                      )}
                    </div>
                  </div>
                ))}
                {quizForm.options.length < 5 && (
                  <div className="form-group form-full">
                    <button type="button" className="btn-add-option" onClick={addQuizOption}>
                      <FiPlus /> Adicionar Opção E (opcional)
                    </button>
                  </div>
                )}
              </div>
              <div className="form-actions">
                <button className="btn-secondary" onClick={resetQuizForm}>Cancelar</button>
                <button className="btn-primary" onClick={saveQuestion} disabled={saving}>
                  {saving ? 'Salvando...' : editingQuestionId ? 'Salvar' : 'Adicionar Questão'}
                </button>
              </div>
            </div>
          )}

          {/* General Quiz Questions */}
          <h3 className="quiz-section-title">
            📋 Quiz Final da Disciplina ({generalQuestions.length} questões)
          </h3>
          <div className="admin-list">
            {generalQuestions.map((q) => (
              <div key={q.id} className="admin-list-item quiz-item">
                <span className="item-order">{q.order_index}</span>
                <div className="item-info">
                  <strong>{q.question}</strong>
                  <div className="quiz-options-preview">
                    {q.options?.map((opt, oi) => (
                      <span key={oi} className={`option-preview ${oi === q.correct_option ? 'correct' : ''}`}>
                        {String.fromCharCode(65 + oi)}: {opt}
                      </span>
                    ))}
                  </div>
                  {q.correction_comment && (
                    <div className="quiz-comment-preview">
                      💬 <em>{q.correction_comment}</em>
                    </div>
                  )}
                </div>
                <div className="item-actions">
                  <button className="btn-icon btn-edit" onClick={() => editQuestion(q)} title="Editar">
                    <FiEdit2 />
                  </button>
                  <button className="btn-icon btn-delete" onClick={() => deleteQuestion(q.id)} title="Excluir">
                    <FiTrash2 />
                  </button>
                </div>
              </div>
            ))}
            {generalQuestions.length === 0 && (
              <div className="list-empty">Nenhuma questão do quiz final cadastrada.</div>
            )}
          </div>

          {/* Per-Lesson Quiz Questions */}
          {lessonQuestionsGrouped.map(({ lesson, questions: lQuestions }) => (
            <div key={lesson.id}>
              <h3 className="quiz-section-title">
                🎬 {lesson.title} ({lQuestions.length} questões)
              </h3>
              <div className="admin-list">
                {lQuestions.map(q => (
                  <div key={q.id} className="admin-list-item quiz-item">
                    <span className="item-order">{q.order_index}</span>
                    <div className="item-info">
                      <strong>{q.question}</strong>
                      <div className="quiz-options-preview">
                        {q.options?.map((opt, oi) => (
                          <span key={oi} className={`option-preview ${oi === q.correct_option ? 'correct' : ''}`}>
                            {String.fromCharCode(65 + oi)}: {opt}
                          </span>
                        ))}
                      </div>
                      {q.correction_comment && (
                        <div className="quiz-comment-preview">
                          💬 <em>{q.correction_comment}</em>
                        </div>
                      )}
                    </div>
                    <div className="item-actions">
                      <button className="btn-icon btn-edit" onClick={() => editQuestion(q)} title="Editar">
                        <FiEdit2 />
                      </button>
                      <button className="btn-icon btn-delete" onClick={() => deleteQuestion(q.id)} title="Excluir">
                        <FiTrash2 />
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))}

          {/* Show lessons that have no quiz questions yet */}
          {lessons.filter(l => !questions.some(q => q.lesson_id === l.id)).length > 0 && (
            <div className="quiz-missing-notice">
              <h4>⚠️ Aulas sem quiz:</h4>
              <ul>
                {lessons.filter(l => !questions.some(q => q.lesson_id === l.id)).map(l => (
                  <li key={l.id}>{l.title}</li>
                ))}
              </ul>
              <p>Adicione questões de quiz para essas aulas clicando em "Nova Questão".</p>
            </div>
          )}
        </div>
      )}
    </div>
  )
}
