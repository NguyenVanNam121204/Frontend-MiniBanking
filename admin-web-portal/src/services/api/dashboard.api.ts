import { apiClient } from '../apiClient';

export interface DashboardStats {
  totalUsers: number;
  todayTransactions: number;
  lockedUsers: number;
  uptime: number;
  chartData: Array<{ name: string; value: number }>;
  recentActivities: Array<{
    type: string;
    description: string;
    timeAgo: string;
  }>;
}

export const dashboardApi = {
  getStats: async () => {
    const response = await apiClient.get<{ data: DashboardStats }>('/admin/dashboard/stats');
    return response.data.data;
  },
};
