import React, { useEffect, useState } from 'react';
import { auditApi, type AuditLog } from '../../../services/api/audit.api';
import { 
  Activity, 
  Search, 
  Filter, 
  ChevronLeft, 
  ChevronRight, 
  Calendar,
  User as UserIcon,
  Download
} from 'lucide-react';

const AuditLogs: React.FC = () => {
  const [logs, setLogs] = useState<AuditLog[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(0);
  const [totalElements, setTotalElements] = useState(0);

  // Filters
  const [searchTerm, setSearchTerm] = useState('');
  const [actionType, setActionType] = useState('ALL');
  const [dateFilter, setDateFilter] = useState('');

  const fetchLogs = async (targetPage = page) => {
    try {
      setLoading(true);
      const data = await auditApi.getLogs(targetPage, 15, searchTerm, actionType, dateFilter);
      setLogs(data.content);
      setTotalPages(data.totalPages);
      setTotalElements(data.totalElements);
    } catch (error) {
      console.error('Error fetching logs', error);
    } finally {
      setLoading(false);
    }
  };

  const handleFilter = () => {
    setPage(0); 
    fetchLogs(0); // Truyen truc tiep 0 de dam bao khong dung state cu
  };

  useEffect(() => {
    fetchLogs(page);
  }, [page]);

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      {/* Header & Export */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <Activity className="text-purple-400" />
            Audit Trail Explorer
          </h1>
          <p className="text-slate-400 text-sm mt-1">Giám sát và truy vết mọi hoạt động trên hệ thống</p>
        </div>
        
        <button className="flex items-center gap-2 bg-slate-900 border border-slate-800 px-4 py-2 rounded-xl text-slate-300 hover:text-white hover:border-slate-700 transition-all">
          <Download size={18} />
          <span>Xuất báo cáo</span>
        </button>
      </div>

      {/* Filter Bar */}
      <div className="bg-slate-900/50 border border-slate-800 p-4 rounded-2xl flex flex-wrap gap-4 items-end backdrop-blur-sm">
        <div className="flex-1 min-w-[200px]">
          <label className="block text-[10px] font-bold text-slate-500 uppercase mb-2 ml-1">Tìm theo Username</label>
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500" />
            <input 
              type="text" 
              placeholder="Nhập tên người dùng..." 
              className="w-full bg-slate-950 border border-slate-800 rounded-xl pl-10 pr-4 py-2 text-sm text-slate-200 focus:outline-none focus:border-purple-500/50 transition-all"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleFilter()}
            />
          </div>
        </div>

        <div className="w-full md:w-48">
          <label className="block text-[10px] font-bold text-slate-500 uppercase mb-2 ml-1">Loại hành động</label>
          <select 
            className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-2 text-sm text-slate-200 focus:outline-none focus:border-purple-500/50"
            value={actionType}
            onChange={(e) => setActionType(e.target.value)}
          >
            <option value="ALL">Tất cả hành động</option>
            <option value="AUTH">Xác thực & Bảo mật</option>
            <option value="TRANSACTION">Giao dịch tiền tệ</option>
            <option value="ADMIN">Hoạt động quản trị</option>
          </select>
        </div>

        <div className="w-full md:w-48">
          <label className="block text-[10px] font-bold text-slate-500 uppercase mb-2 ml-1">Ngày thực hiện</label>
          <div className="relative">
            <Calendar className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500" />
            <input 
              type="date" 
              className="w-full bg-slate-950 border border-slate-800 rounded-xl pl-10 pr-4 py-2 text-sm text-slate-200 focus:outline-none focus:border-purple-500/50"
              value={dateFilter}
              onChange={(e) => setDateFilter(e.target.value)}
            />
          </div>
        </div>

        <button 
          onClick={handleFilter}
          disabled={loading}
          className={`bg-purple-600 hover:bg-purple-700 text-white p-2.5 rounded-xl transition-all shadow-lg shadow-purple-900/20 active:scale-95 ${loading ? 'opacity-50 cursor-not-allowed' : ''}`}
          title="Áp dụng bộ lọc"
        >
          {loading ? (
            <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
          ) : (
            <Filter size={20} />
          )}
        </button>
      </div>

      {/* Logs Table */}
      <div className="bg-slate-900/50 border border-slate-800 rounded-2xl overflow-hidden backdrop-blur-sm shadow-xl">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-slate-800/50 text-slate-400 text-xs uppercase tracking-wider">
                <th className="px-6 py-4 font-semibold">Thời gian</th>
                <th className="px-6 py-4 font-semibold">Người thực hiện</th>
                <th className="px-6 py-4 font-semibold">Hành động</th>
                <th className="px-6 py-4 font-semibold">Nội dung chi tiết</th>
                <th className="px-6 py-4 font-semibold">Trạng thái</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-800">
              {loading ? (
                Array.from({ length: 8 }).map((_, i) => (
                  <tr key={i} className="animate-pulse">
                    <td colSpan={5} className="px-6 py-5 h-16 bg-slate-900/20"></td>
                  </tr>
                ))
              ) : logs.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-6 py-20 text-center text-slate-500 italic">
                    Không có nhật ký hoạt động nào được tìm thấy
                  </td>
                </tr>
              ) : (
                logs.map((log) => (
                  <tr key={log.id} className="hover:bg-slate-800/30 transition-colors group">
                    <td className="px-6 py-4">
                      <div className="flex flex-col">
                        <span className="text-sm font-medium text-slate-200">{new Date(log.createdAt).toLocaleDateString()}</span>
                        <span className="text-[10px] text-slate-500">{new Date(log.createdAt).toLocaleTimeString()}</span>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-2 text-purple-400 font-semibold text-sm">
                        <UserIcon size={14} />
                        @{log.username}
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className="px-2 py-0.5 bg-slate-800 border border-slate-700 text-slate-300 rounded-md text-[10px] font-bold">
                        {log.action}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <p className="text-xs text-slate-400 max-w-xs truncate group-hover:whitespace-normal group-hover:text-slate-200 transition-all">
                        {log.details}
                      </p>
                    </td>
                    <td className="px-6 py-4">
                      <div className={`flex items-center gap-1.5 text-[10px] font-bold uppercase ${
                        log.status === 'SUCCESS' ? 'text-green-500' : 'text-red-500'
                      }`}>
                        <span className={`w-1.5 h-1.5 rounded-full ${
                          log.status === 'SUCCESS' ? 'bg-green-500 shadow-[0_0_8px_rgba(34,197,94,0.5)]' : 'bg-red-500 shadow-[0_0_8px_rgba(239,68,68,0.5)]'
                        }`}></span>
                        {log.status}
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
            Hiển thị <span className="text-slate-300">{logs.length}</span> / <span className="text-slate-300">{totalElements}</span> bản ghi
          </p>
          <div className="flex items-center gap-2">
            <button 
              onClick={() => setPage(p => Math.max(0, p - 1))}
              disabled={page === 0}
              className="p-1.5 rounded-lg border border-slate-800 text-slate-400 hover:text-white disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              <ChevronLeft className="w-4 h-4" />
            </button>
            <span className="text-xs text-slate-300 px-3 font-medium">Trang {page + 1} / {totalPages || 1}</span>
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
    </div>
  );
};

export default AuditLogs;
