import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface AuthState {
  token: string | null;
  refreshToken: string | null;
  isAuthenticated: boolean;
  setAuth: (token: string, refreshToken: string) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      token: null,
      refreshToken: null,
      isAuthenticated: false,
      setAuth: (token, refreshToken) => set({ token, refreshToken, isAuthenticated: true }),
      logout: () => set({ token: null, refreshToken: null, isAuthenticated: false }),
    }),
    { name: 'admin-auth-storage' }
  )
);
