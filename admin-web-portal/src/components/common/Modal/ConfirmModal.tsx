import React from 'react';
import { AlertTriangle, X, CheckCircle2 } from 'lucide-react';

interface ConfirmModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  message: string;
  confirmText?: string;
  type?: 'danger' | 'success' | 'warning';
  isLoading?: boolean;
}

const ConfirmModal: React.FC<ConfirmModalProps> = ({
  isOpen,
  onClose,
  onConfirm,
  title,
  message,
  confirmText = 'Xác nhận',
  type = 'warning',
  isLoading = false
}) => {
  if (!isOpen) return null;

  const colors = {
    danger: 'bg-red-500/10 text-red-500 border-red-500/20',
    success: 'bg-green-500/10 text-green-500 border-green-500/20',
    warning: 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20'
  };

  const btnColors = {
    danger: 'bg-red-600 hover:bg-red-700 shadow-red-900/20',
    success: 'bg-green-600 hover:bg-green-700 shadow-green-900/20',
    warning: 'bg-yellow-600 hover:bg-yellow-700 shadow-yellow-900/20'
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
        <div className="p-6">
          <div className="flex justify-between items-start mb-4">
            <div className={`p-3 rounded-xl border ${colors[type]}`}>
              {type === 'danger' || type === 'warning' ? <AlertTriangle size={24} /> : <CheckCircle2 size={24} />}
            </div>
            <button 
              onClick={onClose}
              className="p-1 text-slate-500 hover:text-white transition-colors"
            >
              <X size={20} />
            </button>
          </div>

          <h3 className="text-xl font-bold text-white mb-2">{title}</h3>
          <p className="text-slate-400 text-sm leading-relaxed">
            {message}
          </p>
        </div>

        <div className="p-6 bg-slate-800/50 flex gap-3">
          <button
            onClick={onClose}
            className="flex-1 py-2.5 px-4 rounded-xl border border-slate-700 text-slate-300 font-semibold hover:bg-slate-800 transition-all active:scale-95"
          >
            Hủy bỏ
          </button>
          <button
            onClick={onConfirm}
            disabled={isLoading}
            className={`flex-1 py-2.5 px-4 rounded-xl text-white font-semibold shadow-lg transition-all active:scale-95 disabled:opacity-50 ${btnColors[type]}`}
          >
            {isLoading ? (
              <div className="flex items-center justify-center gap-2">
                <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
                Đang xử lý...
              </div>
            ) : confirmText}
          </button>
        </div>
      </div>
    </div>
  );
};

export default ConfirmModal;
