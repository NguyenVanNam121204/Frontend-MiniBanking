import React, { useState } from 'react';
import { Key, X, Eye, EyeOff, ShieldCheck } from 'lucide-react';

interface ResetPasswordModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: (newPassword: string) => void;
  username: string;
  isLoading?: boolean;
}

const ResetPasswordModal: React.FC<ResetPasswordModalProps> = ({
  isOpen,
  onClose,
  onConfirm,
  username,
  isLoading = false
}) => {
  const [newPassword, setNewPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);

  if (!isOpen) return null;

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (newPassword.length < 6) {
      alert('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }
    onConfirm(newPassword);
    setNewPassword('');
  };

  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-4">
      {/* Backdrop */}
      <div 
        className="absolute inset-0 bg-slate-950/80 backdrop-blur-sm animate-in fade-in duration-300"
        onClick={onClose}
      ></div>

      {/* Modal Content */}
      <div className="relative bg-slate-900 border border-slate-800 w-full max-w-md rounded-2xl shadow-2xl overflow-hidden animate-in zoom-in-95 duration-300">
        <form onSubmit={handleSubmit}>
          <div className="p-6">
            <div className="flex justify-between items-start mb-6">
              <div className="p-3 rounded-xl bg-blue-500/10 text-blue-500 border border-blue-500/20">
                <Key size={24} />
              </div>
              <button 
                type="button"
                onClick={onClose}
                className="p-1 text-slate-500 hover:text-white transition-colors"
              >
                <X size={20} />
              </button>
            </div>

            <h3 className="text-xl font-bold text-white mb-2">Đặt lại mật khẩu</h3>
            <p className="text-slate-400 text-sm mb-6">
              Thiết lập mật khẩu mới cho tài khoản <span className="text-cyan-400 font-semibold">@{username}</span>
            </p>

            <div className="space-y-4">
              <div className="relative">
                <label className="block text-xs font-semibold text-slate-500 uppercase mb-2 ml-1">Mật khẩu mới</label>
                <div className="relative">
                  <input
                    autoFocus
                    type={showPassword ? 'text' : 'password'}
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    placeholder="Nhập mật khẩu tối thiểu 6 ký tự..."
                    className="w-full bg-slate-950 border border-slate-800 rounded-xl py-3 pl-4 pr-12 text-slate-200 focus:outline-none focus:border-blue-500/50 transition-all shadow-inner"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300 transition-colors"
                  >
                    {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                </div>
              </div>

              <div className="flex items-center gap-2 p-3 bg-blue-500/5 rounded-lg border border-blue-500/10 text-[11px] text-blue-400">
                <ShieldCheck size={14} />
                <span>Mật khẩu mới sẽ có hiệu lực ngay sau khi bạn xác nhận.</span>
              </div>
            </div>
          </div>

          <div className="p-6 bg-slate-800/50 flex gap-3">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 py-2.5 px-4 rounded-xl border border-slate-700 text-slate-300 font-semibold hover:bg-slate-800 transition-all active:scale-95"
            >
              Hủy
            </button>
            <button
              type="submit"
              disabled={isLoading || newPassword.length < 6}
              className="flex-1 py-2.5 px-4 rounded-xl bg-blue-600 hover:bg-blue-700 text-white font-semibold shadow-lg shadow-blue-900/20 transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {isLoading ? (
                <div className="flex items-center justify-center gap-2">
                  <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
                  Đang cập nhật...
                </div>
              ) : 'Xác nhận đổi'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default ResetPasswordModal;
