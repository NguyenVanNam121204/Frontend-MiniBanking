import React, { useState } from 'react';
import { X, UserPlus, Mail, Lock, Shield, Eye, EyeOff } from 'lucide-react';
import { userApi } from '../../../services/api/user.api';
import toast from 'react-hot-toast';

interface CreateUserModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: (username: string) => void;
}

const CreateUserModal: React.FC<CreateUserModalProps> = ({ isOpen, onClose, onSuccess }) => {
  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: '',
    roles: ['USER']
  });
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  if (!isOpen) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!formData.username || !formData.email || !formData.password) {
      toast.error('Vui lòng điền đầy đủ thông tin');
      return;
    }

    try {
      setLoading(true);
      await userApi.createUser(formData);
      const createdUsername = formData.username;
      setFormData({ username: '', email: '', password: '', roles: ['USER'] });
      onSuccess(createdUsername);
    } catch (error: any) {
      const msg = error.response?.data?.message || 'Có lỗi xảy ra khi tạo người dùng';
      toast.error(msg);
    } finally {
      setLoading(false);
    }
  };

  const handleRoleToggle = (role: string) => {
    setFormData(prev => {
      const newRoles = prev.roles.includes(role) 
        ? prev.roles.filter(r => r !== role) 
        : [...prev.roles, role];
      return { ...prev, roles: newRoles.length > 0 ? newRoles : ['USER'] };
    });
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="bg-slate-900 border border-slate-800 rounded-2xl w-full max-w-md overflow-hidden shadow-2xl">
        <div className="flex items-center justify-between p-6 border-b border-slate-800 bg-slate-900/50">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-cyan-500/10 text-cyan-500 rounded-lg">
              <UserPlus size={20} />
            </div>
            <h3 className="text-lg font-bold text-white">Thêm Người Dùng</h3>
          </div>
          <button 
            onClick={onClose}
            className="text-slate-400 hover:text-white p-2 hover:bg-slate-800 rounded-lg transition-colors"
          >
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-6 space-y-5">
          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider ml-1">Username</label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <UserPlus size={16} className="text-slate-500" />
              </div>
              <input
                type="text"
                value={formData.username}
                onChange={(e) => setFormData(prev => ({ ...prev, username: e.target.value }))}
                className="w-full bg-slate-950 border border-slate-800 rounded-xl pl-10 pr-4 py-2.5 text-sm text-slate-200 focus:outline-none focus:border-cyan-500/50 transition-colors"
                placeholder="Nhập tên đăng nhập"
                disabled={loading}
              />
            </div>
          </div>

          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider ml-1">Email</label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Mail size={16} className="text-slate-500" />
              </div>
              <input
                type="email"
                value={formData.email}
                onChange={(e) => setFormData(prev => ({ ...prev, email: e.target.value }))}
                className="w-full bg-slate-950 border border-slate-800 rounded-xl pl-10 pr-4 py-2.5 text-sm text-slate-200 focus:outline-none focus:border-cyan-500/50 transition-colors"
                placeholder="admin@example.com"
                disabled={loading}
                autoComplete="off"
              />
            </div>
          </div>

          <div className="space-y-1.5">
            <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider ml-1">Mật khẩu khởi tạo</label>
            <div className="relative">
              <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <Lock size={16} className="text-slate-500" />
              </div>
              <input
                type={showPassword ? "text" : "password"}
                value={formData.password}
                onChange={(e) => setFormData(prev => ({ ...prev, password: e.target.value }))}
                className="w-full bg-slate-950 border border-slate-800 rounded-xl pl-10 pr-10 py-2.5 text-sm text-slate-200 focus:outline-none focus:border-cyan-500/50 transition-colors"
                placeholder="Nhập mật khẩu"
                disabled={loading}
                autoComplete="new-password"
              />
              <button 
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute inset-y-0 right-0 pr-3 flex items-center text-slate-400 hover:text-slate-300"
                tabIndex={-1}
              >
                {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
              </button>
            </div>
          </div>

          <div className="space-y-2 pt-2">
            <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider ml-1">Phân quyền</label>
            <div className="flex gap-3">
              <label className={`flex-1 flex flex-col items-center gap-2 p-3 rounded-xl border cursor-pointer transition-all ${formData.roles.includes('USER') ? 'bg-slate-800 border-cyan-500 text-cyan-400' : 'bg-slate-950 border-slate-800 text-slate-400 hover:border-slate-700'}`}>
                <input type="checkbox" className="hidden" checked={formData.roles.includes('USER')} onChange={() => handleRoleToggle('USER')} />
                <UserPlus size={20} />
                <span className="text-xs font-bold uppercase">USER</span>
              </label>
              <label className={`flex-1 flex flex-col items-center gap-2 p-3 rounded-xl border cursor-pointer transition-all ${formData.roles.includes('ADMIN') ? 'bg-slate-800 border-purple-500 text-purple-400' : 'bg-slate-950 border-slate-800 text-slate-400 hover:border-slate-700'}`}>
                <input type="checkbox" className="hidden" checked={formData.roles.includes('ADMIN')} onChange={() => handleRoleToggle('ADMIN')} />
                <Shield size={20} />
                <span className="text-xs font-bold uppercase">ADMIN</span>
              </label>
            </div>
          </div>

          <div className="pt-4 flex gap-3">
            <button 
              type="button" 
              onClick={onClose} 
              disabled={loading}
              className="flex-1 py-2.5 rounded-xl text-slate-300 font-semibold hover:bg-slate-800 transition-colors"
            >
              Hủy
            </button>
            <button 
              type="submit" 
              disabled={loading}
              className="flex-1 py-2.5 rounded-xl bg-cyan-600 hover:bg-cyan-500 text-white font-semibold transition-colors flex justify-center items-center gap-2 disabled:opacity-50"
            >
              {loading ? <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></div> : 'Tạo mới'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default CreateUserModal;
