
import type { LucideIcon } from 'lucide-react';
import { motion } from 'framer-motion';

interface StatCardProps {
  title: string;
  value: string | number;
  icon: LucideIcon;
  trend?: string;
  trendUp?: boolean;
  delay?: number;
  onClick?: () => void;
  className?: string;
}

const StatCard: React.FC<StatCardProps> = ({ 
  title, value, icon: Icon, trend, trendUp, delay = 0, onClick, className 
}) => {
  return (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay }}
      onClick={onClick}
      className={`bg-slate-900 border border-slate-800 rounded-2xl p-6 relative overflow-hidden group ${onClick ? 'cursor-pointer hover:border-slate-700 transition-all' : ''} ${className || ''}`}
    >
      <div className="absolute top-0 right-0 p-4 opacity-5 group-hover:opacity-10 transition-opacity transform group-hover:scale-110">
        <Icon size={100} />
      </div>

      <div className="flex justify-between items-start relative z-10">
        <div>
          <p className="text-slate-400 font-medium text-sm mb-1 uppercase tracking-wider">{title}</p>
          <h3 className="text-3xl font-bold text-white mb-2">{value}</h3>
          
          {trend && (
            <div className={`flex items-center text-sm font-medium ${trendUp ? 'text-emerald-400' : 'text-rose-400'}`}>
              <span className="mr-1">{trendUp ? '↑' : '↓'}</span>
              <span>{trend} so với hôm qua</span>
            </div>
          )}
        </div>
        <div className={`p-3 rounded-xl border ${trendUp ? 'bg-emerald-500/10 border-emerald-500/20 text-emerald-400' : 'bg-rose-500/10 border-rose-500/20 text-rose-400'}`}>
          <Icon size={24} />
        </div>
      </div>
    </motion.div>
  );
};

export default StatCard;
