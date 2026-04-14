import { Routes, Route, Navigate } from 'react-router-dom';
import Login from '../pages/auth/Login/Login';
import Dashboard from '../pages/admin/Dashboard/Dashboard';
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
          <Route path="/admin/users" element={<div className="text-white">User Management Coming Soon...</div>} />
          {/* Add other admin routes here */}
        </Route>
      </Route>

      {/* Redirect everything else to Login */}
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
};

export default AppRoutes;
