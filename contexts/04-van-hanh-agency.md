# Context — Vận Hành Agency – CRM & Sales (Agency OS / CRM & Sales)

Project 4/6. Phụ trách phần "biến lead thành khách hàng và giữ khách" của Lạc Việt Agency OS. Không lặp lại AI_CONTEXT.md — chỉ trỏ đường.

Lưu ý: tại thời điểm tạo file này, project chỉ dừng ở kiến trúc context — CHƯA bắt đầu xây dựng Agency OS hay code sản phẩm. Việc build thực tế chờ chỉ đạo riêng của Lucifer.

## Đọc trước khi làm việc
1. `AI_CONTEXT.md`, `AI_WORKING_RULES.md`, `DO_NOT_DO.md` — bắt buộc, mọi project.
2. `AI_OPERATING_SCOPE.md` — chỉ phần "1. Lead Intelligence", "2. Sales OS", "5. Customer Success OS", "8. Operations/PM OS".
3. `CHANNEL_STRATEGY.md` — chỉ phần "Funnel" (kênh đổ traffic về đâu).
4. `OPEN_QUESTIONS.md` — mục "Ưu tiên cao" liên quan lead/sales/CRM.

## Nhiệm vụ Project
- Lead Intelligence: thu thập lead công khai hợp lệ, phân loại theo ngành/khu vực/quy mô/nhu cầu, chấm điểm và ưu tiên.
- Sales OS: quản lý hội thoại, pipeline lead → qualified → proposal → won/lost, gợi ý nội dung tiếp cận/follow-up/proposal/báo giá.
- Customer Success OS: theo dõi khách sau bàn giao, bảo trì, ticket hỗ trợ, nhắc gia hạn, upsell/cross-sell.
- Operations/PM OS: roadmap/backlog/milestone, dashboard hoạt động, nhắc việc, theo dõi tiến độ từng khách hàng/website/nội dung/chiến dịch.

## Ngoài phạm vi (không xử lý ở đây)
- Sản xuất website/technical delivery → Xưởng Website.
- Sản xuất content/kênh → Nhà Máy Nội Dung.
- Xử lý sự cố tài khoản Facebook/TikTok của khách → Hỗ Trợ Mạng Xã Hội.
- Nghiên cứu mô hình kinh doanh mới chưa triển khai → R&D.
- KHÔNG tự code/triển khai Agency OS ở giai đoạn hiện tại nếu chưa có chỉ đạo build cụ thể từ Lucifer.

## APPROVED
- Lạc Việt Agency OS là sản phẩm vận hành trung tâm đang định hình, không chỉ là CRM mà là hệ điều hành kinh doanh tích hợp (`AI_CONTEXT.md`, `AI_OPERATING_SCOPE.md`).
- Toàn bộ lịch sử lead/khách hàng phải lưu lại (`AI_OPERATING_SCOPE.md` mục 1).
- Hướng tới tích hợp tin nhắn đa nền tảng khi API/chính sách cho phép — chưa phải hiện tại.
- Task có ảnh hưởng lớn tới tiền/dữ liệu/tài khoản/public publishing phải có cơ chế approval phù hợp.

## TBD
- Quy trình tìm lead và sales hiện tại (thực tế Lucifer đang làm gì).
- Các kênh CRM cần tích hợp đầu tiên.
- Định vị, USP và bộ dịch vụ đầu tiên của Lạc Việt Media Agency.
- Mô hình giá dịch vụ (liên quan website, xem thêm context Xưởng Website).
- Mục tiêu 6 tháng/1 năm, KPI/doanh thu/lợi nhuận cụ thể.
- Danh sách project hiện tại, format report tiến độ chuẩn.

## PROPOSAL
Được đề xuất kiến trúc dữ liệu CRM, quy trình chấm điểm lead, cấu trúc pipeline sales — nhưng đây đều là business logic, phải trình Lucifer HQ chốt trước khi bắt đầu code hoặc vận hành thật.

## Cách cập nhật bài học ngược về Central Brain
Khi project được phép vận hành thật: ghi nhận Task → Execution → Result → QA → Lesson theo từng lead/khách hàng (loại lead nào chuyển đổi tốt, follow-up nào hiệu quả, lỗi vận hành thường gặp). Bài học có bằng chứng dữ liệu thực tế mới được đề xuất cập nhật `AI_OPERATING_SCOPE.md` hoặc `OPEN_QUESTIONS.md` (chuyển mục TBD thành APPROVED), qua Lucifer HQ xác nhận.
