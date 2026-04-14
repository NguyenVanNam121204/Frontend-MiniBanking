import { BrowserRouter } from 'react-router-dom';
import AppRoutes from './routes/AppRoutes';

const App = () => {
  return (
    <BrowserRouter>
      {/* Nơi cấu hình các Global Component chặn ngoài như: ToastContainer, ModalRoot, v.v */}
      <AppRoutes />
    </BrowserRouter>
  );
};

export default App;
