# CLAUDE_PROJECTS.md

Trạng thái: APPROVED — 2026-08-13.

Mô tả cách 6 Claude Projects của Lucifer phối hợp với nhau, dùng chung Central Brain (`LuciferxLvmedia`). Đây là tài liệu điều phối — không thay thế `AI_CONTEXT.md`, chỉ bổ sung tầng "routing" phía trên.

## Vì sao chia 6 Project
Mỗi Project là một chat/workspace riêng trong Claude, có context file riêng trong `contexts/`, giúp mỗi cuộc trò chuyện chỉ load đúng phần Central Brain cần thiết thay vì giải thích lại từ đầu mỗi lần, và tránh lẫn lộn phạm vi công việc (ví dụ: việc kháng nghị Facebook không lẫn vào việc code website).

Lưu ý phân biệt hai khái niệm khác nhau trong repo:
- **6 Claude Projects** — cách tổ chức không gian làm việc với AI (chủ đề của file này).
- **3 kênh content** (Kênh tổng / Kênh Website / Kênh Dịch vụ tài khoản) — chiến lược nội dung marketing, xem `CHANNEL_STRATEGY.md`. Ba kênh này được vận hành chủ yếu bên trong Project 3 "Nhà Máy Nội Dung – Kênh OS", không phải 3 project riêng.

## Danh sách 6 Project

| # | Tên Project (tiếng Việt) | Tên gốc | Context file | Vai trò chính |
|---|---|---|---|---|
| 1 | Lucifer HQ – Bộ Não Trung Tâm | Lucifer HQ / Central Brain | `contexts/01-lucifer-hq.md` | Chiến lược, roadmap, chốt quyết định, duy trì Central Brain |
| 2 | Xưởng Website | Website Factory | `contexts/02-xuong-website.md` | Sản xuất website doanh nghiệp, QA, deploy |
| 3 | Nhà Máy Nội Dung – Kênh OS | Content Factory / Channel OS | `contexts/03-nha-may-noi-dung.md` | Vận hành 3 kênh content, auto edit/publish, analytics |
| 4 | Vận Hành Agency – CRM & Sales | Agency OS / CRM & Sales | `contexts/04-van-hanh-agency.md` | Lead, sales pipeline, customer success, PM |
| 5 | Hỗ Trợ Mạng Xã Hội | Social Support | `contexts/05-ho-tro-mang-xa-hoi.md` | Kháng nghị/khôi phục tài khoản Facebook/TikTok |
| 6 | R&D – MMO & Dịch Vụ Số | R&D / MMO / Digital Services | `contexts/06-rd-mmo-dich-vu-so.md` | Nghiên cứu mô hình, sản phẩm, công nghệ mới |

## Vì sao "Hỗ Trợ Mạng Xã Hội" tách riêng
Quyết định APPROVED: Social Support tách thành Project độc lập (không gộp vào Nhà Máy Nội Dung hay Vận Hành Agency) vì đây là mảng dịch vụ vận hành độc lập, và phụ thuộc nhiều vào chính sách Facebook/TikTok thay đổi liên tục theo thời gian — cần quy trình research nguồn hiện tại riêng biệt, không nên trộn với nhịp làm content hoặc nhịp sales.

## Nguyên tắc chung cho mọi Project
1. Mỗi Project luôn đọc context file riêng của nó trong `contexts/` trước, context file đó tự trỏ tới đúng phần Central Brain cần đọc thêm — không đọc toàn bộ repo mỗi lần trừ khi task yêu cầu.
2. Mọi Project đều tuân `AI_WORKING_RULES.md` và `DO_NOT_DO.md` không có ngoại lệ.
3. Phân biệt APPROVED / TBD / PROPOSAL trong mọi câu trả lời liên quan quyết định.
4. Không tự merge Pull Request ở bất kỳ Project nào.
5. Khi một task cần quyết định vượt phạm vi Project (kiến trúc, chiến lược, business logic, thương hiệu), Project đó dừng lại và đề xuất đưa lên Lucifer HQ thay vì tự quyết.

## Routing — việc nào thuộc Project nào
- Câu hỏi chiến lược, ưu tiên, muốn chốt quyết định lớn → **Lucifer HQ**.
- Làm/sửa website, UI/UX, SEO, QA web → **Xưởng Website**.
- Viết kịch bản, dựng nội dung, lên lịch đăng, phân tích hiệu suất kênh → **Nhà Máy Nội Dung**.
- Quản lý lead, khách hàng, pipeline sales, hợp đồng, chăm sóc sau bán → **Vận Hành Agency**.
- Tài khoản Facebook/TikTok bị khóa/hạn chế, cần kháng nghị → **Hỗ Trợ Mạng Xã Hội**.
- Tìm hiểu mô hình/thị trường/sản phẩm/công cụ mới trước khi triển khai → **R&D**.
- Việc chạm từ 2 Project trở lên (ví dụ: chiến dịch ra mắt dịch vụ mới cần cả content + sales + research) → bắt đầu ở **Lucifer HQ** để điều phối, sau đó tách việc cụ thể về từng Project.

## Luồng dữ liệu/bài học giữa các Project
Mỗi Project ghi nhận bài học theo Task → Execution → Result → QA → Lesson trong phạm vi của mình (chi tiết cách làm nằm trong mục "Cách cập nhật bài học ngược về Central Brain" của từng context file). Bài học có giá trị lâu dài, đã có bằng chứng thực tế, được tổng hợp và xác nhận tại Lucifer HQ trước khi sửa trực tiếp vào file Central Brain liên quan (`AI_CONTEXT.md`, `AI_OPERATING_SCOPE.md`, `CHANNEL_STRATEGY.md`, `knowledge/...`). Không Project nào tự sửa Central Brain một mình nếu thay đổi ảnh hưởng phạm vi ngoài project đó.

## Cập nhật cấu trúc Project trong tương lai
Nếu cần thêm/gộp/tách Project, đây là quyết định chiến lược — xử lý tại Lucifer HQ, cập nhật file này và các context file liên quan, ghi rõ trong UPDATE LOG bên dưới rằng cấu trúc mới thay thế cấu trúc cũ (theo đúng nguyên tắc đã áp dụng khi chuyển từ 4 kênh xuống 3 kênh trong `CHANNEL_STRATEGY.md`).

## UPDATE LOG
- 2026-08-13 — APPROVED: Khởi tạo cấu trúc 6 Claude Projects và toàn bộ context file tương ứng trong `contexts/`.
