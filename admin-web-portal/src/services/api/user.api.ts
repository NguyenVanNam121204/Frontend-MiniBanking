import { apiClient } from '../apiClient';

export interface User {
  id: number;
  username: string;
  email: string;
  fullName: string;
  status: 'ACTIVE' | 'LOCKED' | 'PENDING';
  roles: string[];
  createdAt: string;
}

export interface PaginatedResponse<T> {
  content: T[];
  page: {
    size: number;
    number: number;
    totalElements: number;
    totalPages: number;
  };
}

export const userApi = {
  getUsers: async (page = 0, size = 10) => {
    const response = await apiClient.get<{ data: PaginatedResponse<User> }>(`/admin/users?page=${page}&size=${size}`);
    return response.data.data;
  },

  lockUser: async (userId: number) => {
    const response = await apiClient.post(`/admin/users/${userId}/lock`);
    return response.data;
  },

  unlockUser: async (userId: number) => {
    const response = await apiClient.post(`/admin/users/${userId}/unlock`);
    return response.data;
  },

  resetPassword: async (userId: number, newPassword: string) => {
    const response = await apiClient.post(`/admin/users/${userId}/force-reset-password`, { newPassword });
    return response.data;
  }
};
