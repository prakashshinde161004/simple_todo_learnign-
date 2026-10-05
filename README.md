# Simple Todo App (React + Express + SQLite)

Learning project. Passwords are stored as plain text and there is no JWT on purpose - NOT for real use.

## Structure
- backend/   Express API + SQLite database (file: app.db, created automatically)
- frontend/  React app (Vite)

## Run (needs Node.js 18+)

Terminal 1 - backend:
    cd backend
    npm install
    npm start          (runs on http://localhost:3001)

Terminal 2 - frontend:
    cd frontend
    npm install
    npm run dev        (open http://localhost:5173)

## API
POST   /api/register      { username, password }
POST   /api/login         { username, password }  -> { id, username }
GET    /api/todos?userId=1
POST   /api/todos         { userId, title }
PUT    /api/todos/:id     toggles done
DELETE /api/todos/:id
