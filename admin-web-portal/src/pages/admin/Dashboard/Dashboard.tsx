import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import StatCard from '../../../components/common/StatCard/StatCard';
import { Users, ShieldAlert, ArrowRightLeft } from 'lucide-react';
import { motion } from 'framer-motion';
import { dashboardApi, type DashboardStats } from '../../../services/api/dashboard.api';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

const Dashboard = () => {
  const navigate = useNavigate();
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [loading, setLoading] = useState(true);

  const formatCurrency = (value: number) => {
    if (value >= 1000000) return `${(value / 1000000).toFixed(1)}M`;
    if (value >= 1000) return `${(value / 1000).toFixed(1)}K`;
    return value.toString();
  };

  const formatFullCurrency = (value: number) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
  };

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const data = await dashboardApi.getStats();
        setStats(data);
      } catch (error) {
        console.error('Failed to fetch dashboard stats', error);
      }
    };

    const initialFetch = async () => {
      setLoading(true);
      await fetchStats();
      setLoading(false);
    };

    initialFetch();

    // Thiết lập Polling: Cập nhật mỗi 30 giây
    const interval = setInterval(fetchStats, 30000);

    // Dọn dẹp interval khi component unmount
    return () => clearInterval(interval);
  }, []);

  if (loading) {
    return <div className="text-white">Loading Dashboard...</div>;
  }

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-2xl font-bold text-white mb-1">System Overview</h1>
        <p className="text-slate-400 text-sm">Báo cáo tổng quan hệ thống Core Banking ngày hôm nay.</p>
      </div>

      {/* Row 1: Stat Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <StatCard 
          title="Tổng Người Dùng" 
          value={stats?.totalUsers || 0} 
          icon={Users} 
          trend="+12%" 
          trendUp={true} 
          delay={0.1} 
          onClick={() => navigate('/admin/users')}
        />
        <StatCard 
          title="Giao Dịch Hôm Nay" 
          value={stats?.todayTransactions || 0} 
          icon={ArrowRightLeft} 
          trend="+5%" 
          trendUp={true} 
          delay={0.2} 
          onClick={() => navigate('/admin/transactions')}
        />
        <StatCard 
          title="Thẻ Bị Khóa" 
          value={stats?.lockedUsers || 0} 
          icon={ShieldAlert} 
          trend="-2%" 
          trendUp={false} 
          delay={0.3} 
        />
      </div>

      {/* Row 2: Charts and Live Logs */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Chart Section */}
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.5, delay: 0.5 }}
          className="lg:col-span-2 bg-slate-900 border border-slate-800 rounded-2xl p-6"
        >
          <div className="flex justify-between items-center mb-6">
            <h3 className="text-lg font-bold text-white">Biểu đồ Dòng Tiền (Tháng)</h3>
            <button 
              onClick={() => navigate('/admin/transactions')}
              className="text-sm text-blue-400 hover:text-blue-300 transition-colors"
            >
              Xem Chi Tiết
            </button>
          </div>
          <div className="w-full h-72 bg-slate-950/30 rounded-xl p-4">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={stats?.chartData}>
                <defs>
                  <linearGradient id="colorValue" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.3} />
                    <stop offset="95%" stopColor="#3b82f6" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="#1e293b" vertical={false} />
                <XAxis dataKey="name" stroke="#64748b" fontSize={10} tickLine={false} axisLine={false} />
                <YAxis 
                  stroke="#64748b" 
                  fontSize={10} 
                  tickLine={false} 
                  axisLine={false} 
                  tickFormatter={formatCurrency}
                />
                <Tooltip 
                  contentStyle={{ backgroundColor: '#0f172a', border: '1px solid #1e293b', borderRadius: '12px', boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.5)' }}
                  itemStyle={{ color: '#3b82f6', fontWeight: 'bold' }}
                  labelStyle={{ color: '#94a3b8', marginBottom: '4px' }}
                  formatter={(value: number) => [
                    formatFullCurrency(value),
                    'Tổng dòng tiền'
                  ]}
                />
                <Area type="monotone" dataKey="value" stroke="#3b82f6" fillOpacity={1} fill="url(#colorValue)" strokeWidth={3} />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </motion.div>

        {/* Live Logs Section */}
        <motion.div
          initial={{ opacity: 0, x: 20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ duration: 0.5, delay: 0.6 }}
          className="bg-slate-900 border border-slate-800 rounded-2xl p-6 flex flex-col"
        >
          <h3 className="text-lg font-bold text-white mb-6">Logs Giao Dịch Mới Nhất</h3>
          <div className="flex-1 space-y-4 overflow-y-auto pr-2 custom-scrollbar">
            {stats?.recentActivities.map((activity) => (
              <div key={activity.id} className="flex items-start gap-4 pb-4 border-b border-slate-800 last:border-0 hover:bg-slate-800/30 transition-colors p-2 rounded-lg">
                <div className={`w-2 h-2 rounded-full mt-2 ${
                  activity.action.includes('REGISTER') ? 'bg-blue-400' : 
                  activity.action.includes('TRANSFER') ? 'bg-yellow-400' : 'bg-green-500'
                }`}></div>
                <div className="flex-1">
                  <div className="flex justify-between items-start">
                    <div className="flex items-center gap-2">
                      <span className="text-xs font-bold text-blue-400 bg-blue-400/10 px-2 py-0.5 rounded uppercase">
                        @{activity.username}
                      </span>
                      <span className={`text-[10px] px-1.5 py-0.5 rounded ${
                        activity.status === 'SUCCESS' || activity.status === 'COMPLETED' ? 'text-green-400 bg-green-400/10' : 'text-red-400 bg-red-400/10'
                      }`}>
                        {activity.status}
                      </span>
                    </div>
                    <p className="text-[10px] text-slate-500 font-mono">
                      {new Date(activity.createdAt).toLocaleTimeString()}
                    </p>
                  </div>
                  <p className="text-sm font-medium text-slate-200 mt-1">{activity.details}</p>
                  <p className="text-[10px] text-slate-500 mt-0.5 italic">{activity.timeAgo}</p>
                </div>
              </div>
            ))}
          </div>
          <button 
            onClick={() => navigate('/admin/logs')}
            className="w-full mt-4 py-2 border border-slate-800 text-slate-400 rounded-xl hover:bg-slate-800 hover:text-white transition-all text-sm font-medium"
          >
            Tất cả Logs
          </button>
        </motion.div>
      </div>
    </div>
  );
};

export default Dashboard;
