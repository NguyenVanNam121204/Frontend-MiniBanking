
import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import { LayoutDashboard, Users, CreditCard, Activity, LogOut, Bell, Search } from 'lucide-react';
import { useAuthStore } from '../../../store/useAuthStore';
import './AdminLayout.css';

const AdminLayout = () => {
  const logout = useAuthStore((state) => state.logout);
  const navigate = useNavigate();

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
          <div className="flex items-center hidden relative xl:flex lg:flex md:flex sm:hidden">
            <Search className="absolute left-3 text-slate-500" size={18} />
            <input 
              type="text" 
              placeholder="Search user, transaction..." 
              className="bg-slate-800/50 border border-slate-700 text-slate-200 text-sm rounded-lg pl-10 pr-4 py-2 outline-none focus:border-cyan-500 transition-colors w-72"
            />
          </div>

          <div className="flex items-center gap-6 ml-auto">
            <button className="relative text-slate-400 hover:text-cyan-400 transition-colors">
              <Bell size={22} />
              <span className="absolute -top-1 -right-1 w-2.5 h-2.5 bg-red-500 rounded-full border-2 border-slate-900"></span>
            </button>
            <div className="flex items-center gap-3 pl-6 border-l border-slate-700">
              <div className="text-right hidden sm:block">
                <p className="text-sm font-semibold text-white">System Admin</p>
                <p className="text-xs text-slate-400">Headquarters</p>
              </div>
              <div className="w-10 h-10 rounded-full bg-slate-800 border-2 border-slate-700 flex items-center justify-center overflow-hidden">
                <img src="https://ui-avatars.com/api/?name=Admin&background=0D8ABC&color=fff" alt="Admin" />
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
