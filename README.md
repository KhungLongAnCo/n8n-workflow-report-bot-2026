# n8n Assistant Stack

Personal automation: email summary + Telegram bot + site monitor.

## Stack

| Service | Image | Role |
|---------|-------|------|
| n8n | `n8nio/n8n:latest` | Workflow engine (SQLite built-in) |
| Caddy 2 | `caddy:2-alpine` | HTTPS reverse proxy (optional) |

---

## Run locally

```bash
# 1. Set encryption key
openssl rand -hex 32   # copy output into .env

# 2. Edit .env
nano .env

# 3. Start
chmod +x setup.sh && ./setup.sh
```

Open **http://localhost:5678** → create your owner account on first visit.

---

## .env reference

### Required

```bash
N8N_ENCRYPTION_KEY=   # openssl rand -hex 32
```

### Optional (fill in to use the workflow)

```bash
# Telegram
TELEGRAM_BOT_TOKEN=   # from @BotFather
TELEGRAM_CHAT_ID=     # from api.telegram.org/bot<TOKEN>/getUpdates

# AI (pick one or both)
OPENAI_API_KEY=
ANTHROPIC_API_KEY=

# Gmail App Password
GMAIL_USER=
GMAIL_APP_PASSWORD=

# Site to monitor
MONITOR_URL=
```

### Get Telegram credentials

1. Chat with **@BotFather** → `/newbot` → copy token to `TELEGRAM_BOT_TOKEN`
2. Send `/start` to your bot
3. Open `https://api.telegram.org/bot<TOKEN>/getUpdates` → copy `chat.id` to `TELEGRAM_CHAT_ID`

### Get Gmail App Password

1. Enable 2FA at myaccount.google.com
2. Go to **Security → App Passwords** → create one for "Mail"
3. Fill in `GMAIL_USER` and `GMAIL_APP_PASSWORD`

---

## Import workflow

1. Open n8n → **Settings → Credentials** → add Telegram, Gmail, OpenAI/Anthropic
2. **Workflows → Import** → select `luanluan-assistant.json`
3. Activate → done

---

## Common commands

```bash
# Logs
docker compose logs -f n8n

# Restart
docker compose restart n8n

# Stop
docker compose down

# Stop + delete all data
docker compose down -v

# Update n8n
docker compose pull && docker compose up -d
```

---

## Deploy to VPS (HTTPS)

1. Point your domain to the VPS IP
2. Update `.env`:
   ```bash
   N8N_HOST=n8n.yourdomain.com
   N8N_PROTOCOL=https
   WEBHOOK_URL=https://n8n.yourdomain.com/
   ```
3. Update `Caddyfile` with your domain
4. Start with Caddy:
   ```bash
   docker compose --profile https up -d
   ```

Caddy auto-provisions SSL from Let's Encrypt.

---

## What the workflow does

**Daily at 08:00 (GMT+7):**
1. Reads unread Gmail from the past 24h
2. AI classifies each email: needs reply / ads / FYI / spam
3. Pings the monitored site
4. Sends a summary report to Telegram

**Telegram commands:**

| Command | Action |
|---------|--------|
| `/report` | Run report immediately |
| `/check` | Ping monitored site |
| `/emails` | Show latest inbox |
| `/help` | List commands |
