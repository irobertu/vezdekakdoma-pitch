# DEPLOY · pitch.vezdekakdoma.ru

Финальная ссылка для инвесторов: **https://pitch.vezdekakdoma.ru/**

## Что нужно сделать (один раз)

### 1. DNS — добавь A-запись (5 мин)
Зайди в **панель TimeWeb → Домены → vezdekakdoma.ru → DNS** и добавь:

| Тип | Имя | Значение | TTL |
|---|---|---|---|
| A | `pitch` | `92.51.39.180` *(IP твоего VPS)* | 600 |

Проверь через 5–15 минут:
```bash
dig pitch.vezdekakdoma.ru +short
# должно вернуть 92.51.39.180
```

### 2. Создай репо на GitHub (3 мин)

```bash
cd ~/Downloads/vezde_kak_doma_pitch_v2
git init
git add .
git commit -m "Initial pitch v2 — Везде как дома"
gh repo create irobertu/vezdekakdoma-pitch --private --source=. --remote=origin --push
```

### 3. Добавь GitHub Secrets (3 мин)

В репо **Settings → Secrets and variables → Actions → New repository secret**:

| Secret | Значение |
|---|---|
| `VPS_HOST` | `92.51.39.180` |
| `VPS_USER` | `root` |
| `VPS_SSH_KEY` | Приватный SSH-ключ (тот же что для rassylka/moyamolodost деплоя) |
| `YM_COUNTER_ID` | (опционально) Counter ID Яндекс.Метрики — например `12345678` |

> Если `YM_COUNTER_ID` не задан — Метрика просто не вставится, deck работает без неё.

### 4. Настрой VPS (10 мин)

Через GH Actions нельзя выполнить **первоначальную** настройку nginx + SSL. Это разовая операция через TimeWeb web-SSH (твой обычный SSH забанен):

```bash
# скопируй setup-vps.sh и deploy/nginx.conf на VPS
scp deploy/setup-vps.sh root@92.51.39.180:/tmp/  # либо через TimeWeb web-shell
scp deploy/nginx.conf root@92.51.39.180:/tmp/

# на VPS:
bash /tmp/setup-vps.sh           # создаёт webroot, временный nginx, certbot SSL
cp /tmp/nginx.conf /etc/nginx/sites-available/pitch.vezdekakdoma.ru
nginx -t && systemctl reload nginx
```

После этого VPS готов принимать деплои.

### 5. Получи Яндекс.Метрику counter (опционально, 5 мин)

1. https://metrika.yandex.ru → создать счётчик
2. Domain: `pitch.vezdekakdoma.ru`
3. Включить Webvisor 2.0 + Карта кликов
4. Скопировать **counter ID** (например `98765432`)
5. Положить в GH Secret `YM_COUNTER_ID`

## После настройки — каждый деплой

```bash
cd ~/Downloads/vezde_kak_doma_pitch_v2
# вношу правки в pitch_v2.html
git add pitch_v2.html
git commit -m "правка: что изменилось"
git push
# GH Actions автоматически задеплоит за ~30 сек
```

Ссылка на статус деплоев: `https://github.com/irobertu/vezdekakdoma-pitch/actions`

## OG-превью для соцсетей

Сейчас в `assets/og/cover.png` лежит заглушка (illust-1.png). Чтобы сделать красивое превью для Telegram/WhatsApp/email:

1. Открой pitch в Chrome
2. DevTools → Device Toolbar (Cmd+Shift+M) → задай размер **1200×630**
3. Сделай скриншот s1 (Cover)
4. Сохрани в `assets/og/cover.png`
5. `git add assets/og/cover.png && git commit -m "OG preview" && git push`

Проверь как выглядит ссылка:
- Telegram: https://t.me/iv?url=https://pitch.vezdekakdoma.ru/
- Facebook: https://developers.facebook.com/tools/debug/

## Файлы

```
~/Downloads/vezde_kak_doma_pitch_v2/
├── pitch_v2.html             ← главный файл, в деплое = index.html
├── 04_FINANCIALS_SOURCES.md  ← обоснование цифр (НЕ деплоится, для тебя)
├── assets/
│   ├── fonts/, logo/, icons/, illustrations/, cities/
│   └── og/cover.png          ← превью для shared link
├── .github/workflows/
│   └── deploy.yml            ← автодеплой на push в main
└── deploy/
    ├── nginx.conf            ← конфиг для /etc/nginx/sites-available/
    └── setup-vps.sh          ← разовая инициализация VPS
```

## Откат / правки

- Любая правка в `pitch_v2.html` → `git push` → автодеплой
- Откат на предыдущую версию: `git revert HEAD && git push`
- Полный rollback: `git reset --hard <commit-sha> && git push -f` (осторожно)
- Если что-то сломалось в nginx — откат конфига вручную через TimeWeb web-shell

## Мобильная версия

Полностью адаптирована под iPhone (≤900px и ≤380px breakpoints). Тестируется в DevTools → Device Mode (Cmd+Shift+M) на iPhone 13/14 (390px).

## PDF-экспорт

Кнопка «Скачать PDF» в правом нижнем углу деки → открывает Chrome print dialog → «Сохранить как PDF». Печатные стили оптимизированы (без nav, без shadow, каждый слайд = страница A4).
