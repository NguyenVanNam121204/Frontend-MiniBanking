import { apiClient } from '../apiClient';

export interface Transaction {
  id: number;
  referenceNumber: string;
  type: 'DEPOSIT' | 'WITHDRAW' | 'TRANSFER';
  amount: number;
  status: string;
  sourceAccountNumber?: string;
  destinationAccountNumber?: string;
  description: string;
  createdAt: string;
}

export interface PaginatedResponse<T> {
  content: T[];
  pageNo: number;
  pageSize: number;
  totalElements: number;
  totalPages: number;
  last: boolean;
}

export const transactionApi = {
  getAllTransactions: async (page = 0, size = 10) => {
    const response = await apiClient.get<{ data: PaginatedResponse<Transaction> }>(`/admin/transactions?page=${page}&size=${size}`);
    return response.data.data;
  },
  approveTransaction: async (id: number) => {
    const response = await apiClient.post(`/admin/transactions/${id}/approve`);
    return response.data;
  },
  rejectTransaction: async (id: number) => {
    const response = await apiClient.post(`/admin/transactions/${id}/reject`);
    return response.data;
  }
};
