
import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import { LayoutDashboard, Users, CreditCard, Activity, LogOut, Bell, Calendar } from 'lucide-react';
import { useAuthStore } from '../../../store/useAuthStore';
import { useEffect, useState } from 'react';
import './AdminLayout.css';

const parseJwt = (token: string | null) => {
  if (!token) return null;
  try {
    return JSON.parse(atob(token.split('.')[1]));
  } catch (e) {
    return null;
  }
};

const AdminLayout = () => {
  const { token, logout } = useAuthStore();
  const navigate = useNavigate();
  const [username, setUsername] = useState('Admin');

  useEffect(() => {
    const decoded = parseJwt(token);
    if (decoded && decoded.sub) {
      setUsername(decoded.sub);
    }
  }, [token]);

  const now = new Date();
  const days = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
  const dayName = days[now.getDay()];
  const day = now.getDate().toString().padStart(2, '0');
  const month = (now.getMonth() + 1).toString().padStart(2, '0');
  const year = now.getFullYear();
  const currentDate = `${dayName}, ngày ${day} tháng ${month} năm ${year}`;

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const navItems = [
    { name: 'Dashboard', path: '/admin/dashboard', icon: LayoutDashboard },
    { name: 'Người dùng', path: '/admin/users', icon: Users },
    { name: 'Giao dịch', path: '/admin/transactions', icon: CreditCard },
    { name: 'Audit Trail', path: '/admin/logs', icon: Activity },
  ];

  return (
    <div className="flex h-screen bg-slate-950 text-slate-200 font-sans overflow-hidden">
      {/* Sidebar */}
      <aside className="w-64 bg-slate-900 border-r border-slate-800 flex flex-col">
        <div className="h-20 flex items-center px-6 border-b border-slate-800">
          <div className="w-10 h-10 bg-gradient-to-tr from-blue-600 to-cyan-400 rounded-xl flex items-center justify-center rotate-12 shadow-[0_0_15px_rgba(34,211,238,0.3)]">
            <span className="text-white font-bold text-lg -rotate-12">CB</span>
          </div>
          <span className="ml-4 text-xl font-bold tracking-wide text-white">CoreBank</span>
        </div>

        <div className="flex-1 overflow-y-auto py-6 px-4 space-y-2">
          {navItems.map((item) => (
            <NavLink
              key={item.path}
              to={item.path}
              className={({ isActive }) =>
                `flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 ${
                  isActive
                    ? 'bg-blue-600/10 text-cyan-400 border border-blue-500/20'
                    : 'text-slate-400 hover:bg-slate-800/50 hover:text-slate-200'
                }`
              }
            >
              <item.icon size={20} />
              <span className="font-medium">{item.name}</span>
            </NavLink>
          ))}
        </div>

        <div className="p-4 border-t border-slate-800">
          <button
            onClick={handleLogout}
            className="flex items-center gap-3 w-full px-4 py-3 text-red-400 hover:bg-red-500/10 rounded-xl transition-colors"
          >
            <LogOut size={20} />
            <span className="font-medium">Logout</span>
          </button>
        </div>
      </aside>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0">
        {/* Top Header */}
        <header className="h-20 bg-slate-900 border-b border-slate-800 flex items-center justify-between px-8 z-10 sticky top-0">
          <div className="flex items-center hidden relative xl:flex lg:flex md:flex sm:hidden group cursor-default">
            {/* Vùng phát sáng nền khi Hover */}
            <div className="absolute inset-0 bg-gradient-to-r from-blue-500/20 to-cyan-400/20 rounded-2xl blur-xl opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
            
            {/* Widget hiển thị ngày tháng */}
            <div className="relative flex items-center gap-3 px-5 py-2.5 bg-slate-900/80 backdrop-blur-xl border border-slate-700/50 group-hover:border-blue-500/50 rounded-2xl shadow-lg transition-all duration-300">
              <div className="relative p-2.5 rounded-xl bg-gradient-to-br from-blue-500 to-cyan-400 shadow-[0_0_15px_rgba(34,211,238,0.4)] group-hover:scale-110 transition-transform duration-300">
                <Calendar size={18} className="text-white" />
              </div>
              <span className="text-sm font-semibold bg-gradient-to-r from-slate-200 to-white bg-clip-text text-transparent">
                {currentDate}
              </span>
            </div>
          </div>

          <div className="flex items-center gap-6 ml-auto">
            <button className="relative text-slate-400 hover:text-cyan-400 transition-colors">
              <Bell size={22} />
              <span className="absolute -top-1 -right-1 w-2.5 h-2.5 bg-red-500 rounded-full border-2 border-slate-900"></span>
            </button>
            <div className="flex items-center gap-4 pl-6 border-l border-slate-700/50">
              <div className="text-right hidden sm:block">
                <p className="text-[11px] font-medium text-slate-400 uppercase tracking-wider mb-0.5">Welcome back</p>
                <p className="text-sm font-bold bg-gradient-to-r from-blue-400 to-cyan-300 bg-clip-text text-transparent uppercase tracking-wider">{username}</p>
              </div>
              <div className="relative group cursor-pointer">
                {/* Hiệu ứng viền phát sáng */}
                <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-cyan-400 rounded-full blur opacity-40 group-hover:opacity-75 transition-opacity duration-300"></div>
                <div className="relative w-11 h-11 rounded-full p-[2px] bg-gradient-to-r from-blue-500 to-cyan-400">
                  <div className="w-full h-full rounded-full border-2 border-slate-900 overflow-hidden bg-slate-900">
                    <img className="w-full h-full object-cover" src={`https://ui-avatars.com/api/?name=${username}&background=0f172a&color=38bdf8&bold=true`} alt="Avatar" />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </header>

        {/* Dynamic Route Content */}
        <main className="flex-1 overflow-auto p-8 bg-slate-950 relative">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default AdminLayout;
