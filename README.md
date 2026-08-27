# Treinamento

Plataforma de e-learning gamificada, desenvolvida com React, Vite e Supabase. Permite que alunos estudem disciplinas sequenciais, realizem quizzes, tirem dúvidas com monitores e acumulem badges de conquistas.

Teste de deploy automatico 3.

Teste de deploy automatico.

## Funcionalidades

- **Autenticação** – cadastro, login, recuperação e redefinição de senha.
- **Disciplinas** – trilha sequencial de matérias; a próxima disciplina só é desbloqueada após concluir a anterior.
- **Aulas e Quizzes** – cada disciplina possui aulas com quiz individual e quiz final.
- **Badges / Conquistas** – sistema de gamificação com medalhas de bronze, prata, ouro e diamante conquistadas conforme o desempenho nos quizzes.
- **Fórum** – espaço de discussão aberto para os alunos.
- **Minhas Dúvidas** – alunos podem enviar perguntas que são respondidas por monitores.
- **Chat com IA** – assistente integrado com o Google Gemini para tirar dúvidas.
- **Painel do Monitor** – monitores acompanham o progresso dos alunos e respondem dúvidas.
- **Painel Administrativo** – administradores gerenciam disciplinas, relatórios e monitores.

## Tecnologias

| Camada | Tecnologia |
|--------|-----------|
| Frontend | React 19 + Vite |
| Roteamento | React Router DOM v7 |
| Backend / BD | Supabase (PostgreSQL + Auth + Storage) |
| IA | Ollama (Cloud/Turbo) |
| Ícones | React Icons |

## Pré-requisitos

- Node.js 18+ (ou Bun)
- Conta no [Supabase](https://supabase.com/) com o schema aplicado (`supabase/schema.sql`)
- Chave de API do [Ollama Cloud/Turbo](https://ollama.com/)

## Configuração

1. Clone o repositório e instale as dependências:

   ```bash
   npm install
   ```

2. Copie o arquivo de exemplo de variáveis de ambiente e preencha os valores:

   ```bash
   cp .env.example .env
   ```

   | Variável | Descrição |
   |----------|-----------|
   | `VITE_SUPABASE_URL` | URL do projeto Supabase |
   | `VITE_SUPABASE_ANON_KEY` | Chave anônima do Supabase |
   | `VITE_OLLAMA_BASE_URL` | URL base da API do Ollama (ex.: `https://ollama.com`) |
   | `VITE_OLLAMA_MODEL` | Nome do modelo a ser usado (ex.: `qwen3.6:120b`) |
   | `VITE_OLLAMA_API_KEY` | Chave de API do Ollama Cloud/Turbo |
   | `VITE_PASSWORD_RESET_REDIRECT_URL` | URL completa de redefinição de senha (ex.: `https://capacitaportos.com.br/redefinir-senha`) |

3. Aplique as migrações no Supabase executando os arquivos da pasta `supabase/` (começando por `schema.sql` e depois os arquivos `migration_*.sql`).

## Executando localmente

```bash
npm run dev
```

A aplicação estará disponível em `http://localhost:5173`.

## Build de produção

```bash
npm run build
npm run preview
```

## Estrutura do projeto

```
src/
├── components/   # Componentes reutilizáveis (Layout, Badges, AIChat…)
├── contexts/     # Contexto de autenticação
├── lib/          # Clientes Supabase, lógica de badges
├── pages/        # Páginas da aplicação
│   ├── admin/    # Páginas do painel administrativo
│   └── monitor/  # Páginas do painel do monitor
└── assets/       # Recursos estáticos
```
