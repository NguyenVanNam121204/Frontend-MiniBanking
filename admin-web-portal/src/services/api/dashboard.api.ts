import { apiClient } from '../apiClient';

export interface DashboardStats {
  totalUsers: number;
  todayTransactions: number;
  lockedUsers: number;
  chartData: Array<{ name: string; value: number }>;
  recentActivities: Array<{
    id: number;
    action: string;
    username: string;
    details: string;
    status: string;
    createdAt: string;
    timeAgo: string;
  }>;
}

export interface AuditLog {
  id: number;
  username: string;
  action: string;
  details: string;
  status: string;
  createdAt: string;
}

export const dashboardApi = {
  getStats: async () => {
    const response = await apiClient.get<{ data: DashboardStats }>('/admin/dashboard/stats');
    return response.data.data;
  },
  getAuditLogs: async (page = 0, size = 10) => {
    const response = await apiClient.get(`/admin/audit-logs?page=${page}&size=${size}`);
    return response.data;
  }
};
