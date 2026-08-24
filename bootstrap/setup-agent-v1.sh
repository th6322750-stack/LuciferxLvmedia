#!/usr/bin/env bash
set -Eeuo pipefail

AGENT_USER="${SUDO_USER:-${USER}}"
AGENT_HOME="$(getent passwd "$AGENT_USER" | cut -d: -f6)"
ROOT="/opt/lucifer-agent"
BRAIN="$ROOT/brain"
RUNTIME="$ROOT/runtime"
MEMORY="$ROOT/memory"
LOGS="$ROOT/logs"
WORKSPACE="$ROOT/workspace"
BROWSER="$ROOT/browser"
ENV_DIR="/etc/lucifer-agent"

if [[ $EUID -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

say(){ printf '\n\033[1;36m[LUCIFER] %s\033[0m\n' "$*"; }
warn(){ printf '\n\033[1;33m[WARN] %s\033[0m\n' "$*"; }

say "Installing base/full-stack packages"
$SUDO apt-get update
$SUDO apt-get install -y \
  ca-certificates curl wget git jq sqlite3 python3 python3-venv python3-pip \
  ffmpeg imagemagick bubblewrap htop unzip ripgrep net-tools gh

# Docker is useful for isolated build/test workers. Failure is non-fatal on mirrors that do not expose compose-v2.
if ! dpkg -s docker.io >/dev/null 2>&1; then
  $SUDO apt-get install -y docker.io || true
fi
$SUDO systemctl enable --now docker 2>/dev/null || true
$SUDO usermod -aG docker "$AGENT_USER" 2>/dev/null || true

say "Creating agent filesystem"
$SUDO mkdir -p "$ROOT"/{brain,skills,runtime,logs,memory,workspace,browser}
$SUDO chown -R "$AGENT_USER:$AGENT_USER" "$ROOT"
$SUDO mkdir -p "$ENV_DIR"
$SUDO chmod 700 "$ENV_DIR"

# Keep the Central Brain on the orchestrator branch.
if [[ ! -d "$BRAIN/.git" ]]; then
  git clone -b agent-departments-v1 https://github.com/th6322750-stack/LuciferxLvmedia.git "$BRAIN"
else
  git -C "$BRAIN" fetch origin agent-departments-v1 || true
  git -C "$BRAIN" checkout agent-departments-v1 || true
  git -C "$BRAIN" pull --ff-only origin agent-departments-v1 || true
fi

if [[ ! -d "$ROOT/skills/webbyLucifer/.git" ]]; then
  mkdir -p "$ROOT/skills"
  git clone https://github.com/th6322750-stack/webbyLucifer.git "$ROOT/skills/webbyLucifer"
else
  git -C "$ROOT/skills/webbyLucifer" pull --ff-only || true
fi

say "Installing structured system facts"
cat > "$RUNTIME/system_facts.py" <<'PY'
#!/usr/bin/env python3
import json, pathlib, subprocess, os
WORK = pathlib.Path('/opt/lucifer-agent/workspace')

def run(cmd):
    try:
        return subprocess.check_output(cmd, text=True, stderr=subprocess.STDOUT, timeout=15).strip()
    except Exception as e:
        return f'ERROR: {e}'

entries = list(WORK.iterdir()) if WORK.exists() else []
facts = {
    'workspace': {'path': str(WORK), 'entry_count': len(entries), 'entries': [p.name for p in entries]},
    'system': {'uptime_seconds': float(open('/proc/uptime').read().split()[0]), 'load_average': list(os.getloadavg())},
    'memory_bytes': {}, 'disk_root': {}, 'gpu': {}, 'ollama_raw': run(['ollama','ps'])
}
mem = run(['free','-b']).splitlines()
if len(mem) >= 2:
    x = mem[1].split(); facts['memory_bytes'] = {'total': int(x[1]), 'used': int(x[2]), 'available': int(x[6])}
disk = run(['df','-B1','--output=size,used,avail,pcent','/']).splitlines()
if len(disk) >= 2:
    x = disk[1].split(); facts['disk_root'] = {'total_bytes': int(x[0]), 'used_bytes': int(x[1]), 'available_bytes': int(x[2]), 'used_percent': int(x[3].replace('%',''))}
gpu = run(['nvidia-smi','--query-gpu=name,memory.total,memory.used,utilization.gpu,temperature.gpu','--format=csv,noheader,nounits'])
if not gpu.startswith('ERROR'):
    x = [i.strip() for i in gpu.split(',')]
    facts['gpu'] = {'name': x[0], 'vram_total_mib': int(x[1]), 'vram_used_mib': int(x[2]), 'utilization_percent': int(x[3]), 'temperature_c': int(x[4])}
print(json.dumps(facts, ensure_ascii=False, indent=2))
PY
chmod +x "$RUNTIME/system_facts.py"
$SUDO ln -sf "$RUNTIME/system_facts.py" /usr/local/bin/system-facts

say "Installing long-term memory"
cat > "$RUNTIME/memory.py" <<'PY'
#!/usr/bin/env python3
import sqlite3, sys, datetime, pathlib
DB = pathlib.Path('/opt/lucifer-agent/memory/brain.db'); DB.parent.mkdir(parents=True, exist_ok=True)
con = sqlite3.connect(DB)
con.execute('CREATE TABLE IF NOT EXISTS memories (id INTEGER PRIMARY KEY AUTOINCREMENT,type TEXT NOT NULL,scope TEXT DEFAULT "global",content TEXT NOT NULL,created_at TEXT NOT NULL)')
con.commit()
cmd = sys.argv[1] if len(sys.argv) > 1 else ''
if cmd in ('remember','feedback','project'):
    if len(sys.argv) < 3: raise SystemExit(f'Usage: memory {cmd} "noi dung"')
    content=' '.join(sys.argv[2:]); now=datetime.datetime.now(datetime.timezone.utc).isoformat()
    con.execute('INSERT INTO memories(type,scope,content,created_at) VALUES(?,?,?,?)',(cmd,'global',content,now)); con.commit(); print(f'[MEMORY] Saved {cmd}: {content}')
elif cmd == 'recent':
    for r in con.execute('SELECT id,type,content FROM memories ORDER BY id DESC LIMIT 30').fetchall(): print(f'#{r[0]} [{r[1]}] {r[2]}')
elif cmd == 'search':
    q=' '.join(sys.argv[2:])
    for r in con.execute('SELECT id,type,content FROM memories WHERE content LIKE ? ORDER BY id DESC LIMIT 30',(f'%{q}%',)).fetchall(): print(f'#{r[0]} [{r[1]}] {r[2]}')
else:
    print('memory remember|feedback|project "..." | memory recent | memory search "..."')
PY
chmod +x "$RUNTIME/memory.py"
$SUDO ln -sf "$RUNTIME/memory.py" /usr/local/bin/memory

say "Installing Hermes router"
cat > "$RUNTIME/hermes_router.py" <<'PY'
#!/usr/bin/env python3
import sys, subprocess, datetime, json, pathlib, sqlite3
ROOT=pathlib.Path('/opt/lucifer-agent'); BRAIN=ROOT/'brain'; LOGS=ROOT/'logs'; MEMORY=ROOT/'memory'
LOGS.mkdir(parents=True,exist_ok=True); MEMORY.mkdir(parents=True,exist_ok=True)
task=' '.join(sys.argv[1:]).strip()
if not task: raise SystemExit('Dung: hermes "nhiem vu"')
def read(name):
    p=BRAIN/name; return p.read_text(errors='ignore') if p.exists() else ''
mem=''; db=MEMORY/'brain.db'
if db.exists():
    try:
        con=sqlite3.connect(db); rows=con.execute('SELECT type,content FROM memories ORDER BY id DESC LIMIT 30').fetchall(); con.close()
        mem='\n'.join(f'[{t}] {c}' for t,c in reversed(rows))
    except Exception: pass
ctx='\n\n'.join([read('AI_CONTEXT.md'),read('AI_WORKING_RULES.md'),read('AGENT_DEPARTMENTS.md'),'LONG TERM MEMORY:\n'+mem])
low=task.lower()
if any(x in low for x in ['audit','review','qa','kiem thu','kiểm thử','security','kiểm tra code']): route='codex'
elif any(x in low for x in ['code','repo','bug','fix','refactor','frontend','backend','website','sửa code']): route='claude'
else: route='qwen'
prompt=f'''CENTRAL BRAIN:\n{ctx}\n\nNHIEM VU:\n{task}\n\nQUY TAC: Tuân thủ Central Brain. Trả lời tiếng Việt. Không bịa trạng thái/tool. Nếu chưa có bằng chứng tool thì nói chưa xác minh.'''
print(f'[HERMES] -> {route.upper()}')
if route=='claude': cmd=['claude','-p',prompt]; cwd=str(BRAIN)
elif route=='codex': cmd=['codex','exec',prompt]; cwd=str(BRAIN)
else: cmd=['ollama','run','qwen3:4b',prompt]; cwd=None
started=datetime.datetime.now(datetime.timezone.utc)
try:
    r=subprocess.run(cmd,cwd=cwd,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=900); output=r.stdout; code=r.returncode
except Exception as e: output=str(e); code=1
print(output)
with open(MEMORY/'jobs.jsonl','a') as f: f.write(json.dumps({'time':started.isoformat(),'task':task,'route':route,'exit_code':code},ensure_ascii=False)+'\n')
stamp=datetime.datetime.now().strftime('%Y%m%d-%H%M%S'); (LOGS/f'{stamp}-{route}.log').write_text(f'TASK:\n{task}\n\nOUTPUT:\n{output}',errors='ignore')
raise SystemExit(code)
PY
chmod +x "$RUNTIME/hermes_router.py"
cat > "$RUNTIME/hermes" <<'SH'
#!/usr/bin/env bash
exec python3 /opt/lucifer-agent/runtime/hermes_router.py "$@"
SH
chmod +x "$RUNTIME/hermes"
$SUDO ln -sf "$RUNTIME/hermes" /usr/local/bin/hermes

say "Installing Executor V1"
cat > "$RUNTIME/executor.py" <<'PY'
#!/usr/bin/env python3
import sys, subprocess, pathlib, datetime, json
ROOT=pathlib.Path('/opt/lucifer-agent'); WORK=ROOT/'workspace'; MEM=ROOT/'memory'; WORK.mkdir(parents=True,exist_ok=True); MEM.mkdir(parents=True,exist_ok=True)
task=' '.join(sys.argv[1:]).strip()
if not task: raise SystemExit('Dung: executor "nhiem vu"')
low=task.lower(); inspect=['trạng thái','hệ thống','workspace','kiểm tra máy','ram','gpu','ổ cứng','disk','status']
if any(x in low for x in inspect):
    facts=subprocess.check_output(['system-facts'],text=True)
    wrapped=f'''NHIEM VU: {task}\n\nSYSTEM_FACTS_JSON (nguon su that):\n{facts}\n\nChi duoc tom tat cac gia tri co trong JSON. Khong suy dien raw output. Ollama UNTIL la keep-alive truoc khi unload, khong phai han model.'''
else:
    wrapped=f'''{task}\n\nEXECUTOR RULE: Khong duoc tuyen bo da doc/sua/chay/kiem tra neu chua co bang chung tool thuc te.'''
r=subprocess.run(['hermes',wrapped],cwd=WORK,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=1200)
print(r.stdout)
with open(MEM/'executor.jsonl','a') as f: f.write(json.dumps({'time':datetime.datetime.now(datetime.timezone.utc).isoformat(),'task':task,'exit_code':r.returncode},ensure_ascii=False)+'\n')
raise SystemExit(r.returncode)
PY
chmod +x "$RUNTIME/executor.py"
$SUDO ln -sf "$RUNTIME/executor.py" /usr/local/bin/executor

say "Installing Telegram gateway"
cat > "$RUNTIME/telegram_gateway.py" <<'PY'
#!/usr/bin/env python3
import os,json,time,subprocess,urllib.request,urllib.parse
TOKEN=os.environ.get('TELEGRAM_BOT_TOKEN','').strip(); OWNER=os.environ.get('TELEGRAM_OWNER_ID','').strip()
if not TOKEN: raise SystemExit('Missing TELEGRAM_BOT_TOKEN')
BASE=f'https://api.telegram.org/bot{TOKEN}'
def api(method,data=None):
    body=urllib.parse.urlencode(data or {}).encode()
    with urllib.request.urlopen(f'{BASE}/{method}',data=body,timeout=70) as r: return json.loads(r.read().decode())
def send(chat,text):
    text=str(text) or '(empty)'
    for i in range(0,len(text),3800): api('sendMessage',{'chat_id':chat,'text':text[i:i+3800]})
def run(cmd,timeout=1200):
    try: return subprocess.run(cmd,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=timeout).stdout.strip()
    except subprocess.TimeoutExpired: return 'JOB_TIMEOUT'
    except Exception as e: return f'ERROR: {e}'
offset=0
while True:
    try:
        res=api('getUpdates',{'timeout':50,'offset':offset})
        for upd in res.get('result',[]):
            offset=upd['update_id']+1; msg=upd.get('message') or {}; text=(msg.get('text') or '').strip(); chat=msg.get('chat',{}).get('id'); uid=str(msg.get('from',{}).get('id',''))
            if not text or not chat: continue
            if text=='/whoami': send(chat,f'Telegram user ID: {uid}'); continue
            if not OWNER: send(chat,'Gateway chua khoa owner. Gui /whoami, sau do tren Agent chay: sudo telegram-owner <ID>'); continue
            if uid!=OWNER: continue
            if text=='/status': send(chat,run(['system-facts'],60)); continue
            if text=='/memory': send(chat,run(['memory','recent'],60) or 'Memory trong.'); continue
            if text.startswith('/remember '): send(chat,run(['memory','remember',text[len('/remember '):].strip()],60)); continue
            task=text[4:].strip() if text.startswith('/do ') else text
            send(chat,'[Hermes] Da nhan job, dang xu ly...')
            send(chat,run(['executor',task]))
    except Exception as e:
        print('telegram-loop:',e,flush=True); time.sleep(5)
PY
chmod +x "$RUNTIME/telegram_gateway.py"

cat > /tmp/lucifer-telegram.service <<EOF
[Unit]
Description=Lucifer Agent Telegram Gateway
After=network-online.target ollama.service tailscaled.service
Wants=network-online.target

[Service]
Type=simple
User=$AGENT_USER
Group=$AGENT_USER
Environment=HOME=$AGENT_HOME
Environment=PATH=$AGENT_HOME/.local/bin:/usr/local/bin:/usr/bin:/bin
EnvironmentFile=$ENV_DIR/telegram.env
WorkingDirectory=$WORKSPACE
ExecStart=/usr/bin/python3 $RUNTIME/telegram_gateway.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
$SUDO install -m 644 /tmp/lucifer-telegram.service /etc/systemd/system/lucifer-telegram.service
rm -f /tmp/lucifer-telegram.service

cat > /tmp/telegram-owner <<'SH'
#!/usr/bin/env bash
set -e
[[ $# -eq 1 ]] || { echo 'Usage: sudo telegram-owner <telegram_user_id>'; exit 1; }
ENV=/etc/lucifer-agent/telegram.env
[[ -f $ENV ]] || { echo 'telegram.env not found'; exit 1; }
if grep -q '^TELEGRAM_OWNER_ID=' "$ENV"; then sed -i "s/^TELEGRAM_OWNER_ID=.*/TELEGRAM_OWNER_ID=$1/" "$ENV"; else echo "TELEGRAM_OWNER_ID=$1" >> "$ENV"; fi
chmod 600 "$ENV"; systemctl restart lucifer-telegram; echo 'Owner locked and gateway restarted.'
SH
$SUDO install -m 755 /tmp/telegram-owner /usr/local/bin/telegram-owner
rm -f /tmp/telegram-owner

say "Installing health check"
cat > "$RUNTIME/health_check.py" <<'PY'
#!/usr/bin/env python3
import json,subprocess,datetime,pathlib
out={'time':datetime.datetime.now(datetime.timezone.utc).isoformat()}
for name,cmd in {'facts':['system-facts'],'tailscale':['tailscale','status'],'ollama':['systemctl','is-active','ollama'],'telegram':['systemctl','is-active','lucifer-telegram']}.items():
    try: out[name]=subprocess.check_output(cmd,text=True,stderr=subprocess.STDOUT,timeout=20).strip()
    except Exception as e: out[name]=f'ERROR: {e}'
p=pathlib.Path('/opt/lucifer-agent/logs/health.json'); p.write_text(json.dumps(out,ensure_ascii=False,indent=2)); print(json.dumps(out,ensure_ascii=False,indent=2))
PY
chmod +x "$RUNTIME/health_check.py"
$SUDO ln -sf "$RUNTIME/health_check.py" /usr/local/bin/agent-health

cat > /tmp/lucifer-health.service <<EOF
[Unit]
Description=Lucifer Agent Health Check
[Service]
Type=oneshot
User=$AGENT_USER
Environment=HOME=$AGENT_HOME
Environment=PATH=$AGENT_HOME/.local/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=/usr/bin/python3 $RUNTIME/health_check.py
EOF
cat > /tmp/lucifer-health.timer <<'EOF'
[Unit]
Description=Run Lucifer health check every 5 minutes
[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
Persistent=true
[Install]
WantedBy=timers.target
EOF
$SUDO install -m 644 /tmp/lucifer-health.service /etc/systemd/system/lucifer-health.service
$SUDO install -m 644 /tmp/lucifer-health.timer /etc/systemd/system/lucifer-health.timer
rm -f /tmp/lucifer-health.service /tmp/lucifer-health.timer

say "Configuring 24/7 laptop/server behavior"
$SUDO mkdir -p /etc/systemd/logind.conf.d
cat > /tmp/lucifer-agent.conf <<'EOF'
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
IdleAction=ignore
EOF
$SUDO install -m 644 /tmp/lucifer-agent.conf /etc/systemd/logind.conf.d/lucifer-agent.conf
rm -f /tmp/lucifer-agent.conf
$SUDO systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target >/dev/null 2>&1 || true

say "Installing browser worker dependencies"
if command -v npm >/dev/null 2>&1; then
  mkdir -p "$BROWSER"
  if [[ ! -f "$BROWSER/package.json" ]]; then (cd "$BROWSER" && npm init -y >/dev/null 2>&1); fi
  (cd "$BROWSER" && npm install playwright >/dev/null 2>&1) || warn "Playwright npm install failed"
  (cd "$BROWSER" && npx playwright install chromium) || warn "Chromium download failed; rerun later: cd $BROWSER && npx playwright install chromium"
else
  warn "npm not found; browser worker skipped"
fi

say "Checking video/GPU encode"
ffmpeg -hide_banner -encoders 2>/dev/null | grep -E 'nvenc|h264_nvenc|hevc_nvenc' || warn "NVENC encoder not listed by current ffmpeg build"

say "Compiling runtime"
python3 -m py_compile "$RUNTIME/system_facts.py" "$RUNTIME/memory.py" "$RUNTIME/hermes_router.py" "$RUNTIME/executor.py" "$RUNTIME/telegram_gateway.py" "$RUNTIME/health_check.py"

$SUDO systemctl daemon-reload
$SUDO systemctl enable --now lucifer-health.timer

# Telegram secret is entered locally on the Agent; never commit it.
if [[ -t 0 ]]; then
  printf '\nTelegram setup (token is entered locally and stored root-only).\n'
  read -rsp 'TELEGRAM_BOT_TOKEN (Enter to skip): ' TG_TOKEN || true
  echo
  if [[ -n "${TG_TOKEN:-}" ]]; then
    read -rp 'TELEGRAM_OWNER_ID (Enter if unknown; use /whoami later): ' TG_OWNER || true
    umask 077
    printf 'TELEGRAM_BOT_TOKEN=%s\nTELEGRAM_OWNER_ID=%s\n' "$TG_TOKEN" "${TG_OWNER:-}" | $SUDO tee "$ENV_DIR/telegram.env" >/dev/null
    $SUDO chmod 600 "$ENV_DIR/telegram.env"
    $SUDO systemctl enable --now lucifer-telegram
  else
    warn "Telegram skipped. Later create $ENV_DIR/telegram.env and enable lucifer-telegram."
  fi
fi

say "Final checks"
echo "User: $AGENT_USER"
echo "Brain branch: $(git -C "$BRAIN" branch --show-current 2>/dev/null || echo unknown)"
echo "Ollama models:"; ollama list 2>/dev/null || true
echo "Claude: $(claude --version 2>/dev/null || echo unavailable)"
echo "Codex: $(codex --version 2>/dev/null || echo unavailable)"
echo "Gemini: $(gemini --version 2>/dev/null || echo unavailable/auth-pending)"
echo "Tailscale:"; tailscale ip -4 2>/dev/null || true
echo "GPU:"; nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader 2>/dev/null || true
system-facts || true

say "Lucifer Agent V1 bootstrap complete"
echo "Useful commands:"
echo "  system-facts"
echo "  agent-health"
echo "  memory recent"
echo "  hermes \"task\""
echo "  executor \"task\""
echo "  systemctl status lucifer-telegram --no-pager"
echo "  journalctl -u lucifer-telegram -f"
echo
warn "Docker group membership and lid/sleep policy are safest after one reboot. Reboot only when you are ready."
