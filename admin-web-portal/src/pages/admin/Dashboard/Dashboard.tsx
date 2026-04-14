import { useState, useEffect } from 'react';
import StatCard from '../../../components/common/StatCard/StatCard';
import { Users, Activity, ShieldAlert, ArrowRightLeft } from 'lucide-react';
import { motion } from 'framer-motion';
import { dashboardApi, type DashboardStats } from '../../../services/api/dashboard.api';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

const Dashboard = () => {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const data = await dashboardApi.getStats();
        setStats(data);
      } catch (error) {
        console.error('Failed to fetch dashboard stats', error);
      } finally {
        setLoading(false);
      }
    };
    fetchStats();
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
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard title="Tổng Người Dùng" value={stats?.totalUsers || 0} icon={Users} trend="+12%" trendUp={true} delay={0.1} />
        <StatCard title="Giao Dịch Hôm Nay" value={stats?.todayTransactions || 0} icon={ArrowRightLeft} trend="+5%" trendUp={true} delay={0.2} />
        <StatCard title="Thẻ Bị Khóa" value={stats?.lockedUsers || 0} icon={ShieldAlert} trend="-2%" trendUp={false} delay={0.3} />
        <StatCard title="Máy Chủ (Uptime)" value={`${stats?.uptime || 99.9}%`} icon={Activity} trend="Ổn định" trendUp={true} delay={0.4} />
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
            <button className="text-sm text-cyan-400 hover:underline">Xem Chi Tiết</button>
          </div>
          <div className="w-full h-72 bg-slate-950/30 rounded-xl p-4">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={stats?.chartData}>
                <defs>
                  <linearGradient id="colorValue" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#2563eb" stopOpacity={0.3}/>
                    <stop offset="95%" stopColor="#2563eb" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="#1e293b" vertical={false} />
                <XAxis dataKey="name" stroke="#64748b" fontSize={12} tickLine={false} axisLine={false} />
                <YAxis stroke="#64748b" fontSize={12} tickLine={false} axisLine={false} />
                <Tooltip 
                  contentStyle={{ backgroundColor: '#0f172a', border: '1px solid #1e293b', borderRadius: '8px' }}
                  itemStyle={{ color: '#22d3ee' }}
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
            {stats?.recentActivities.map((activity, i) => (
              <div key={i} className="flex items-start gap-4 pb-4 border-b border-slate-800 last:border-0 hover:bg-slate-800/30 transition-colors p-2 rounded-lg">
                <div className={`w-2 h-2 rounded-full mt-2 ${activity.type === 'USER_REGISTER' ? 'bg-cyan-400' : 'bg-blue-500'}`}></div>
                <div>
                  <p className="text-sm font-medium text-slate-200">{activity.description}</p>
                  <p className="text-xs text-slate-500 mt-1">{activity.timeAgo}</p>
                </div>
              </div>
            ))}
          </div>
          <button className="w-full mt-4 py-2 border border-slate-700 text-slate-300 rounded-xl hover:bg-slate-800 transition-colors text-sm font-medium">
            Tất cả Logs
          </button>
        </motion.div>
      </div>
    </div>
  );
};

export default Dashboard;
