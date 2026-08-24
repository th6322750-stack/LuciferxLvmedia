# AGENT_DEPARTMENTS.md

Trạng thái: APPROVED — 2026-08-23.

Tài liệu này định nghĩa kiến trúc 6 Agent Departments thay cho cách tổ chức phụ thuộc riêng vào Claude Projects. Các context file hiện có trong `contexts/` được giữ lại và tái sử dụng làm context chuyên môn cho từng phòng ban.

## 1. Agent stack hiện tại

Các agent/model đang được dùng trong kiến trúc hiện tại:

- **Hermes** — Master Agent / CEO / Router / Orchestrator / Memory owner.
- **Claude Code** — chuyên gia code, implementation, technical mechanism, automation kỹ thuật.
- **ChatGPT** — design, UI/UX, content, asset/image generation, reasoning và synthesis.
- **Gemini** — visual QA, multimodal review, research, verification và testing.

Hiện tại **không giả định có Codex hoặc Grok**. Khi hai worker này được thêm sau, chỉ cập nhật routing/worker pool; không cần thay đổi cấu trúc 6 phòng ban.

## 2. Nguyên tắc điều phối

- **Hermes là agent điều phối trung tâm**, luôn nhận task đầu tiên nếu task chưa được route rõ.
- Worker chỉ được gọi khi cần; không bắt buộc duy trì Work/Project session thường trực.
- Một task có thể dùng một hoặc nhiều worker.
- Task đơn giản ưu tiên dùng ít worker để tiết kiệm limit.
- Task quan trọng hoặc có bất đồng có thể gọi nhiều worker để review chéo.
- Mỗi phòng ban đọc đúng context file của mình trước, không load toàn bộ Central Brain nếu không cần.
- Các worker chia sẻ kết quả thông qua Hermes và task state chung; không cần tự giữ toàn bộ memory cá nhân của Lucifer.
- Central Brain (`LuciferxLvmedia`) là source of truth cho identity, rules, business context, decisions và lessons.

## 3. Sáu Agent Departments

### 01 — Lucifer HQ / Bộ Não Trung Tâm

**Context:** `contexts/01-lucifer-hq.md`

**Vai trò:**
- Chiến lược.
- Roadmap.
- Quyết định lớn.
- Điều phối task liên phòng ban.
- Quản lý Central Brain.
- Phân công worker.
- Theo dõi task state, kết quả và lesson.

**Agent chính:**
- Lead: **Hermes**.
- Advisor/Synthesis: **ChatGPT**.
- Research/Verification: **Gemini**.
- Technical advisor khi cần: **Claude Code**.

**Routing:** task chạm từ 2 phòng ban trở lên phải quay về Lucifer HQ để Hermes chia việc.

---

### 02 — Xưởng Website / Website Factory

**Context:** `contexts/02-xuong-website.md`

**Skill chính:** `webbyLucifer` — https://github.com/th6322750-stack/webbyLucifer

**Vai trò:**
- Website mới / redesign.
- UI/UX.
- Frontend/backend.
- Asset web.
- Bug fix / polish.
- Responsive.
- SEO kỹ thuật.
- Browser QA.
- Deploy/handoff.

**Agent team:**
- Coordinator: **Hermes**.
- Design / UI / asset / image: **ChatGPT**.
- Implementation / code / technical mechanism: **Claude Code**.
- Visual QA / browser review / verification: **Gemini**.

**Luồng mặc định:**

```text
Hermes route task
→ ChatGPT chuẩn bị visual/asset/spec khi cần
→ Claude Code implement
→ Gemini kiểm tra
→ fail: Hermes trả đúng lỗi về worker phù hợp
→ pass: báo kết quả
```

Không ép full pipeline cho task polish/bug nhỏ; tuân task router trong `webbyLucifer`.

---

### 03 — Nhà Máy Nội Dung / Content Factory

**Context:** `contexts/03-nha-may-noi-dung.md`

**Vai trò:**
- Research chủ đề.
- Ý tưởng nội dung.
- Script/hook/CTA/caption/title.
- Visual/thumbnail/asset.
- Repurpose đa nền tảng.
- Content automation.
- Analytics và lesson từ dữ liệu hiệu suất.

**Agent team:**
- Coordinator: **Hermes**.
- Content / creative / image: **ChatGPT**.
- Research / multimodal review / verification: **Gemini**.
- Automation/code/tooling khi cần: **Claude Code**.

---

### 04 — Vận Hành Agency / CRM & Sales

**Context:** `contexts/04-van-hanh-agency.md`

**Vai trò:**
- Lead management.
- CRM.
- Sales pipeline.
- Proposal/báo giá/follow-up support.
- Customer success.
- PM/task tracking.
- Automation vận hành.

**Agent team:**
- Lead/Coordinator: **Hermes**.
- Analysis / proposal / communication support: **ChatGPT**.
- Research / verification / data review: **Gemini**.
- Integration / automation / internal tools: **Claude Code**.

---

### 05 — Hỗ Trợ Mạng Xã Hội / Social Support

**Context:** `contexts/05-ho-tro-mang-xa-hoi.md`

**Vai trò:**
- Phân loại sự cố tài khoản/nền tảng.
- Research chính sách và quy trình hiện hành.
- Chuẩn bị hồ sơ/checklist/appeal trung thực.
- Theo dõi case state.

**Agent team:**
- Coordinator: **Hermes**.
- Current-policy research / multimodal evidence review: **Gemini**.
- Case synthesis / draft support: **ChatGPT**.
- Tooling/automation kỹ thuật khi thật sự cần: **Claude Code**.

Thông tin chính sách nền tảng có thể thay đổi phải kiểm tra nguồn hiện tại trước khi kết luận.

---

### 06 — R&D / MMO & Dịch Vụ Số

**Context:** `contexts/06-rd-mmo-dich-vu-so.md`

**Vai trò:**
- Nghiên cứu công nghệ/công cụ mới.
- Nghiên cứu mô hình kinh doanh/sản phẩm số.
- Phân tích đối thủ/thị trường.
- Đánh giá feasibility.
- Prototype khi cần.

**Agent team:**
- Lead/Router: **Hermes**.
- Research / source verification: **Gemini**.
- Synthesis / product thinking / design: **ChatGPT**.
- Technical feasibility / prototype/code: **Claude Code**.

## 4. Worker routing theo năng lực

```text
CODE / IMPLEMENTATION
→ Claude Code

DESIGN / UI / ASSET / IMAGE / CONTENT
→ ChatGPT

VISUAL QA / MULTIMODAL / RESEARCH / VERIFICATION
→ Gemini

ROUTING / TASK STATE / MEMORY / CROSS-DEPARTMENT
→ Hermes
```

Nếu task cần nhiều năng lực:

```text
Hermes
→ chia subtask
→ gọi đúng worker
→ gom kết quả
→ giao bước tiếp theo
→ QA
→ DONE hoặc loop sửa
```

## 5. Limit-aware routing

Không gọi tất cả model cho mọi task.

```text
TASK ĐƠN GIẢ
→ 1 worker phù hợp

TASK CẦN REVIEW
→ worker chính + 1 reviewer

TASK CÓ BẤT ĐỒNG / QUAN TRỌNG
→ Hermes gọi thêm worker còn lại để phản biện/verify
```

Mục tiêu: chất lượng đủ cao nhưng không đốt limit không cần thiết.

## 6. Executor trên máy Agent

Laptop Agent là execution environment chung.

Hermes/worker có thể yêu cầu thực thi:
- filesystem.
- terminal.
- browser.
- Playwright.
- Git/GitHub.
- npm/node.
- Python.
- Docker.
- process/service management.
- cài package/tool cần thiết.

Worker không cần là một “máy” riêng; toàn bộ worker có thể dùng chung laptop thông qua orchestration/executor layer.

Khi runtime gặp blocker thật sự không thể tự giải quyết (ví dụ CAPTCHA, 2FA, credential chưa có, quyết định cần Lucifer), Hermes phải báo về Telegram với:

```text
BLOCKER
Task:
Đang ở bước:
Vấn đề:
Đã thử:
Cần Lucifer làm/chọn:
```

## 7. Telegram team mapping

Một group Telegram có thể đại diện cho toàn bộ team.

Vai trò logic:
- **CEO / Master:** Hermes.
- **Chuyên gia Code:** Claude Code.
- **Chuyên gia Thiết kế/Tạo ảnh:** ChatGPT.
- **Chuyên gia Kiểm thử:** Gemini.

Tên bot Telegram cụ thể có thể cấu hình ở runtime; Central Brain lưu role, không phụ thuộc cứng vào username Telegram.

## 8. Memory và lesson loop

Sau task quan trọng:

```text
TASK
→ EXECUTION
→ RESULT
→ QA
→ LESSON
```

Hermes đánh giá lesson nào có giá trị lâu dài rồi đề xuất/cập nhật Central Brain theo quy tắc GitHub hiện hành.

Không lưu password, API key, private key, token, OTP hoặc secret vào Central Brain.

## 9. Mở rộng worker sau này

Khi có Codex, Grok hoặc model khác:

```text
new worker
→ khai báo capability
→ khai báo department được phép dùng
→ thêm routing priority/fallback
→ benchmark
→ đưa vào worker pool
```

Không đổi 6 Agent Departments chỉ vì thêm model.

## 10. Quan hệ với kiến trúc cũ

`CLAUDE_PROJECTS.md` được giữ làm tài liệu lịch sử về cách tổ chức 6 workspace Claude trước đây.

Từ 2026-08-23, routing đa-agent hiện hành dùng **AGENT_DEPARTMENTS.md** làm authority. Sáu context file trong `contexts/` tiếp tục được tái sử dụng cho sáu phòng ban tương ứng.
