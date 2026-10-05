const express = require("express");
const cors = require("cors");
const db = require("./db");

// Updated by Prakash - Server v2.0


const app = express();
app.use(cors());
app.use(express.json());

// Register
app.post("/api/register", (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ error: "Fill all fields" });
  try {
    const r = db.prepare("INSERT INTO users (username, password) VALUES (?, ?)").run(username, password);
    res.json({ id: r.lastInsertRowid, username });
  } catch (e) {
    res.status(400).json({ error: "Username already exists" });
  }
});

// Login (plain password compare)
app.post("/api/login", (req, res) => {
  const { username, password } = req.body;
  const user = db.prepare("SELECT id, username FROM users WHERE username = ? AND password = ?").get(username, password);
  if (!user) return res.status(401).json({ error: "Wrong username or password" });
  res.json(user);
});

// Get todos of a user
app.get("/api/todos", (req, res) => {
  const todos = db.prepare("SELECT * FROM todos WHERE user_id = ? ORDER BY id DESC").all(req.query.userId);
  res.json(todos);
});

// Add todo
app.post("/api/todos", (req, res) => {
  const { userId, title } = req.body;
  if (!title) return res.status(400).json({ error: "Title required" });
  const r = db.prepare("INSERT INTO todos (user_id, title) VALUES (?, ?)").run(userId, title);
  res.json({ id: r.lastInsertRowid, user_id: userId, title, done: 0 });
});

// Toggle done
app.put("/api/todos/:id", (req, res) => {
  db.prepare("UPDATE todos SET done = 1 - done WHERE id = ?").run(req.params.id);
  res.json({ ok: true });
});

// Delete todo
app.delete("/api/todos/:id", (req, res) => {
  db.prepare("DELETE FROM todos WHERE id = ?").run(req.params.id);
  res.json({ ok: true });
});

app.listen(3001, () => console.log("Backend running on http://localhost:3001"));
