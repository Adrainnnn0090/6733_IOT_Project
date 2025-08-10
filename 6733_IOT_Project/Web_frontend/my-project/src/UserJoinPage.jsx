import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

function UserJoinPage() {
  const [username, setUsername] = useState('');
  const navigate = useNavigate();

  const handleJoin = () => {
    if (!username.trim()) {
      alert('🚫 Please enter a username.');
      return;
    }

    localStorage.setItem('userId', username);
    navigate(`/user-activity/${encodeURIComponent(username)}`);
  };

  return (
    <div style={styles.page}>
      <div style={styles.card}>
        <h2 style={styles.title}>🚶‍♂️ Join User Activity</h2>
        <input
          type="text"
          placeholder="Enter your username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
          style={styles.input}
        />
        <button onClick={handleJoin} style={styles.button}>
          ➡️ Join
        </button>
      </div>
    </div>
  );
}

const styles = {
  page: {
    background: 'linear-gradient(135deg, #f0f2f5, #dbe7f4)',
    minHeight: '100vh',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    fontFamily: '"SF Pro Display", -apple-system, BlinkMacSystemFont, sans-serif',
  },
  card: {
    background: 'rgba(255, 255, 255, 0.7)',
    backdropFilter: 'blur(14px)',
    borderRadius: '24px',
    padding: '2rem 3rem',
    boxShadow: '0 8px 24px rgba(0,0,0,0.15)',
    textAlign: 'center',
    color: '#1a1a1a',
    width: '340px',
    animation: 'fadeIn 0.5s ease-in-out',
  },
  title: {
    fontSize: '1.6rem',
    marginBottom: '1.5rem',
    fontWeight: '600',
    letterSpacing: '0.5px',
  },
  input: {
    width: '100%',
    padding: '0.75rem',
    marginBottom: '1.5rem',
    borderRadius: '10px',
    border: '1px solid #ccc',
    fontSize: '1rem',
    outline: 'none',
    transition: 'all 0.3s ease',
  },
  button: {
    width: '100%',
    padding: '0.75rem',
    borderRadius: '12px',
    background: 'linear-gradient(90deg, #00c9a7, #005f6a)',
    border: 'none',
    color: '#fff',
    fontWeight: '600',
    fontSize: '1rem',
    cursor: 'pointer',
    transition: 'opacity 0.3s ease',
  },
};

export default UserJoinPage;