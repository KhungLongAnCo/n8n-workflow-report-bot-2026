docker stop n8n

docker run -d -it --rm --name n8n -p 5678:5678 \
  -e GENERIC_TIMEZONE="Asia/Ho_Chi_Minh" \
  -e TZ="Asia/Ho_Chi_Minh" \
  -e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
  -e N8N_HOST="n8n.luyenviet.io" \
  -e N8N_PORT="5678" \
  -e N8N_PROTOCOL="https" \
  -e WEBHOOK_URL="https://n8n.luyenviet.io/" \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n