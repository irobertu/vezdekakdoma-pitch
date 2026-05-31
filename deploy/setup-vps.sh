#!/bin/bash
# Одноразовая настройка VPS под pitch.vezdekakdoma.ru
# Запустить на VPS под root:
#   bash setup-vps.sh

set -e

DOMAIN="pitch.vezdekakdoma.ru"
WEBROOT="/var/www/pitch-vkd"

echo "=== 1. Создаём webroot ==="
mkdir -p $WEBROOT
chown -R www-data:www-data $WEBROOT
chmod 755 $WEBROOT

echo "=== 2. Кладём временную index.html (для certbot challenge) ==="
cat > $WEBROOT/index.html <<'EOF'
<!doctype html><html><head><meta charset="utf-8"><title>VKD Pitch</title></head>
<body><h1>Деплой в процессе. Скоро здесь будет pitch.</h1></body></html>
EOF

echo "=== 3. Копируем nginx config ==="
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"
# временный config без SSL (для certbot)
cat > $NGINX_CONF <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN;
    root $WEBROOT;
    index index.html;
    location / { try_files \$uri \$uri/ /index.html; }
}
EOF

ln -sf $NGINX_CONF /etc/nginx/sites-enabled/$DOMAIN
nginx -t && systemctl reload nginx

echo "=== 4. Получаем SSL via certbot ==="
echo "Убедитесь, что DNS A-запись $DOMAIN → IP VPS уже добавлена и распространилась (dig $DOMAIN)"
read -p "DNS готов? (y/N): " ready
if [ "$ready" != "y" ]; then
    echo "Прерываем. Сначала настройте DNS, потом запустите этот скрипт снова."
    exit 1
fi

certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m r.usmanov@zbsk.ru --redirect

echo "=== 5. Финальный nginx config с SSL ==="
echo "Теперь скопируйте deploy/nginx.conf в $NGINX_CONF и перезагрузите:"
echo "  cp deploy/nginx.conf $NGINX_CONF"
echo "  nginx -t && systemctl reload nginx"

echo "=== DONE ==="
echo "Сайт: https://$DOMAIN/"
echo "Дальнейшие деплои — push в main → GH Actions обновит $WEBROOT"
