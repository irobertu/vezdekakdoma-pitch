# DEPLOY · vezdekakdoma-pitch

## Хостинг

Презентация хостится на **GitHub Pages**:
- **URL:** https://irobertu.github.io/vezdekakdoma-pitch/
- **Репо:** https://github.com/irobertu/vezdekakdoma-pitch (private)
- **Деплой:** автоматически при push в `main` через `.github/workflows/deploy.yml`

## Как обновить контент

```bash
cd ~/Downloads/vezde_kak_doma_pitch_v2
# редактируем pitch_v2.html
git add pitch_v2.html
git commit -m "..."
git push
# GH Actions автоматически:
# 1) cp pitch_v2.html → _site/index.html
# 2) (опционально) подставит Я.Метрика по секрету YM_COUNTER_ID
# 3) выкатит на GitHub Pages
# через 30-60 сек https://irobertu.github.io/vezdekakdoma-pitch/ обновится
```

## Опциональные секреты

| Secret | Назначение |
|---|---|
| `YM_COUNTER_ID` | ID счётчика Я.Метрики (если задан — подставляется в `<head>` при деплое) |

Установить: `gh secret set YM_COUNTER_ID -b "12345678" --repo irobertu/vezdekakdoma-pitch`

## Что отдаётся

| Путь | Файл |
|---|---|
| `/` | `pitch_v2.html` → `index.html` (главная) |
| `/assets/...` | вся папка `assets/` (шрифты, лого, иконки, иллюстрации, скрины городов) |
| `/404.html` | тот же `pitch_v2.html` (любой не-existing путь покажет дек) |

## История

Раньше хостился на TimeWeb VPS (`pitch.vezdekakdoma.ru`). **Перенесён на GitHub Pages 2026-05-31** — после этого VPS-инфра очищена workflow'ом `cleanup-vps.yml` (одноразовый, потом удалён).
