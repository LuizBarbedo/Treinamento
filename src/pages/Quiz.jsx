import { useEffect, useState } from 'react'
import { useParams, Link } from 'react-router-dom'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import AIChat from '../components/AIChat'
import './Quiz.css'

export default function Quiz() {
  const { id } = useParams()
  const { user } = useAuth()
  const [discipline, setDiscipline] = useState(null)
  const [questions, setQuestions] = useState([])
  const [answers, setAnswers] = useState({})
  const [submitted, setSubmitted] = useState(false)
  const [score, setScore] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchQuiz()
  }, [id])

  const fetchQuiz = async () => {
    const [discRes, questionsRes] = await Promise.all([
      supabase.from('disciplines').select('*').eq('id', id).single(),
      supabase.from('quiz_questions').select('*').eq('discipline_id', id).order('order_index')
    ])

    if (discRes.data) setDiscipline(discRes.data)
    if (questionsRes.data) setQuestions(questionsRes.data)
    setLoading(false)
  }

  const handleAnswer = (questionId, optionIndex) => {
    if (submitted) return
    setAnswers(prev => ({ ...prev, [questionId]: optionIndex }))
  }

  const handleSubmit = async () => {
    if (Object.keys(answers).length < questions.length) {
      alert('Por favor, responda todas as questões antes de enviar.')
      return
    }

    let correct = 0
    questions.forEach(q => {
      if (answers[q.id] === q.correct_option) {
        correct++
      }
    })

    const finalScore = Math.round((correct / questions.length) * 100)
    setScore(finalScore)
    setSubmitted(true)

    // Salvar resultado
    await supabase.from('quiz_results').upsert({
      user_id: user.id,
      discipline_id: id,
      score: finalScore,
      total_questions: questions.length,
      correct_answers: correct,
      completed_at: new Date().toISOString()
    }, {
      onConflict: 'user_id,discipline_id'
    })

    // Atualizar progresso se passou (>= 70%)
    if (finalScore >= 70) {
      await supabase.from('user_progress').upsert({
        user_id: user.id,
        discipline_id: id,
        completed: true,
        completed_at: new Date().toISOString()
      }, {
        onConflict: 'user_id,discipline_id'
      })
    }
  }

  const resetQuiz = () => {
    setAnswers({})
    setSubmitted(false)
    setScore(null)
  }

  if (loading) {
    return <div className="loading-screen"><div className="spinner"></div></div>
  }

  if (!discipline) {
    return <div className="error-state">Disciplina não encontrada.</div>
  }

  return (
    <div className="quiz-page">
      <Link to={`/disciplinas/${id}`} className="back-link">← Voltar para {discipline.name}</Link>

      <div className="quiz-header">
        <h1>📝 Quiz: {discipline.name}</h1>
        <p>Responda todas as questões. Você precisa de pelo menos 70% para ser aprovado.</p>
      </div>

      {submitted && (
        <div className={`quiz-result ${score >= 70 ? 'passed' : 'failed'}`}>
          <div className="result-score">{score}%</div>
          <div className="result-text">
            {score >= 70
              ? '🎉 Parabéns! Você foi aprovado!'
              : '😕 Você não atingiu a pontuação mínima. Tente novamente!'}
          </div>
          <button className="btn-retry" onClick={resetQuiz}>
            Refazer Quiz
          </button>
        </div>
      )}

      {questions.length === 0 ? (
        <div className="empty-state">
          <p>Nenhuma questão cadastrada para esta disciplina.</p>
        </div>
      ) : (
        <div className="questions-list">
          {questions.map((q, qIndex) => (
            <div key={q.id} className="question-card">
              <div className="question-header">
                <span className="question-number">Questão {qIndex + 1}</span>
              </div>
              <p className="question-text">{q.question}</p>

              <div className="options-list">
                {q.options.map((option, oIndex) => {
                  let optionClass = 'option'
                  if (answers[q.id] === oIndex) optionClass += ' selected'
                  if (submitted) {
                    if (oIndex === q.correct_option) optionClass += ' correct'
                    else if (answers[q.id] === oIndex) optionClass += ' wrong'
                  }

                  return (
                    <button
                      key={oIndex}
                      className={optionClass}
                      onClick={() => handleAnswer(q.id, oIndex)}
                      disabled={submitted}
                    >
                      <span className="option-letter">
                        {String.fromCharCode(65 + oIndex)}
                      </span>
                      <span className="option-text">{option}</span>
                    </button>
                  )
                })}
              </div>
            </div>
          ))}

          {!submitted && (
            <button className="btn-submit-quiz" onClick={handleSubmit}>
              Enviar Respostas
            </button>
          )}
        </div>
      )}

      <AIChat discipline={discipline} lessons={[]} materials={[]} />
    </div>
  )
}
