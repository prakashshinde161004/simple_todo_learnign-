import { useState, useEffect } from "react";

async function api(url, method = "GET", body) {
  const res = await fetch(url, {
    method,
    headers: { "Content-Type": "application/json" },
    body: body ? JSON.stringify(body) : undefined,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || "Something went wrong");
  return data;
}

function Auth({ onLogin }) {
  const [isRegister, setIsRegister] = useState(false);
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  async function submit() {
    try {
      setError("");
      const url = isRegister ? "/api/register" : "/api/login";
      const user = await api(url, "POST", { username, password });
      onLogin(user);
    } catch (e) {
      setError(e.message);
    }
  }

  return (
    <div className="card">
      <h2>{isRegister ? "Register" : "Login"}</h2>
      <input placeholder="Username" value={username} onChange={(e) => setUsername(e.target.value)} />
      <input type="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} />
      <button onClick={submit}>{isRegister ? "Register" : "Login"}</button>
      {error && <p className="error">{error}</p>}
      <p className="link" onClick={() => setIsRegister(!isRegister)}>
        {isRegister ? "Already have an account? Login" : "No account? Register"}
      </p>
    </div>
  );
}

function Todos({ user, onLogout }) {
  const [todos, setTodos] = useState([]);
  const [title, setTitle] = useState("");

  async function load() {
    setTodos(await api(`/api/todos?userId=${user.id}`));
  }

  useEffect(() => {
    load();
  }, []);

  async function add() {
    if (!title.trim()) return;
    await api("/api/todos", "POST", { userId: user.id, title });
    setTitle("");
    load();
  }

  async function toggle(id) {
    await api(`/api/todos/${id}`, "PUT");
    load();
  }

  async function remove(id) {
    await api(`/api/todos/${id}`, "DELETE");
    load();
  }

  return (
    <div className="card">
      <div className="row">
        <h2>{user.username}'s todos</h2>
        <button className="small" onClick={onLogout}>Logout</button>
      </div>
      <div className="row">
        <input placeholder="New todo..." value={title} onChange={(e) => setTitle(e.target.value)} />
        <button onClick={add}>Add</button>
      </div>
      <ul>
        {todos.map((t) => (
          <li key={t.id}>
            <span className={t.done ? "done" : ""} onClick={() => toggle(t.id)}>
              {t.title}
            </span>
            <button className="small danger" onClick={() => remove(t.id)}>x</button>
          </li>
        ))}
      </ul>
      {todos.length === 0 && <p>No todos yet.</p>}
    </div>
  );
}

export default function App() {
  const [user, setUser] = useState(null);
  return user ? <Todos user={user} onLogout={() => setUser(null)} /> : <Auth onLogin={setUser} />;
}
