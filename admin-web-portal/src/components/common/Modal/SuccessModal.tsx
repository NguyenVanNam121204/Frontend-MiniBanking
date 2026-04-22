import React from 'react';
import { CheckCircle2, X } from 'lucide-react';

interface SuccessModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  message: string;
}

const SuccessModal: React.FC<SuccessModalProps> = ({
  isOpen,
  onClose,
  title,
  message
}) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-[110] flex items-center justify-center p-4">
      {/* Backdrop */}
      <div 
        className="absolute inset-0 bg-slate-950/60 backdrop-blur-md animate-in fade-in duration-500"
        onClick={onClose}
      ></div>

      {/* Modal Content */}
      <div className="relative bg-slate-900 border border-slate-800 w-full max-w-sm rounded-3xl shadow-[0_0_50px_rgba(34,197,94,0.2)] p-8 text-center animate-in zoom-in-95 duration-300">
        <button 
          onClick={onClose}
          className="absolute top-4 right-4 p-1 text-slate-500 hover:text-white transition-colors"
        >
          <X size={20} />
        </button>

        <div className="mb-6 relative inline-block">
          <div className="absolute inset-0 bg-green-500 rounded-full blur-2xl opacity-20 animate-pulse"></div>
          <div className="relative bg-green-500/10 p-4 rounded-full border border-green-500/20 text-green-500">
            <CheckCircle2 size={64} strokeWidth={1.5} className="animate-in slide-in-from-bottom-4 duration-500" />
          </div>
        </div>

        <h3 className="text-2xl font-bold text-white mb-3">{title}</h3>
        <p className="text-slate-400 text-sm mb-8">
          {message}
        </p>

        <button
          onClick={onClose}
          className="w-full py-3 bg-green-600 hover:bg-green-700 text-white font-bold rounded-2xl shadow-lg shadow-green-900/20 transition-all active:scale-95"
        >
          Tuyệt vời
        </button>
      </div>
    </div>
  );
};

export default SuccessModal;
