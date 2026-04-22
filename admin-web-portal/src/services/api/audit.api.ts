import { apiClient } from '../apiClient';

export interface AuditLog {
  id: number;
  username: string;
  action: string;
  details: string;
  status: string;
  createdAt: string;
}

export interface PaginatedResponse<T> {
  content: T[];
  number: number;
  size: number;
  totalElements: number;
  totalPages: number;
  last: boolean;
}

export const auditApi = {
  getLogs: async (page = 0, size = 15, username?: string, action?: string, date?: string) => {
    let url = `/admin/audit-logs?page=${page}&size=${size}`;
    if (username) url += `&username=${encodeURIComponent(username)}`;
    if (action && action !== 'ALL') url += `&action=${action}`;
    if (date) url += `&date=${date}`;
    
    const response = await apiClient.get<{ data: PaginatedResponse<AuditLog> }>(url);
    return response.data.data;
  }
};
