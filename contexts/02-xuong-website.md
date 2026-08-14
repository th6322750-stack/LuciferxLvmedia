# Context — Xưởng Website (Website Factory)

Project 2/6. Phụ trách toàn bộ vòng đời sản xuất website doanh nghiệp cho Lạc Việt Media Agency. Không lặp lại AI_CONTEXT.md — chỉ trỏ đường.

## Đọc trước khi làm việc
1. `AI_CONTEXT.md`, `AI_WORKING_RULES.md`, `DO_NOT_DO.md` — bắt buộc, mọi project.
2. `AI_OPERATING_SCOPE.md` — chỉ phần "3. Website Production OS", "Website — ưu tiên cao hiện tại" và "4. QA OS" (Playwright/browser testing).
3. `CHANNEL_STRATEGY.md` — chỉ phần Kênh 2 "Kênh Website" (audit, case study, SEO dùng làm content).
4. Skill/workflow sản xuất web: repo `webbyLucifer` (https://github.com/th6322750-stack/webbyLucifer).
5. `OPEN_QUESTIONS.md` — mục "Ưu tiên cao" liên quan website (khách hàng mục tiêu, phân khúc ngành, mô hình giá).

## Nhiệm vụ Project
- Intake yêu cầu khách hàng, research ngành/đối thủ, audit website hiện có.
- Sitemap, UX/UI, content plan, asset plan.
- Frontend/backend/database khi dự án cần.
- SEO kỹ thuật và nội dung.
- QA bằng browser thực tế, ưu tiên Playwright.
- Quản lý revision/approval, deployment và tài liệu bàn giao.
- Tự động hóa quy trình sản xuất website khi phù hợp.

## Ngoài phạm vi (không xử lý ở đây)
- Chiến lược thương hiệu/roadmap tổng → Lucifer HQ.
- Viết/dựng content social quảng bá dịch vụ website → Nhà Máy Nội Dung (nhưng case study kỹ thuật do project này cung cấp dữ liệu).
- Sales pipeline, CRM, báo giá/hợp đồng khách hàng → Vận Hành Agency.
- Sự cố tài khoản Facebook/TikTok của khách → Hỗ Trợ Mạng Xã Hội.

## APPROVED
- Website là ưu tiên kinh doanh cao nhất hiện tại (`CAREER.md`, `AI_CONTEXT.md`).
- Workflow chuẩn tham chiếu `webbyLucifer`.
- QA ưu tiên browser thực tế/Playwright, không coi compile thành công là đủ (`AI_WORKING_RULES.md`).
- Kênh Website là 1 trong 3 kênh content chính thức, mục tiêu chính là kéo khách làm website (`CHANNEL_STRATEGY.md`).

## TBD
- Khách hàng mục tiêu cụ thể (ngành, quy mô).
- Phân khúc ngành đánh đầu tiên.
- Mô hình giá: gói cố định / báo giá dự án / thuê bao / kết hợp.
- Coding convention, UI/UX design rule tổng quát.
- Môi trường kỹ thuật của Lucifer (OS/IDE/Node-Python-Java version/Git-Docker/hosting-domain-VPS) — `ABOUT_ME.md`.

## PROPOSAL
Được đề xuất kiến trúc kỹ thuật, stack, quy trình QA cụ thể cho từng dự án — nhưng nếu đề xuất đổi framework/kiến trúc đã chốt của một dự án đang chạy, phải chờ Lucifer duyệt trước khi áp dụng.

## Cách cập nhật bài học ngược về Central Brain
Sau mỗi dự án website: ghi nhận Task → Execution → Result → QA → Lesson (lỗi thường gặp, pattern khách hàng hay yêu cầu, quy trình QA hiệu quả). Nếu bài học có giá trị lâu dài và có bằng chứng từ dự án thực tế, đề xuất cập nhật vào `AI_OPERATING_SCOPE.md` (phần Website Production OS/QA OS) hoặc bổ sung file mới trong `knowledge/` — qua Lucifer HQ xác nhận trước khi sửa Central Brain.
