# 🎯 Flutter Banking - Agent Skill Standards (MVVM + Riverpod)

## 🏗️ 1. Kiến trúc & Phân lớp (Architecture)
*   **Mô hình**: MVVM (Model-View-ViewModel).
*   **Data Flow**: Unidirectional (Luồng một chiều).
*   **View**: Chỉ dùng `ConsumerWidget` hoặc `ConsumerStatefulWidget`. Không chứa business logic.
*   **ViewModel**: Sử dụng `StateNotifier` hoặc `AsyncNotifier` từ Riverpod.
*   **Repository**: Lớp xử lý dữ liệu (API/Local). Luôn trả về `Result<T, E>`.
*   **Service**: Các logic hạ tầng (Storage, Auth, Dio).

## 🧩 2. Registry Provider tập trung
*   Toàn bộ Global Providers (Service, Repo, global ViewModel) phải được đăng ký tại `lib/app/providers.dart`.
*   Hạn chế khởi tạo Provider rải rác để dễ kiểm soát Dependency Injection.

## 🧠 3. Quản lý Trạng thái (State Management)
*   **Immutable**: Dùng `freezed` cho State. Cập nhật qua `.copyWith()`.
*   **Logic Safety**: Bắt buộc kiểm tra `if (!mounted) return;` sau mỗi lệnh `await` trước khi tác động lên UI hoặc State.

## 🛠️ 4. Quy tắc Code & Đặt tên
*   **Feature-based Structure**: Bắt buộc tổ chức folder theo tính năng (feature) bên trong mỗi Layer.
    *   Ví dụ: `repositories/transfer/transfer_repository.dart`, `viewmodels/auth/login_view_model.dart`.
*   **Files/Folders**: `snake_case`.
*   **Classes**: `PascalCase`.
*   **Tách Widget**: Widget vượt quá 200 dòng hoặc có tính tái sử dụng cao phải được tách ra file riêng.
*   **Base Components**: Ưu tiên sử dụng widget dùng chung từ `lib/core/widgets/`.

## 🔒 5. Bảo mật & Networking
*   **Storage**: Dùng `FlutterSecureStorage` cho dữ liệu nhạy cảm.
*   **Dio Interceptor**: Tự động xử lý Refresh Token (401) và đính kèm Auth Header.
*   **Error Mapping**: Map lỗi Dio sang `AppException` tại tầng Repository.

## 🚦 6. Điều hướng (Navigation)
*   Sử dụng **Navigator 1.0/2.0 gốc** của Flutter (không dùng GoRouter để tránh rườm rà).
*   Quản lý Route tập trung tại `lib/app/app_routes.dart` (nếu cần).
