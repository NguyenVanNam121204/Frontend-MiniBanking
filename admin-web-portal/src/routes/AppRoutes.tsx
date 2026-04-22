import { Routes, Route, Navigate } from 'react-router-dom';
import Login from '../pages/auth/Login/Login';
import Dashboard from '../pages/admin/Dashboard/Dashboard';
import UserManagement from '../pages/admin/UserManagement/UserManagement';
import AuditLogs from '../pages/admin/AuditLogs/AuditLogs';
import TransactionManagement from '../pages/admin/TransactionManagement/TransactionManagement';
import ProtectedRoute from './ProtectedRoute';
import AdminLayout from '../components/layout/AdminLayout/AdminLayout';

const AppRoutes = () => {
  return (
    <Routes>
      {/* Public Routes */}
      <Route path="/login" element={<Login />} />

      {/* Protected Routes (Admin Only) */}
      <Route element={<ProtectedRoute />}>
        <Route element={<AdminLayout />}>
          <Route path="/admin/dashboard" element={<Dashboard />} />
          <Route path="/admin/users" element={<UserManagement />} />
          <Route path="/admin/transactions" element={<TransactionManagement />} />
          <Route path="/admin/logs" element={<AuditLogs />} />
          {/* Add other admin routes here */}
        </Route>
      </Route>

      {/* Redirect everything else to Login */}
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
};

export default AppRoutes;
