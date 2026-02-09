import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { supabase } from '../../lib/supabase'
import { FiPlus, FiEdit2, FiTrash2 } from 'react-icons/fi'
import './AdminDisciplines.css'

export default function AdminDisciplines() {
  const [disciplines, setDisciplines] = useState([])
  const [loading, setLoading] = useState(true)
  const [showForm, setShowForm] = useState(false)
  const [editingId, setEditingId] = useState(null)
  const [form, setForm] = useState({ name: '', description: '', icon: '📚', order_index: 0 })
  const [saving, setSaving] = useState(false)

  useEffect(() => {
    fetchDisciplines()
  }, [])

  const fetchDisciplines = async () => {
    const { data } = await supabase
      .from('disciplines')
      .select('*, lessons(count), materials(count), quiz_questions(count)')
      .order('order_index')
    setDisciplines(data || [])
    setLoading(false)
  }

  const resetForm = () => {
    setForm({ name: '', description: '', icon: '📚', order_index: 0 })
    setEditingId(null)
    setShowForm(false)
  }

  const handleEdit = (disc) => {
    setForm({
      name: disc.name,
      description: disc.description || '',
      icon: disc.icon || '📚',
      order_index: disc.order_index || 0
    })
    setEditingId(disc.id)
    setShowForm(true)
  }

  const handleSave = async () => {
    if (!form.name.trim()) return alert('Nome é obrigatório')
    setSaving(true)

    if (editingId) {
      await supabase.from('disciplines').update(form).eq('id', editingId)
    } else {
      const maxOrder = disciplines.length > 0
        ? Math.max(...disciplines.map(d => d.order_index || 0))
        : 0
      await supabase.from('disciplines').insert({
        ...form,
        order_index: form.order_index || maxOrder + 1
      })
    }

    setSaving(false)
    resetForm()
    fetchDisciplines()
  }

  const handleDelete = async (id, name) => {
    if (!confirm(`Tem certeza que deseja excluir "${name}"?\n\nTodas as aulas, materiais e quizzes desta disciplina serão removidos permanentemente.`)) return
    await supabase.from('disciplines').delete().eq('id', id)
    fetchDisciplines()
  }

  if (loading) {
    return <div className="loading-screen"><div className="spinner"></div></div>
  }

  return (
    <div className="admin-disciplines">
      <div className="admin-header">
        <div>
          <h1>⚙️ Gerenciar Disciplinas</h1>
          <p className="admin-subtitle">Crie, edite e organize as disciplinas do treinamento</p>
        </div>
        <button className="btn-primary" onClick={() => { resetForm(); setShowForm(true) }}>
          <FiPlus /> Nova Disciplina
        </button>
      </div>

      {showForm && (
        <div className="admin-form-card">
          <h3>{editingId ? '✏️ Editar Disciplina' : '➕ Nova Disciplina'}</h3>
          <div className="form-grid">
            <div className="form-group">
              <label>Ícone (emoji)</label>
              <input
                value={form.icon}
                onChange={e => setForm(f => ({ ...f, icon: e.target.value }))}
                placeholder="📚"
              />
            </div>
            <div className="form-group">
              <label>Ordem</label>
              <input
                type="number"
                value={form.order_index}
                onChange={e => setForm(f => ({ ...f, order_index: parseInt(e.target.value) || 0 }))}
              />
            </div>
            <div className="form-group form-full">
              <label>Nome *</label>
              <input
                value={form.name}
                onChange={e => setForm(f => ({ ...f, name: e.target.value }))}
                placeholder="Nome da disciplina"
              />
            </div>
            <div className="form-group form-full">
              <label>Descrição</label>
              <textarea
                value={form.description}
                onChange={e => setForm(f => ({ ...f, description: e.target.value }))}
                placeholder="Descrição da disciplina"
                rows={3}
              />
            </div>
          </div>
          <div className="form-actions">
            <button className="btn-secondary" onClick={resetForm}>Cancelar</button>
            <button className="btn-primary" onClick={handleSave} disabled={saving}>
              {saving ? 'Salvando...' : editingId ? 'Salvar Alterações' : 'Criar Disciplina'}
            </button>
          </div>
        </div>
      )}

      <div className="admin-table">
        <div className="table-header">
          <span className="col-icon">Ícone</span>
          <span className="col-name">Disciplina</span>
          <span className="col-stats">Aulas</span>
          <span className="col-stats">Materiais</span>
          <span className="col-stats">Quiz</span>
          <span className="col-order">Ordem</span>
          <span className="col-actions">Ações</span>
        </div>

        {disciplines.map(disc => (
          <div key={disc.id} className="table-row">
            <span className="col-icon">{disc.icon || '📚'}</span>
            <div className="col-name">
              <strong>{disc.name}</strong>
              <small>{disc.description}</small>
            </div>
            <span className="col-stats">{disc.lessons?.[0]?.count || 0}</span>
            <span className="col-stats">{disc.materials?.[0]?.count || 0}</span>
            <span className="col-stats">{disc.quiz_questions?.[0]?.count || 0}</span>
            <span className="col-order">{disc.order_index}</span>
            <div className="col-actions">
              <button
                className="btn-icon btn-edit-inline"
                onClick={() => handleEdit(disc)}
                title="Editar informações"
              >
                ✏️
              </button>
              <Link
                to={`/admin/disciplinas/${disc.id}`}
                className="btn-icon btn-manage"
                title="Gerenciar conteúdo"
              >
                <FiEdit2 />
              </Link>
              <button
                className="btn-icon btn-delete"
                onClick={() => handleDelete(disc.id, disc.name)}
                title="Excluir"
              >
                <FiTrash2 />
              </button>
            </div>
          </div>
        ))}

        {disciplines.length === 0 && (
          <div className="table-empty">
            <p>Nenhuma disciplina cadastrada.</p>
            <p>Clique em <strong>"Nova Disciplina"</strong> para começar.</p>
          </div>
        )}
      </div>
    </div>
  )
}
