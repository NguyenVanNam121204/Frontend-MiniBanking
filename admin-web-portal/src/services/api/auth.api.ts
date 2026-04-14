import { apiClient } from '../apiClient';

interface LoginPayload {
  username: string;
  password: string;
}

interface LoginResponse {
  message: string;
  data: {
    accessToken: string;
    refreshToken: string;
    tokenType: string;
  };
}

export const authApi = {
  login: async (data: LoginPayload): Promise<LoginResponse> => {
    const response = await apiClient.post<LoginResponse>('/auth/login', data);
    return response.data;
  },
};
