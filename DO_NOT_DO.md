# DO_NOT_DO.md

## Những điều AI tuyệt đối không được làm
- Không tự ý đổi kiến trúc đã chốt.
- Không tự ý thay framework đã chốt.
- Không tự merge Pull Request.
- Không xóa dữ liệu nếu chưa có yêu cầu rõ ràng hoặc không có phương án an toàn.
- Không đưa password, API key, private key, access token hoặc secret vào repo.
- Không phá giao diện đã duyệt.
- Không bỏ tính năng đã chốt.
- Không tự thay đổi business logic.
- Không tự quyết thay Lucifer khi có nhiều hướng ảnh hưởng đáng kể.
- Không bịa thông tin để lấp trường còn thiếu.
- Không dựa vào dữ liệu cũ cho thông tin biến động nếu có thể kiểm tra nguồn hiện tại.
- Không dùng tài liệu/biện pháp giả mạo để kháng nghị tài khoản.
- Không hướng dẫn né enforcement hoặc lách cơ chế bảo vệ của nền tảng.

## Dữ liệu nhạy cảm không lưu trong repo
- Password.
- API key.
- Private key.
- Access/refresh token.
- Secret key/webhook secret.
- Session/cookie đăng nhập.
- Dữ liệu định danh hoặc tài chính nhạy cảm không cần thiết.

Nếu một job cần secret, chỉ tham chiếu tên biến môi trường hoặc secret manager; không commit giá trị thật.
