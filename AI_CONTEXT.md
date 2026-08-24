# AI_CONTEXT.md

Entry point cho mọi AI làm việc với Lucifer.

## Identity
- Tên gọi: Lucifer
- Năm sinh: 2005
- Quốc gia: Việt Nam
- Ngôn ngữ chính: Tiếng Việt
- Xưng hô: anh - em

## Định hướng
- Công việc chính: MMO
- Làm việc cá nhân
- Đang phát triển mảng truyền thông từ 2026-08-14
- Thị trường chính: Việt Nam
- Ưu tiên hiện tại: xây dựng và thiết kế website cho doanh nghiệp
- Thương hiệu đang phát triển: Lạc Việt Media Agency
- Slogan: Cần Kiệm Liêm Chính
- Mục tiêu 1-3 năm: hướng tới 3 tỷ VND
- Sản phẩm vận hành trung tâm đang định hình: Lạc Việt Agency OS

## Quy tắc AI cốt lõi
- Trả lời đầy đủ, tập trung, không hoa mỹ, không lan man, không emoji.
- Với thông tin có khả năng thay đổi theo thời gian, bắt buộc kiểm tra nguồn Internet hiện tại trước khi kết luận.
- Ưu tiên nguồn: chính thức -> tài liệu gốc -> nguồn uy tín -> cộng đồng thực tế.
- Chủ động đề xuất phương án tốt hơn nhưng không tự quyết thay Lucifer.
- Không tự thay đổi yêu cầu, kiến trúc, framework hoặc business logic đã chốt.
- Được cảnh báo rủi ro bảo mật, tài chính, pháp lý, chính sách hoặc mất dữ liệu.
- Khi làm web, ưu tiên QA bằng browser/Playwright khi phù hợp.
- Được tạo branch, sửa, commit, push và mở PR; không tự merge PR.

## Central Brain
Repo này là bộ não trung tâm: lưu context, dự án, skill, quyết định, bài học và câu hỏi mở. Sau mỗi job quan trọng cần đánh giá bài học nào nên cập nhật ngược về repo.

## Agent Departments — routing hiện hành
Từ 2026-08-23, kiến trúc đa-agent chính thức dùng 6 Agent Departments và được định nghĩa trong `AGENT_DEPARTMENTS.md`.

Worker pool hiện tại:
- Hermes — Master Agent / CEO / Router / Orchestrator.
- Claude Code — code / implementation / technical mechanism.
- ChatGPT — design / UI / asset / image / content / synthesis.
- Gemini — visual QA / multimodal / research / verification.

Hiện chưa giả định có Codex hoặc Grok. Khi thêm model mới, chỉ mở rộng worker pool và routing, không thay đổi cấu trúc 6 phòng ban.

6 phòng ban:
1. Lucifer HQ / Bộ Não Trung Tâm.
2. Xưởng Website / Website Factory.
3. Nhà Máy Nội Dung / Content Factory.
4. Vận Hành Agency / CRM & Sales.
5. Hỗ Trợ Mạng Xã Hội / Social Support.
6. R&D / MMO & Dịch Vụ Số.

Mỗi phòng ban tái sử dụng context tương ứng trong `contexts/`.

## Channel strategy đã chốt
Lạc Việt Media Agency định hướng 3 content vertical (cập nhật 2026-08-14, thay thế cấu trúc 4 kênh cũ), ưu tiên TikTok nhưng phân phối đa nền tảng. Kiến trúc dài hạn đã duyệt:

3 kênh -> AI Research -> Content Factory -> Auto Edit -> Auto Publish -> Analytics -> CRM Lead -> Sales -> Khách hàng -> AI học lại dữ liệu.

Chi tiết đọc CHANNEL_STRATEGY.md.

## Claude Projects — legacy organization
`CLAUDE_PROJECTS.md` được giữ làm tài liệu lịch sử cho cấu trúc 6 Claude Projects trước đây. Routing đa-agent hiện hành dùng `AGENT_DEPARTMENTS.md` làm authority.

## Skill hiện tại
- Web workflow skill: https://github.com/th6322750-stack/webbyLucifer

## Tài liệu đọc tiếp
- AGENT_DEPARTMENTS.md — routing đa-agent hiện hành.
- ABOUT_ME.md
- CAREER.md
- AI_OPERATING_SCOPE.md
- AI_WORKING_RULES.md
- CHANNEL_STRATEGY.md
- DO_NOT_DO.md
- OPEN_QUESTIONS.md
- contexts/ — context chuyên môn cho 6 Agent Departments.
- CLAUDE_PROJECTS.md — legacy/history.

Version: 0.2-draft
Created: 2026-08-14
Updated: 2026-08-23
