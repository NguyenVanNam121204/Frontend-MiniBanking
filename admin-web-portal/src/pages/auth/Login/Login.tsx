import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import { authApi } from '../../../services/api/auth.api';
import { useAuthStore } from '../../../store/useAuthStore';
import { Eye, EyeOff } from 'lucide-react';
import './Login.css';

const Login = () => {
  const [usernameOrEmail, setUsernameOrEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [errorMap, setErrorMap] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const setAuth = useAuthStore((state) => state.setAuth);
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMap(null);
    setIsLoading(true);

    try {
      const response = await authApi.login({ username: usernameOrEmail, password });
      setAuth(response.data.accessToken, response.data.refreshToken);
      navigate('/admin/dashboard');
    } catch (error: any) {
      if (error.response?.status === 401 || error.response?.status === 400 || error.response?.status === 404) {
        setErrorMap(error.response?.data?.message || 'Tài khoản hoặc mật khẩu không chính xác');
      } else {
        setErrorMap('Không thể kết nối đến Server, vui lòng thử lại sau.');
      }
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="login-wrapper">
      <motion.div animate={{ scale: [1, 1.2, 1], opacity: [0.3, 0.5, 0.3] }} transition={{ duration: 8, repeat: Infinity }} className="neon-glow glow-1" />
      <motion.div animate={{ scale: [1, 1.1, 1], opacity: [0.2, 0.4, 0.2] }} transition={{ duration: 6, repeat: Infinity, delay: 2 }} className="neon-glow glow-2" />

      <motion.div
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, ease: "easeOut" }}
        className="glass-card"
      >
        <div className="text-center mb-8">
          <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ delay: 0.3, type: "spring" }} className="w-16 h-16 mx-auto bg-gradient-to-tr from-blue-600 to-cyan-400 rounded-2xl rotate-12 flex items-center justify-center mb-6 shadow-[0_0_30px_rgba(34,211,238,0.4)]">
            <span className="text-white font-bold text-2xl -rotate-12">CB</span>
          </motion.div>
          <h1 className="text-3xl font-bold text-white mb-2 tracking-tight">Admin Portal</h1>
          <p className="text-slate-400 text-sm font-light tracking-wide">Secure Core Banking Access</p>
        </div>

        <form onSubmit={handleLogin} className="space-y-6">
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider ml-1">Email / Username</label>
            <input
              type="text"
              placeholder="Nhập email của bạn..."
              className="input-field bg-slate-800/60"
              value={usernameOrEmail}
              onChange={(e) => setUsernameOrEmail(e.target.value)}
              required
            />
          </div>

          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider ml-1">Mật Khẩu</label>
            <div className="relative">
              <input
                type={showPassword ? "text" : "password"}
                placeholder="Nhập mật khẩu..."
                className="input-field bg-slate-800/60 pr-12"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-400 hover:text-cyan-400 transition-colors"
              >
                {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
              </button>
            </div>
          </div>

          {errorMap && (
            <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: 'auto' }} className="text-red-400 text-sm text-center bg-red-500/10 py-3 rounded-xl border border-red-500/20 shadow-inner">
              {errorMap}
            </motion.div>
          )}

          <button type="submit" disabled={isLoading} className="btn-primary flex justify-center items-center mt-2 group">
            {isLoading ? (
              <svg className="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
            ) : (
              <span className="flex items-center gap-2">
                LOGIN
                <motion.span className="inline-block group-hover:translate-x-1 transition-transform">→</motion.span>
              </span>
            )}
          </button>
        </form>
      </motion.div>
    </div>
  );
};

export default Login;
