import React, { useEffect, useState } from 'react';
import { userApi, type User } from '../../../services/api/user.api';
import { toast } from 'react-hot-toast';
import { 
  Users, 
  Search, 
  UserX, 
  UserCheck, 
  Key, 
  MoreVertical,
  Filter,
  ChevronLeft,
  ChevronRight,
  Shield,
  UserPlus
} from 'lucide-react';
import ConfirmModal from '../../../components/common/Modal/ConfirmModal';
import SuccessModal from '../../../components/common/Modal/SuccessModal';
import ErrorModal from '../../../components/common/Modal/ErrorModal';
import ResetPasswordModal from '../../../components/common/Modal/ResetPasswordModal';
import CreateUserModal from '../../../components/common/Modal/CreateUserModal';

const UserManagement: React.FC = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [searchTerm, setSearchTerm] = useState('');
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);

  // Modal States
  const [confirmModal, setConfirmModal] = useState<{
    isOpen: boolean;
    user: User | null;
    type: 'lock' | 'unlock';
    isLoading: boolean;
  }>({
    isOpen: false,
    user: null,
    type: 'lock',
    isLoading: false
  });

  const [resetModal, setResetModal] = useState<{
    isOpen: boolean;
    user: User | null;
    isLoading: boolean;
  }>({
    isOpen: false,
    user: null,
    isLoading: false
  });

  const [successModal, setSuccessModal] = useState<{
    isOpen: boolean;
    title: string;
    message: string;
  }>({
    isOpen: false,
    title: '',
    message: ''
  });

  const [errorModal, setErrorModal] = useState<{
    isOpen: boolean;
    title: string;
    message: string;
  }>({
    isOpen: false,
    title: '',
    message: ''
  });

  const fetchUsers = async () => {
    try {
      setLoading(true);
      const data = await userApi.getUsers(page, 10, searchTerm);
      setUsers(data.content);
      setTotalPages(data.page.totalPages);
    } catch (error) {
      toast.error('Không thể tải danh sách người dùng');
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = () => {
    setPage(0);
    fetchUsers();
  };

  useEffect(() => {
    fetchUsers();
  }, [page]);

  const onConfirmAction = async () => {
    const { user, type } = confirmModal;
    if (!user) return;

    try {
      setConfirmModal(prev => ({ ...prev, isLoading: true }));
      if (type === 'lock') {
        await userApi.lockUser(user.id);
      } else {
        await userApi.unlockUser(user.id);
      }
      
      setConfirmModal(prev => ({ ...prev, isOpen: false, isLoading: false }));
      
      setSuccessModal({
        isOpen: true,
        title: type === 'lock' ? 'Đã khóa tài khoản' : 'Đã mở khóa',
        message: `Tài khoản ${user.username} đã được ${type === 'lock' ? 'khóa' : 'kích hoạt lại'} thành công.`
      });
      
      fetchUsers();
    } catch (error: any) {
      setConfirmModal(prev => ({ ...prev, isOpen: false, isLoading: false }));
      const errorMsg = error.response?.data?.message || 'Có lỗi xảy ra khi thực hiện thao tác';
      setErrorModal({
        isOpen: true,
        title: 'Thao tác thất bại',
        message: errorMsg
      });
    }
  };

  const handleLockUnlock = async (user: User) => {
    setConfirmModal({
      isOpen: true,
      user,
      type: user.status === 'ACTIVE' ? 'lock' : 'unlock',
      isLoading: false
    });
  };

  const onConfirmResetPassword = async (newPassword: string) => {
    const { user } = resetModal;
    if (!user) return;

    try {
      setResetModal(prev => ({ ...prev, isLoading: true }));
      await userApi.resetPassword(user.id, newPassword);
      
      setResetModal(prev => ({ ...prev, isOpen: false, isLoading: false }));
      
      setSuccessModal({
        isOpen: true,
        title: 'Cập nhật mật khẩu thành công',
        message: `Mật khẩu mới của người dùng ${user.username} đã được thiết lập lại.`
      });
    } catch (error) {
      toast.error('Lỗi khi đặt lại mật khẩu');
      setResetModal(prev => ({ ...prev, isLoading: false }));
    }
  };

  const handleResetPassword = async (user: User) => {
    setResetModal({
      isOpen: true,
      user,
      isLoading: false
    });
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <Users className="text-cyan-400" />
            Quản Lý Người Dùng
          </h1>
          <p className="text-slate-400 text-sm mt-1">Quản lý danh sách, trạng thái và quyền hạn của khách hàng</p>
        </div>
        
        <div className="flex items-center gap-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500" />
            <input 
              type="text" 
              placeholder="Tìm kiếm username, email..." 
              className="bg-slate-900 border border-slate-800 rounded-lg pl-10 pr-4 py-2 text-sm text-slate-200 focus:outline-none focus:border-cyan-500/50 w-full md:w-64 transition-all"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
            />
          </div>
          <button 
            onClick={handleSearch}
            className="bg-slate-900 border border-slate-800 p-2 rounded-lg text-slate-400 hover:text-white transition-colors"
          >
            <Filter className="w-5 h-5" />
          </button>
          <button 
            onClick={() => setIsCreateModalOpen(true)}
            className="bg-cyan-600 hover:bg-cyan-500 text-white px-4 py-2 rounded-lg flex items-center gap-2 transition-colors font-semibold"
          >
            <UserPlus className="w-5 h-5" />
            <span className="hidden md:inline">Thêm người dùng</span>
          </button>
        </div>
      </div>

      {/* Users Table */}
      <div className="bg-slate-900/50 border border-slate-800 rounded-xl overflow-hidden backdrop-blur-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-800/50 text-slate-400 text-xs uppercase tracking-wider">
                <th className="px-6 py-4 font-semibold">Người dùng</th>
                <th className="px-6 py-4 font-semibold">Trạng thái</th>
                <th className="px-6 py-4 font-semibold">Quyền hạn</th>
                <th className="px-6 py-4 font-semibold">Ngày đăng ký</th>
                <th className="px-6 py-4 font-semibold text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-800">
              {loading ? (
                Array.from({ length: 5 }).map((_, i) => (
                  <tr key={i} className="animate-pulse">
                    <td colSpan={5} className="px-6 py-4 h-16 bg-slate-900/20"></td>
                  </tr>
                ))
              ) : users.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-6 py-10 text-center text-slate-500">Không tìm thấy người dùng nào</td>
                </tr>
              ) : (
                users.map((user) => (
                  <tr key={user.id} className="hover:bg-slate-800/30 transition-colors group">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-gradient-to-br from-slate-700 to-slate-800 flex items-center justify-center text-cyan-400 font-bold border border-slate-700">
                          {user.username.charAt(0).toUpperCase()}
                        </div>
                        <div>
                          <p className="text-sm font-semibold text-white">{user.username}</p>
                          <p className="text-xs text-slate-500">{user.email}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className={`px-2 py-1 rounded-full text-[10px] font-bold uppercase ${
                        user.status === 'ACTIVE' 
                          ? 'bg-green-500/10 text-green-500 border border-green-500/20' 
                          : 'bg-red-500/10 text-red-500 border border-red-500/20'
                      }`}>
                        {user.status}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex flex-wrap gap-1">
                        {user.roles.map((role) => (
                          <span key={role} className="flex items-center gap-1 px-2 py-0.5 bg-slate-800 text-slate-400 rounded text-[10px] border border-slate-700">
                            <Shield className="w-3 h-3 text-cyan-500" />
                            {role.replace('ROLE_', '')}
                          </span>
                        ))}
                      </div>
                    </td>
                    <td className="px-6 py-4 text-xs text-slate-400">
                      {new Date(user.createdAt).toLocaleDateString()}
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex justify-end gap-2">
                        <button 
                          onClick={() => handleLockUnlock(user)}
                          className={`p-2 rounded-lg transition-all ${
                            user.status === 'ACTIVE' 
                              ? 'text-red-400 hover:bg-red-400/10' 
                              : 'text-green-400 hover:bg-green-400/10'
                          }`}
                          title={user.status === 'ACTIVE' ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}
                        >
                          {user.status === 'ACTIVE' ? <UserX className="w-4 h-4" /> : <UserCheck className="w-4 h-4" />}
                        </button>
                        <button 
                          onClick={() => handleResetPassword(user)}
                          className="p-2 text-slate-400 hover:text-white hover:bg-slate-800 rounded-lg transition-all"
                          title="Reset mật khẩu"
                        >
                          <Key className="w-4 h-4" />
                        </button>
                        <button className="p-2 text-slate-400 hover:text-white hover:bg-slate-800 rounded-lg transition-all">
                          <MoreVertical className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="px-6 py-4 bg-slate-800/30 border-t border-slate-800 flex items-center justify-between">
          <p className="text-xs text-slate-500">
            Hiển thị <span className="text-slate-300">{users.length}</span> người dùng
          </p>
          <div className="flex items-center gap-2">
            <button 
              onClick={() => setPage(p => Math.max(0, p - 1))}
              disabled={page === 0}
              className="p-1.5 rounded-lg border border-slate-800 text-slate-400 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <span className="text-xs text-slate-300 px-3">Trang {page + 1} / {totalPages || 1}</span>
            <button 
              onClick={() => setPage(p => Math.min(totalPages - 1, p + 1))}
              disabled={page >= totalPages - 1}
              className="p-1.5 rounded-lg border border-slate-800 text-slate-400 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>

      {/* Modals */}
      <CreateUserModal 
        isOpen={isCreateModalOpen} 
        onClose={() => setIsCreateModalOpen(false)} 
        onSuccess={(username) => {
          setIsCreateModalOpen(false);
          setSuccessModal({
            isOpen: true,
            title: 'Tạo tài khoản thành công',
            message: `Tài khoản người dùng ${username} đã được tạo và cấp quyền thành công.`
          });
          handleSearch();
        }}
      />

      <ErrorModal 
        isOpen={errorModal.isOpen}
        onClose={() => setErrorModal(prev => ({ ...prev, isOpen: false }))}
        title={errorModal.title}
        message={errorModal.message}
      />

      <ConfirmModal  
        isOpen={confirmModal.isOpen}
        isLoading={confirmModal.isLoading}
        onClose={() => setConfirmModal(prev => ({ ...prev, isOpen: false }))}
        onConfirm={onConfirmAction}
        type={confirmModal.type === 'lock' ? 'danger' : 'success'}
        title={confirmModal.type === 'lock' ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}
        message={confirmModal.type === 'lock' 
          ? `Bạn có chắc chắn muốn khóa tài khoản của ${confirmModal.user?.username}? Người dùng này sẽ không thể đăng nhập vào hệ thống.`
          : `Bạn có muốn mở khóa cho tài khoản ${confirmModal.user?.username}?`
        }
        confirmText={confirmModal.type === 'lock' ? 'Xác nhận khóa' : 'Xác nhận mở'}
      />

      <ResetPasswordModal 
        isOpen={resetModal.isOpen}
        isLoading={resetModal.isLoading}
        username={resetModal.user?.username || ''}
        onClose={() => setResetModal(prev => ({ ...prev, isOpen: false }))}
        onConfirm={onConfirmResetPassword}
      />

      <SuccessModal 
        isOpen={successModal.isOpen}
        onClose={() => setSuccessModal(prev => ({ ...prev, isOpen: false }))}
        title={successModal.title}
        message={successModal.message}
      />
    </div>
  );
};

export default UserManagement;
