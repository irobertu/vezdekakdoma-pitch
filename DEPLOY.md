# DEPLOY · pitch.vezdekakdoma.ru

## Статус

| Шаг | Статус |
|---|---|
| GitHub репо `irobertu/vezdekakdoma-pitch` (private) | ✅ создан |
| GitHub Secrets (`VPS_HOST`, `VPS_USER`, `VPS_SSH_KEY`) | ✅ установлены |
| Файлы залиты на VPS `/var/www/pitch-vkd/` (1.85 МБ) | ✅ через GH Actions |
| nginx server-block для `pitch.vezdekakdoma.ru:80` | ✅ установлен |
| Проверка: HTTP 200 при curl с Host header | ✅ |
| **DNS A-запись `pitch.vezdekakdoma.ru → 92.51.39.180`** | ⏳ **осталось сделать вручную** |
| SSL via certbot (требует DNS) | ⏳ после DNS |

## Один оставшийся шаг — DNS

Зайти в **TimeWeb → Домены → vezdekakdoma.ru → DNS-записи** и добавить:

| Тип | Имя | Значение | TTL |
|---|---|---|---|
| `A` | `pitch` | `92.51.39.180` | 600 |

Проверить через 5–15 минут:
```bash
dig +short pitch.vezdekakdoma.ru @8.8.8.8
# должно вернуть 92.51.39.180
```

## После того как DNS заработал

Одна команда — она поставит SSL и переключит сайт на HTTPS:

```bash
gh workflow run setup-vps.yml -f run_certbot=true --repo irobertu/vezdekakdoma-pitch
```

Через 1–2 минуты сайт доступен по **https://pitch.vezdekakdoma.ru/**

## Обновления деки

Каждая правка → `git push` → GitHub Actions автоматически задеплоит на VPS:

```bash
cd ~/Downloads/vezde_kak_doma_pitch_v2
git add pitch_v2.html
git commit -m "что изменилось"
git push
```

Статус деплоя: https://github.com/irobertu/vezdekakdoma-pitch/actions

## Опционально

### Яндекс.Метрика
1. https://metrika.yandex.ru → создать счётчик `pitch.vezdekakdoma.ru` + Webvisor 2.0
2. Скопировать counter ID
3. `gh secret set YM_COUNTER_ID --body "12345678" --repo irobertu/vezdekakdoma-pitch`
4. Следующий push автоматически встроит код Метрики

### OG-превью для соцсетей
Сейчас в `assets/og/cover.png` лежит заглушка из иллюстрации. Чтобы сделать красивое превью для Telegram/WhatsApp:
1. Открыть `pitch_v2.html` в Chrome, выставить размер окна `1200×630`
2. Сделать screenshot первого слайда (Cover)
3. Сохранить как `assets/og/cover.png`
4. `git add assets/og/cover.png && git commit -m "OG preview" && git push`

## Что под капотом

```
pitch_v2.html                         ← главный файл, при деплое = index.html
assets/                               ← шрифты, лого, иконки, иллюстрации, города
.github/workflows/deploy.yml          ← авто-деплой на push в main
.github/workflows/setup-vps.yml       ← разовая настройка nginx + SSL
deploy/nginx.conf                     ← финальный nginx config с SSL
deploy/setup-vps.sh                   ← legacy bash-скрипт (не нужен, всё через GH Actions)
04_FINANCIALS_SOURCES.md              ← обоснование цифр (НЕ деплоится)
```

## Откат

- Откат коммита: `git revert HEAD && git push`
- Полный rollback: `git reset --hard <sha> && git push -f`
