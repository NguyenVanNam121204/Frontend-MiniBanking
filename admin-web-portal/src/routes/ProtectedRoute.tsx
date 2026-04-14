import { Navigate, Outlet } from 'react-router-dom';
import { useAuthStore } from '../store/useAuthStore';

const ProtectedRoute = () => {
  const { isAuthenticated } = useAuthStore();

  // Route Guard: Nếu chưa có Token thì đẩy thẳng ra màn Login
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  // Nếu hợp lệ thì cho phép render màn hình con (Các màn hình Admin)
  return <Outlet />;
};

export default ProtectedRoute;
