# Context — Hỗ Trợ Mạng Xã Hội (Social Support)

Project 5/6. Tách riêng khỏi các project khác vì đây là mảng dịch vụ độc lập, phụ thuộc nhiều vào chính sách Facebook/TikTok thay đổi theo thời gian — cần research nguồn hiện tại gần như mỗi lần xử lý case. Không lặp lại AI_CONTEXT.md — chỉ trỏ đường.

## Đọc trước khi làm việc
1. `AI_CONTEXT.md`, `AI_WORKING_RULES.md`, `DO_NOT_DO.md` — bắt buộc, mọi project (đặc biệt phần "Không dùng tài liệu/biện pháp giả mạo để kháng nghị" và "Không hướng dẫn né enforcement").
2. `AI_OPERATING_SCOPE.md` — chỉ phần "Account recovery / appeals".
3. `knowledge/account-appeals.md` — tài liệu nghiệp vụ chính, đọc FULL trước khi xử lý case.

## Nhiệm vụ Project
- Phân loại sự cố Facebook/TikTok theo `knowledge/account-appeals.md` (suspend/disable, security lock, hacked, mất email/phone, identity verification, business/ads restriction, account ban, feature restriction, underage appeal, creator restriction, ads suspension, rejected ad, transaction/payment restriction).
- Xác định đúng kênh khôi phục/kháng nghị chính thức hiện hành cho từng loại sự cố (luôn kiểm tra nguồn chính thức tại thời điểm xử lý, vì chính sách/form có thể đổi).
- Chuẩn bị checklist bằng chứng/tài liệu và soạn nội dung kháng nghị trung thực.
- Ghi lại kết quả thực tế từng case để cải thiện checklist vận hành.

## Ngoài phạm vi (không xử lý ở đây)
- Nội dung quảng bá/marketing về dịch vụ hỗ trợ MXH (thuộc Kênh tổng) → Nhà Máy Nội Dung.
- Bán/định giá dịch vụ, hợp đồng khách hàng → Vận Hành Agency.
- Vận hành quảng cáo Meta/TikTok Ads thật (Ads OS là roadmap tương lai, chưa triển khai) → Lucifer HQ quyết định khi tới thời điểm.
- Nghiên cứu mô hình dịch vụ tài khoản số mới (khác với xử lý sự cố) → R&D.

## APPROVED
- Chỉ dùng quy trình khôi phục/kháng nghị chính thức của nền tảng.
- Không dùng bằng chứng giả, không hướng dẫn né enforcement hoặc lách cơ chế bảo vệ nền tảng (`DO_NOT_DO.md`).
- Không hứa chắc mở khóa (`knowledge/account-appeals.md`).
- Không gửi nhiều appeal trùng lặp nếu nền tảng cảnh báo điều đó làm chậm review.
- Quy trình xử lý chuẩn 7 bước trong `knowledge/account-appeals.md` (xác định nền tảng/asset → hỏi thông báo lỗi/screenshot → kiểm tra tài liệu chính thức hiện tại → xác định deadline/điều kiện/tài liệu cần → soạn nội dung dựa trên sự thật → không spam appeal → ghi lại kết quả).

## TBD
- Danh sách dịch vụ hỗ trợ MXH cụ thể đang/sẽ bán (chưa có trong `OPEN_QUESTIONS.md`, cần Lucifer bổ sung khi có).
- Mô hình giá cho dịch vụ support/kháng nghị.
- Kênh tiếp nhận case (qua đâu khách gửi yêu cầu hỗ trợ).

## PROPOSAL
Được đề xuất checklist/quy trình chi tiết hơn cho từng loại sự cố dựa trên case thực tế đã xử lý — không tự quyết thay đổi phạm vi dịch vụ (nhận case loại nào, từ chối case loại nào) nếu ảnh hưởng rủi ro pháp lý/chính sách, phải hỏi Lucifer.

## Cách cập nhật bài học ngược về Central Brain
Sau mỗi case: ghi Task (loại sự cố) → Execution (kênh/luồng đã dùng) → Result (thành công/thất bại, thời gian xử lý) → QA (đúng quy trình chính thức chưa) → Lesson. Vì chính sách nền tảng đổi liên tục, mọi cập nhật vào `knowledge/account-appeals.md` phải ghi rõ ngày kiểm tra nguồn và link nguồn chính thức, qua Lucifer HQ xác nhận trước khi sửa. Không lấy kiến thức cũ làm source of truth nếu chưa kiểm tra lại.
