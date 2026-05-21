import { useEffect, useMemo, useRef, useState } from 'react';
import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import {
  Activity,
  Bell,
  Calendar,
  CheckCheck,
  ChevronRight,
  CircleDot,
  CreditCard,
  LayoutDashboard,
  LogOut,
  ShieldAlert,
  Users,
} from 'lucide-react';
import toast from 'react-hot-toast';

import { useAuthStore } from '../../../store/useAuthStore';
import { transactionApi } from '../../../services/api/transaction.api';
import { startAdminRealtimeStream } from '../../../services/realtime/adminRealtimeStream';
import { useAdminRealtimeStore } from '../../../store/useAdminRealtimeStore';
import './AdminLayout.css';

const parseJwt = (token: string | null) => {
  if (!token) {
    return null;
  }
  try {
    return JSON.parse(atob(token.split('.')[1]));
  } catch {
    return null;
  }
};

const formatCurrency = (amount: number) =>
  new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);

const formatDateTime = (value: string) =>
  new Date(value).toLocaleString('vi-VN', {
    hour: '2-digit',
    minute: '2-digit',
    day: '2-digit',
    month: '2-digit',
  });

const AdminLayout = () => {
  const { token, refreshToken, setAuth, logout } = useAuthStore();
  const navigate = useNavigate();
  const [username, setUsername] = useState('Admin');
  const [isNotificationOpen, setIsNotificationOpen] = useState(false);
  const notificationPanelRef = useRef<HTMLDivElement | null>(null);

  const notifications = useAdminRealtimeStore((state) => state.notifications);
  const unreadCount = useMemo(
    () => notifications.filter((item) => item.unread).length,
    [notifications],
  );
  const handleRealtimeEvent = useAdminRealtimeStore((state) => state.handleRealtimeEvent);
  const seedPendingTransactions = useAdminRealtimeStore((state) => state.seedPendingTransactions);
  const markAllAsRead = useAdminRealtimeStore((state) => state.markAllAsRead);
  const markAsRead = useAdminRealtimeStore((state) => state.markAsRead);
  const setConnected = useAdminRealtimeStore((state) => state.setConnected);
  const isConnected = useAdminRealtimeStore((state) => state.isConnected);

  useEffect(() => {
    const decoded = parseJwt(token);
    if (decoded && decoded.sub) {
      setUsername(decoded.sub);
    }
  }, [token]);

  useEffect(() => {
    if (!token) {
      return;
    }

    let unsubscribe = () => {};

    const bootstrap = async () => {
      try {
        const data = await transactionApi.getAllTransactions(0, 50);
        seedPendingTransactions(data.content);
      } catch (error) {
        console.error('Failed to seed pending transactions', error);
      }

      unsubscribe = startAdminRealtimeStream(
        {
          getAccessToken: () => useAuthStore.getState().token,
          getRefreshToken: () => useAuthStore.getState().refreshToken,
          onAuthUpdated: (accessToken, nextRefreshToken) => setAuth(accessToken, nextRefreshToken),
          onUnauthorized: () => {
            logout();
            navigate('/login');
          },
        },
        {
          onEvent: (event) => {
            setConnected(true);
            handleRealtimeEvent(event);

            if (event.eventType === 'PENDING_TRANSACTION_CREATED') {
              toast.success(
                `Có giao dịch lớn mới cần phê duyệt: ${String(event.data.referenceNumber ?? '')}`,
              );
            }
          },
          onError: () => {
            setConnected(false);
          },
        },
      );
    };

    bootstrap();

    return () => {
      unsubscribe();
      setConnected(false);
    };
  }, [token, refreshToken, handleRealtimeEvent, logout, navigate, seedPendingTransactions, setAuth, setConnected]);

  useEffect(() => {
    if (!isNotificationOpen) {
      return;
    }

    const handleClickOutside = (event: MouseEvent) => {
      if (
        notificationPanelRef.current &&
        !notificationPanelRef.current.contains(event.target as Node)
      ) {
        setIsNotificationOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [isNotificationOpen]);

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

      <div className="flex-1 flex flex-col min-w-0">
        <header className="h-20 bg-slate-900 border-b border-slate-800 flex items-center justify-between px-8 z-40 sticky top-0">
          <div className="hidden relative xl:flex lg:flex md:flex sm:hidden group cursor-default items-center">
            <div className="absolute inset-0 bg-gradient-to-r from-blue-500/20 to-cyan-400/20 rounded-2xl blur-xl opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>

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
            <div ref={notificationPanelRef} className="relative">
              <button
                onClick={() => setIsNotificationOpen((prev) => !prev)}
                className="relative text-slate-400 hover:text-cyan-400 transition-colors"
              >
                <Bell size={22} />
                {unreadCount > 0 && (
                  <span className="absolute -top-2 -right-2 min-w-[18px] h-[18px] px-1 bg-red-500 rounded-full border-2 border-slate-900 text-[10px] font-bold text-white flex items-center justify-center">
                    {unreadCount > 99 ? '99+' : unreadCount}
                  </span>
                )}
              </button>

              {isNotificationOpen && (
                <div className="fixed right-8 top-24 z-[120] w-[min(420px,calc(100vw-2rem))] overflow-hidden rounded-3xl border border-slate-700/80 bg-slate-900 shadow-[0_24px_80px_rgba(2,6,23,0.75)] ring-1 ring-cyan-400/10 backdrop-blur-xl">
                  <div className="border-b border-slate-800 bg-slate-800/40 px-5 py-4">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="text-sm font-bold text-white">Thông báo phê duyệt</p>
                        <div className="mt-1 flex items-center gap-2 text-xs text-slate-400">
                          <span>{notifications.length} giao dịch cần xử lý</span>
                          <span className="text-slate-600">•</span>
                          <span
                            className={`inline-flex items-center gap-1 ${
                              isConnected ? 'text-emerald-400' : 'text-amber-400'
                            }`}
                          >
                            <CircleDot size={10} fill="currentColor" />
                            {isConnected ? 'Đang kết nối realtime' : 'Đang kết nối lại'}
                          </span>
                        </div>
                      </div>
                      {notifications.length > 0 && (
                        <button
                          onClick={markAllAsRead}
                          className="inline-flex items-center gap-1 rounded-full border border-cyan-500/20 bg-cyan-500/10 px-3 py-1 text-xs font-semibold text-cyan-300 transition-colors hover:bg-cyan-500/15"
                          title="Đánh dấu đã đọc"
                        >
                          <CheckCheck size={18} />
                          Đã đọc hết
                        </button>
                      )}
                    </div>
                  </div>

                  <div className="max-h-[420px] overflow-y-auto">
                    {notifications.length === 0 ? (
                      <div className="px-6 py-12 text-center">
                        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl bg-slate-800/80 text-slate-400">
                          <ShieldAlert size={22} />
                        </div>
                        <p className="text-sm font-medium text-slate-200">
                          Chưa có giao dịch lớn nào đang chờ duyệt.
                        </p>
                        <p className="mt-1 text-xs text-slate-500">
                          Khi có lệnh vượt hạn mức, chuông này sẽ cập nhật ngay.
                        </p>
                      </div>
                    ) : (
                      notifications.map((item) => (
                        <button
                          key={item.id}
                          onClick={() => {
                            markAsRead(item.id);
                            setIsNotificationOpen(false);
                            navigate('/admin/transactions');
                          }}
                          className={`w-full border-b border-slate-800 px-5 py-4 text-left transition-colors hover:bg-slate-800/40 ${
                            item.unread ? 'bg-slate-800/20' : 'bg-transparent'
                          }`}
                        >
                          <div className="flex items-start gap-3">
                            <div className="mt-0.5 flex h-11 w-11 shrink-0 items-center justify-center rounded-2xl bg-amber-500/10 text-amber-400">
                              <ShieldAlert size={18} />
                            </div>

                            <div className="min-w-0 flex-1">
                              <div className="flex items-start justify-between gap-3">
                                <div className="min-w-0">
                                  <p className="text-sm font-semibold text-white">{item.title}</p>
                                  <p className="mt-1 text-xs text-slate-500">
                                    {item.referenceNumber} • {formatDateTime(item.createdAt)}
                                  </p>
                                </div>
                                {item.unread && (
                                  <span className="mt-1 h-2.5 w-2.5 shrink-0 rounded-full bg-red-500"></span>
                                )}
                              </div>

                              <p className="mt-2 line-clamp-2 text-sm leading-6 text-slate-300">
                                {item.message}
                              </p>

                              <div className="mt-3 grid grid-cols-2 gap-2">
                                <div className="rounded-2xl border border-slate-800 bg-slate-950/50 px-3 py-2">
                                  <p className="text-[11px] uppercase tracking-wide text-slate-500">
                                    Giá trị
                                  </p>
                                  <p className="mt-1 text-sm font-semibold text-amber-300">
                                    {formatCurrency(item.amount)}
                                  </p>
                                </div>
                                <div className="rounded-2xl border border-slate-800 bg-slate-950/50 px-3 py-2">
                                  <p className="text-[11px] uppercase tracking-wide text-slate-500">
                                    Hành động
                                  </p>
                                  <span className="mt-1 inline-flex items-center gap-1 text-sm font-medium text-cyan-400">
                                    Mở tab Giao dịch
                                    <ChevronRight size={14} />
                                  </span>
                                </div>
                              </div>
                            </div>
                          </div>
                        </button>
                      ))
                    )}
                  </div>

                  {notifications.length > 0 && (
                    <div className="border-t border-slate-800 bg-slate-900/90 px-5 py-3">
                      <button
                        onClick={() => {
                          setIsNotificationOpen(false);
                          navigate('/admin/transactions');
                        }}
                        className="flex w-full items-center justify-center gap-2 rounded-2xl border border-slate-700 bg-slate-800/60 px-4 py-3 text-sm font-semibold text-slate-200 transition-colors hover:bg-slate-800"
                      >
                        Xem toàn bộ giao dịch chờ duyệt
                        <ChevronRight size={16} />
                      </button>
                    </div>
                  )}
                </div>
              )}
            </div>

            <div className="flex items-center gap-4 pl-6 border-l border-slate-700/50">
              <div className="text-right hidden sm:block">
                <p className="text-[11px] font-medium text-slate-400 uppercase tracking-wider mb-0.5">
                  Welcome back
                </p>
                <p className="text-sm font-bold bg-gradient-to-r from-blue-400 to-cyan-300 bg-clip-text text-transparent uppercase tracking-wider">
                  {username}
                </p>
              </div>
              <div className="relative group cursor-pointer">
                <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-cyan-400 rounded-full blur opacity-40 group-hover:opacity-75 transition-opacity duration-300"></div>
                <div className="relative w-11 h-11 rounded-full p-[2px] bg-gradient-to-r from-blue-500 to-cyan-400">
                  <div className="w-full h-full rounded-full border-2 border-slate-900 overflow-hidden bg-slate-900">
                    <img
                      className="w-full h-full object-cover"
                      src={`https://ui-avatars.com/api/?name=${username}&background=0f172a&color=38bdf8&bold=true`}
                      alt="Avatar"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </header>

        <main className="flex-1 overflow-auto p-8 bg-slate-950 relative">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default AdminLayout;
