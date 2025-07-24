import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import WelcomePage from './WelcomePage.jsx'; // 欢迎页
import UserJoinPage from './UserJoinPage.jsx'; // 输入用户名即可
import AdminAuthPage from './AdminAuthPage.jsx'; // 登录 / 注册页
import UserActivity from './UserActivity.jsx'; // 用户活动监控页
import AdminDashboard from './AdminDashboard.jsx'; // 管理员仪表盘
import { useNavigate } from 'react-router-dom';
import './App.css'; // 全局样式
import React, { useEffect, useState } from 'react';


function NavBar() {
  const navigate = useNavigate();


  useEffect(() => {
    const token = localStorage.getItem('adminToken');
    if (!token) {
    }
  }, [navigate]);

  return (
    <div style={{
      background: 'linear-gradient(to right, #0f2027, #203a43, #2c5364)',
      padding: '1rem 2rem',
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center',
      color: '#fff',
      fontWeight: '500',
      fontSize: '1.1rem',
      boxShadow: '0 2px 10px rgba(0,0,0,0.3)',
      position: 'sticky',
      top: 0,
      zIndex: 999,
    }}>
      <div style={{ cursor: 'pointer' }} onClick={() => navigate('/')}>🏠 Welcome</div>
      <div style={{ display: 'flex', gap: '1.5rem' }}>
        <div style={{ cursor: 'pointer' }} onClick={() => navigate('/user')}>👤 User</div>
        <div style={{ cursor: 'pointer' }} onClick={() => navigate('/admin')}>🛡️ Admin</div>
      </div>
    </div>
  );
}


function AppRoutes() {
  return (
    <>
      <NavBar />
      <div>
        <Routes>
          <Route path="/" element={<WelcomePage />} />
          <Route path="/user" element={<UserJoinPage />} />
          <Route path="/admin" element={<AdminAuthPage />} />
          <Route path="/user-activity/:userId" element={<UserActivity />} />
          <Route path="/adminDashboard" element={<AdminDashboard />} />
        </Routes>
      </div>
    </>
  );
}

export default function App() {
  return (
    <Router>
      <AppRoutes />
    </Router>
  );
}

// export default function App() {
//   return (
//     <Router>
//       <Routes>
//         <Route path="/" element={<WelcomePage />} />
//         <Route path="/user" element={<UserJoinPage />} />
//         <Route path="/admin" element={<AdminAuthPage />} />
//         <Route path="/user-activity/:userId" element={<UserActivity />} />
//         {/* 其他页面 */}
//       </Routes>
//     </Router>
//   );
// }

