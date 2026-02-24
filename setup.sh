#!/bin/bash
# ============================================================
#  setup.sh — Khởi động n8n stack từ đầu
#  chmod +x setup.sh && ./setup.sh
# ============================================================

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}"
echo "  ███╗   ██╗ █████╗ ███╗  ██╗"
echo "  ████╗  ██║██╔══██╗████╗ ██║"
echo "  ██╔██╗ ██║╚█████╔╝██╔██╗██║"
echo "  ██║╚██╗██║██╔══██╗██║╚████║"
echo "  ██║ ╚████║╚█████╔╝██║ ╚███║"
echo "  ╚═╝  ╚═══╝ ╚════╝ ╚═╝  ╚══╝"
echo -e "${NC}  luanluan.tech assistant stack\n"

# ── 1. Check .env ──────────────────────────────────────────
if [ ! -f ".env" ]; then
  echo -e "${YELLOW}[!] Chưa có .env — copy từ .env.example...${NC}"
  cp .env.example .env
  echo -e "${RED}[!] Vui lòng điền đầy đủ thông tin trong .env rồi chạy lại!${NC}"
  echo -e "    ${CYAN}nano .env${NC}"
  exit 1
fi

# ── 2. Check required vars ────────────────────────────────
source .env
MISSING=0
for VAR in N8N_ENCRYPTION_KEY; do
  if [ -z "${!VAR}" ] || [[ "${!VAR}" == CHANGE_ME* ]]; then
    echo -e "${RED}[✗] $VAR chưa được set trong .env${NC}"
    MISSING=1
  fi
done

if [ $MISSING -eq 1 ]; then
  echo -e "\n${YELLOW}Generate N8N_ENCRYPTION_KEY:${NC}"
  echo -e "  ${CYAN}openssl rand -hex 32${NC}"
  echo -e "  Paste kết quả vào .env"
  exit 1
fi

echo -e "${GREEN}[✓] .env hợp lệ${NC}"

# ── 3. Check Docker ───────────────────────────────────────
if ! command -v docker &> /dev/null; then
  echo -e "${RED}[✗] Docker chưa cài. Cài tại: https://docs.docker.com/get-docker/${NC}"
  exit 1
fi

if ! docker compose version &> /dev/null; then
  echo -e "${RED}[✗] Docker Compose v2 chưa cài${NC}"
  exit 1
fi

echo -e "${GREEN}[✓] Docker OK${NC}"

# ── 4. Pull images ────────────────────────────────────────
echo -e "\n${CYAN}[→] Pulling images...${NC}"
docker compose pull

# ── 5. Start stack ────────────────────────────────────────
echo -e "\n${CYAN}[→] Starting stack...${NC}"
if [ "${N8N_PROTOCOL}" = "https" ]; then
  docker compose --profile https up -d
else
  docker compose up -d
fi

# ── 6. Wait for n8n ──────────────────────────────────────
echo -ne "\n${CYAN}[→] Chờ n8n khởi động"
READY=0
for i in {1..30}; do
  if curl -sf http://localhost:5678/healthz > /dev/null 2>&1; then
    echo -e " ${GREEN}✓${NC}"
    READY=1
    break
  fi
  echo -n "."
  sleep 2
done
if [ $READY -eq 0 ]; then
  echo -e "\n${RED}[✗] n8n chưa sẵn sàng sau 60s. Kiểm tra logs:${NC}"
  echo -e "  ${CYAN}docker compose logs n8n${NC}"
  exit 1
fi

# ── 7. Done ───────────────────────────────────────────────
echo -e "\n${GREEN}╔════════════════════════════════════════╗"
echo "║  🚀  n8n Stack đã chạy thành công!     ║"
echo "╚════════════════════════════════════════╝${NC}"
echo ""
if [ "${N8N_PROTOCOL}" = "https" ]; then
  echo -e "  📍 n8n UI:    ${CYAN}https://${N8N_HOST}${NC}"
else
  echo -e "  📍 n8n UI:    ${CYAN}http://localhost:5678${NC}"
fi
echo -e "  👤 Login:     ${CYAN}Tạo owner account lần đầu trên trình duyệt${NC}"
echo ""
echo -e "  ${YELLOW}Bước tiếp theo:${NC}"
echo -e "  1. Mở n8n → Settings → Credentials"
echo -e "  2. Thêm: Telegram API, Gmail, OpenAI/Anthropic"
echo -e "  3. Import workflow: luanluan-assistant.json"
echo -e "  4. Activate workflow → Done! 🎉"
echo ""
echo -e "  ${CYAN}Logs:${NC} docker compose logs -f n8n"
echo -e "  ${CYAN}Stop:${NC} docker compose down"
echo ""
