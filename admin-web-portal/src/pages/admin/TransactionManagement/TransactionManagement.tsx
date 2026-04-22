import React, { useEffect, useState } from 'react';
import { transactionApi, type Transaction } from '../../../services/api/transaction.api';
import { 
  CreditCard, 
  ArrowUpRight, 
  ArrowDownLeft, 
  ArrowRightLeft, 
  Search, 
  Filter, 
  ChevronLeft, 
  ChevronRight,
  TrendingUp,
  Clock,
  CheckCircle2,
  Activity,
  ShieldAlert,
  Eye
} from 'lucide-react';

import ConfirmModal from '../../../components/common/Modal/ConfirmModal';
import SuccessModal from '../../../components/common/Modal/SuccessModal';
import { toast } from 'react-hot-toast';

const TransactionManagement: React.FC = () => {
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [totalElements, setTotalElements] = useState(0);

  // Filter States
  const [searchTerm, setSearchTerm] = useState('');
  const [typeFilter, setTypeFilter] = useState('ALL');

  // Modal States
  const [confirmModal, setConfirmModal] = useState<{
    isOpen: boolean;
    tx: Transaction | null;
    type: 'approve' | 'reject';
    isLoading: boolean;
  }>({
    isOpen: false,
    tx: null,
    type: 'approve',
    isLoading: false
  });

  const [detailModal, setDetailModal] = useState<{
    isOpen: boolean;
    tx: Transaction | null;
  }>({
    isOpen: false,
    tx: null
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

  const fetchTransactions = async () => {
    try {
      setLoading(true);
      const data = await transactionApi.getAllTransactions(page, 50); // Lay nhieu hon de loc o frontend
      setTransactions(data.content);
      setTotalPages(data.totalPages);
      setTotalElements(data.totalElements);
    } catch (error) {
      console.error('Error fetching transactions', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTransactions();
  }, [page]);

  // Logic lọc dữ liệu
  const filteredTransactions = transactions.filter(tx => {
    const matchesSearch = tx.referenceNumber.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesType = typeFilter === 'ALL' || tx.type === typeFilter;
    return matchesSearch && matchesType;
  });

  // Tính toán các chỉ số
  const pendingCount = transactions.filter(tx => tx.status === 'PENDING').length;
  const successCount = transactions.filter(tx => tx.status === 'SUCCESS' || tx.status === 'COMPLETED').length;
  const successRate = transactions.length > 0 ? Math.round((successCount / transactions.length) * 100) : 100;

  const onConfirmAction = async () => {
    const { tx, type } = confirmModal;
    if (!tx) return;

    try {
      setConfirmModal(prev => ({ ...prev, isLoading: true }));
      if (type === 'approve') {
        await transactionApi.approveTransaction(tx.id);
      } else {
        await transactionApi.rejectTransaction(tx.id);
      }
      
      setConfirmModal(prev => ({ ...prev, isOpen: false, isLoading: false }));
      
      setSuccessModal({
        isOpen: true,
        title: type === 'approve' ? 'Đã duyệt giao dịch' : 'Đã từ chối giao dịch',
        message: `Giao dịch ${tx.referenceNumber} đã được ${type === 'approve' ? 'hoàn tất' : 'hủy bỏ'} thành công.`
      });
      
      fetchTransactions();
    } catch (error) {
      toast.error('Có lỗi xảy ra khi thực hiện thao tác');
      setConfirmModal(prev => ({ ...prev, isLoading: false }));
    }
  };

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
  };

  const getTransactionIcon = (type: string) => {
    switch (type) {
      case 'DEPOSIT': return <ArrowDownLeft className="text-green-400" />;
      case 'WITHDRAW': return <ArrowUpRight className="text-red-400" />;
      case 'TRANSFER': return <ArrowRightLeft className="text-blue-400" />;
      default: return <CreditCard className="text-slate-400" />;
    }
  };

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <TrendingUp className="text-blue-400" />
            Transaction Management
          </h1>
          <p className="text-slate-400 text-sm mt-1">Giám sát dòng tiền và các lệnh nạp/rút trên toàn hệ thống</p>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl flex items-center gap-4">
          <div className="p-3 bg-blue-500/10 text-blue-500 rounded-xl">
            <Clock size={24} />
          </div>
          <div>
            <p className="text-slate-400 text-xs font-semibold uppercase">Đang chờ xử lý</p>
            <p className="text-2xl font-bold text-white">{pendingCount}</p>
          </div>
        </div>
        <div className="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl flex items-center gap-4 border-l-4 border-l-green-500">
          <div className="p-3 bg-green-500/10 text-green-500 rounded-xl">
            <CheckCircle2 size={24} />
          </div>
          <div>
            <p className="text-slate-400 text-xs font-semibold uppercase">Hoàn tất</p>
            <p className="text-2xl font-bold text-white">{successCount}</p>
          </div>
        </div>
        <div className="bg-slate-900/50 border border-slate-800 p-6 rounded-2xl flex items-center gap-4">
          <div className="p-3 bg-purple-500/10 text-purple-500 rounded-xl">
            <Activity size={24} />
          </div>
          <div>
            <p className="text-slate-400 text-xs font-semibold uppercase">Tỷ lệ thành công</p>
            <p className="text-2xl font-bold text-white">{successRate}%</p>
          </div>
        </div>
      </div>

      {/* Filters */}
      <div className="bg-slate-900/50 border border-slate-800 p-4 rounded-2xl flex flex-wrap gap-4 items-center backdrop-blur-sm">
        <div className="relative flex-1 min-w-[300px]">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500" />
          <input 
            type="text" 
            placeholder="Tìm theo Mã tham chiếu (Ref Number)..." 
            className="w-full bg-slate-950 border border-slate-800 rounded-xl pl-10 pr-4 py-2.5 text-sm text-slate-200 focus:outline-none focus:border-blue-500/50 transition-all"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <select 
          className="bg-slate-950 border border-slate-800 rounded-xl px-4 py-2.5 text-sm text-slate-200 focus:outline-none focus:border-blue-500/50"
          value={typeFilter}
          onChange={(e) => setTypeFilter(e.target.value)}
        >
          <option value="ALL">Tất cả loại</option>
          <option value="DEPOSIT">Nạp tiền (Deposit)</option>
          <option value="WITHDRAW">Rút tiền (Withdraw)</option>
          <option value="TRANSFER">Chuyển khoản (Transfer)</option>
        </select>
        <button 
          onClick={() => { setSearchTerm(''); setTypeFilter('ALL'); }}
          className="bg-slate-800 hover:bg-slate-700 text-white p-2.5 rounded-xl transition-all border border-slate-700"
          title="Reset bộ lọc"
        >
          <Filter size={20} />
        </button>
      </div>

      {/* Transactions Table */}
      <div className="bg-slate-900/50 border border-slate-800 rounded-2xl overflow-hidden backdrop-blur-sm">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-800/50 text-slate-400 text-xs uppercase tracking-wider">
                <th className="px-6 py-4 font-semibold">Mã GD / Thời gian</th>
                <th className="px-6 py-4 font-semibold">Loại</th>
                <th className="px-6 py-4 font-semibold">Số tiền</th>
                <th className="px-6 py-4 font-semibold">Nội dung</th>
                <th className="px-6 py-4 font-semibold">Trạng thái</th>
                <th className="px-6 py-4 font-semibold text-right">Thao tác</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-800">
              {loading ? (
                Array.from({ length: 8 }).map((_, i) => (
                  <tr key={i} className="animate-pulse">
                    <td colSpan={6} className="px-6 py-6 h-16 bg-slate-900/20"></td>
                  </tr>
                ))
              ) : filteredTransactions.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-6 py-20 text-center text-slate-500 italic">Không có giao dịch nào khớp với bộ lọc</td>
                </tr>
              ) : (
                filteredTransactions.map((tx) => (
                  <tr key={tx.id} className="hover:bg-slate-800/30 transition-colors group">
                    <td className="px-6 py-4">
                      <div className="flex flex-col">
                        <span className="text-xs font-mono font-bold text-blue-400">{tx.referenceNumber}</span>
                        <span className="text-[10px] text-slate-500 mt-1">{new Date(tx.createdAt).toLocaleString()}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-2 text-xs font-bold text-slate-200">
                        {getTransactionIcon(tx.type)}
                        {tx.type}
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className={`text-sm font-bold ${
                        tx.type === 'DEPOSIT' ? 'text-green-400' : tx.type === 'WITHDRAW' ? 'text-red-400' : 'text-blue-400'
                      }`}>
                        {tx.type === 'WITHDRAW' || (tx.type === 'TRANSFER' && tx.sourceAccountNumber) ? '-' : '+'}
                        {formatCurrency(tx.amount)}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex flex-col">
                        <p className="text-xs text-slate-400 line-clamp-1">{tx.description}</p>
                        {tx.type === 'TRANSFER' && (
                          <p className="text-[10px] text-slate-500 mt-0.5">
                            {tx.sourceAccountNumber} → {tx.destinationAccountNumber}
                          </p>
                        )}
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className={`px-2.5 py-1 rounded-full text-[10px] font-bold border ${
                        tx.status === 'SUCCESS' || tx.status === 'COMPLETED'
                          ? 'bg-green-500/10 text-green-500 border-green-500/20' 
                          : tx.status === 'PENDING'
                          ? 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20 animate-pulse'
                          : 'bg-red-500/10 text-red-500 border-red-500/20'
                      }`}>
                        {tx.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex justify-end gap-2">
                        <button 
                          onClick={() => setDetailModal({ isOpen: true, tx })}
                          className="p-1.5 bg-slate-800 text-slate-400 border border-slate-700 rounded-lg hover:text-white hover:border-slate-600 transition-all"
                          title="Xem chi tiết"
                        >
                          <Eye size={16} />
                        </button>
                        
                        {tx.status === 'PENDING' && (
                          <>
                            <button 
                              onClick={() => setConfirmModal({ isOpen: true, tx, type: 'approve', isLoading: false })}
                              className="p-1.5 bg-green-600/20 text-green-500 border border-green-600/30 rounded-lg hover:bg-green-600 hover:text-white transition-all"
                              title="Duyệt giao dịch"
                            >
                              <CheckCircle2 size={16} />
                            </button>
                            <button 
                              onClick={() => setConfirmModal({ isOpen: true, tx, type: 'reject', isLoading: false })}
                              className="p-1.5 bg-red-600/20 text-red-500 border border-red-600/30 rounded-lg hover:bg-red-600 hover:text-white transition-all"
                              title="Từ chối giao dịch"
                            >
                              <ShieldAlert size={16} />
                            </button>
                          </>
                        )}
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
            Hiển thị <span className="text-slate-300">{transactions.length}</span> / <span className="text-slate-300">{totalElements}</span> giao dịch
          </p>
          <div className="flex items-center gap-2">
            <button 
              onClick={() => setPage(p => Math.max(0, p - 1))}
              disabled={page === 0}
              className="p-1.5 rounded-lg border border-slate-800 text-slate-400 hover:text-white disabled:opacity-50 transition-colors"
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <span className="text-xs text-slate-300 px-3 font-medium">Trang {page + 1} / {totalPages || 1}</span>
            <button 
              onClick={() => setPage(p => Math.min(totalPages - 1, p + 1))}
              disabled={page >= totalPages - 1}
              className="p-1.5 rounded-lg border border-slate-800 text-slate-400 hover:text-white disabled:opacity-50 transition-colors"
            >
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      </div>

      {/* Modals */}
      <ConfirmModal 
        isOpen={confirmModal.isOpen}
        isLoading={confirmModal.isLoading}
        onClose={() => setConfirmModal(prev => ({ ...prev, isOpen: false }))}
        onConfirm={onConfirmAction}
        type={confirmModal.type === 'approve' ? 'success' : 'danger'}
        title={confirmModal.type === 'approve' ? 'Duyệt giao dịch' : 'Từ chối giao dịch'}
        message={confirmModal.type === 'approve' 
          ? `Bạn có chắc chắn muốn duyệt giao dịch ${confirmModal.tx?.referenceNumber} giá trị ${formatCurrency(confirmModal.tx?.amount || 0)}? Tiền sẽ được chuyển ngay lập tức.`
          : `Bạn có muốn từ chối giao dịch ${confirmModal.tx?.referenceNumber}? Giao dịch này sẽ bị hủy bỏ.`
        }
        confirmText={confirmModal.type === 'approve' ? 'Xác nhận duyệt' : 'Xác nhận từ chối'}
      />

      <SuccessModal 
        isOpen={successModal.isOpen}
        onClose={() => setSuccessModal(prev => ({ ...prev, isOpen: false }))}
        title={successModal.title}
        message={successModal.message}
      />

      {/* Transaction Detail Modal */}
      {detailModal.isOpen && detailModal.tx && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm animate-in fade-in duration-300">
          <div className="bg-slate-900 border border-slate-800 rounded-3xl w-full max-w-lg overflow-hidden shadow-2xl animate-in zoom-in-95 duration-300">
            {/* Modal Header */}
            <div className="px-6 py-4 border-b border-slate-800 flex justify-between items-center bg-slate-800/30">
              <h3 className="text-lg font-bold text-white flex items-center gap-2">
                <Eye className="text-blue-400" />
                Chi tiết giao dịch
              </h3>
              <button 
                onClick={() => setDetailModal({ isOpen: false, tx: null })}
                className="text-slate-400 hover:text-white transition-colors"
              >
                ✕
              </button>
            </div>

            {/* Modal Content */}
            <div className="p-6 space-y-6">
              {/* Amount & Status */}
              <div className="text-center space-y-2">
                <p className="text-slate-400 text-sm font-medium">Số tiền giao dịch</p>
                <h2 className={`text-4xl font-black ${
                  detailModal.tx.type === 'DEPOSIT' ? 'text-green-400' : detailModal.tx.type === 'WITHDRAW' ? 'text-red-400' : 'text-blue-400'
                }`}>
                  {formatCurrency(detailModal.tx.amount)}
                </h2>
                <div className="flex justify-center">
                  <span className={`px-3 py-1 rounded-full text-[10px] font-bold border ${
                    detailModal.tx.status === 'SUCCESS' || detailModal.tx.status === 'COMPLETED'
                      ? 'bg-green-500/10 text-green-500 border-green-500/20' 
                      : detailModal.tx.status === 'PENDING'
                      ? 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20 animate-pulse'
                      : 'bg-red-500/10 text-red-500 border-red-500/20'
                  }`}>
                    {detailModal.tx.status}
                  </span>
                </div>
              </div>

              {/* Info Grid */}
              <div className="grid grid-cols-2 gap-4 bg-slate-950/50 p-4 rounded-2xl border border-slate-800/50">
                <div className="space-y-1">
                  <p className="text-[10px] text-slate-500 uppercase font-bold tracking-wider">Mã tham chiếu</p>
                  <p className="text-sm font-mono text-slate-200">{detailModal.tx.referenceNumber}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-[10px] text-slate-500 uppercase font-bold tracking-wider">Loại giao dịch</p>
                  <p className="text-sm font-bold text-slate-200">{detailModal.tx.type}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-[10px] text-slate-500 uppercase font-bold tracking-wider">Tài khoản nguồn</p>
                  <p className="text-sm font-medium text-slate-300">{detailModal.tx.sourceAccountNumber || 'N/A (Hệ thống)'}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-[10px] text-slate-500 uppercase font-bold tracking-wider">Tài khoản nhận</p>
                  <p className="text-sm font-medium text-slate-300">{detailModal.tx.destinationAccountNumber || 'N/A (Hệ thống)'}</p>
                </div>
                <div className="col-span-2 space-y-1 pt-2 border-t border-slate-800/50">
                  <p className="text-[10px] text-slate-500 uppercase font-bold tracking-wider">Nội dung</p>
                  <p className="text-sm text-slate-300 leading-relaxed italic">"{detailModal.tx.description}"</p>
                </div>
                <div className="col-span-2 space-y-1">
                  <p className="text-[10px] text-slate-500 uppercase font-bold tracking-wider">Thời gian khởi tạo</p>
                  <p className="text-sm text-slate-400">{new Date(detailModal.tx.createdAt).toLocaleString('vi-VN')}</p>
                </div>
              </div>
            </div>

            {/* Modal Footer - Actions */}
            <div className="px-6 py-6 border-t border-slate-800 bg-slate-800/20 flex gap-3">
              <button 
                onClick={() => setDetailModal({ isOpen: false, tx: null })}
                className="flex-1 py-3 px-4 bg-slate-800 hover:bg-slate-700 text-white rounded-xl transition-all font-bold text-sm"
              >
                Đóng
              </button>
              
              {detailModal.tx.status === 'PENDING' && (
                <>
                  <button 
                    onClick={() => {
                      setDetailModal({ isOpen: false, tx: null });
                      setConfirmModal({ isOpen: true, tx: detailModal.tx, type: 'reject', isLoading: false });
                    }}
                    className="flex-1 py-3 px-4 bg-red-600/20 hover:bg-red-600 text-red-500 hover:text-white border border-red-600/30 rounded-xl transition-all font-bold text-sm flex items-center justify-center gap-2"
                  >
                    <ShieldAlert size={18} />
                    Từ chối
                  </button>
                  <button 
                    onClick={() => {
                      setDetailModal({ isOpen: false, tx: null });
                      setConfirmModal({ isOpen: true, tx: detailModal.tx, type: 'approve', isLoading: false });
                    }}
                    className="flex-1 py-3 px-4 bg-green-600 hover:bg-green-700 text-white rounded-xl transition-all font-bold text-sm shadow-lg shadow-green-900/20 flex items-center justify-center gap-2"
                  >
                    <CheckCircle2 size={18} />
                    Duyệt ngay
                  </button>
                </>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default TransactionManagement;
