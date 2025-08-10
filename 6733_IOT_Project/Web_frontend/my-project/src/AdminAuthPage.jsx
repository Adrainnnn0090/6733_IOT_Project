import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import './AdminAuthPage.css'; // 引入美化样式

function AdminAuthPage() {
  const [isRegistering, setIsRegistering] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [token, setToken] = useState('');
  const [message, setMessage] = useState('');
  const navigate = useNavigate();

  const handleAuth = async () => {
    try {
      const url = isRegistering
        ? 'http://adddd.local:8251/admin/register'
        : 'http://adddd.local:8251/admin/login';
      const payload = isRegistering ? { email, password, name } : { email, password };

      console.log("Submitting payload:", payload);

      const response = await axios.post(url, payload);
      setToken(response.data.token);
      localStorage.setItem('adminToken', response.data.token);
      setMessage(`✅ ${isRegistering ? 'Registered' : 'Logged in'} successfully!`);

      setTimeout(() => {
        navigate('/adminDashboard', { state: { token: response.data.token } });
      }, 1000);
    } catch (err) {
      setMessage(`❌ Error: ${err.response?.data?.error || err.message}`);
    }
  };

  return (
    <div className="admin-container">
      <div className="admin-card">
        <h2>{isRegistering ? 'Admin Register' : 'Admin Login'}</h2>

        <input
          type="text"
          placeholder="📧 Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="admin-input"
        />

        <input
          type="password"
          placeholder="🔑 Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="admin-input"
        />

        {isRegistering && (
          <input
            type="text"
            placeholder="👤 Name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="admin-input"
          />
        )}

        <div className="admin-button-group">
          <button onClick={handleAuth} className="admin-btn-primary">
            {isRegistering ? 'Register' : 'Login'}
          </button>
          <button
            onClick={() => {
              setIsRegistering(!isRegistering);
              setMessage('');
            }}
            className="admin-btn-secondary"
          >
            {isRegistering ? '← Back to Login' : '→ Switch to Register'}
          </button>
        </div>

        <button onClick={() => navigate('/user')} className="admin-go-user">
          👤 Go to User Page
        </button>

        {token && (
          <div className="admin-token">
            <p><strong>Token:</strong> {token}</p>
          </div>
        )}

        {message && <p className="admin-message">{message}</p>}
      </div>
    </div>
  );
}

export default AdminAuthPage;