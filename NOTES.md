# NOTES — портфолио-сайт TEIVRIM

## Что за проект и где он

Пользователь просил «сайт-портфолио в репозитории teivrimOriginal».
GitHub-аккаунт = `TeivrimOriginal` (проверено по git remote).

| Кандидат | Что это | Вердикт |
|---|---|---|
| `D:\SOOBSHESTVA\Teivrim_ULTIMATE_SITE\v1` (`TeivrimOriginal/TeivrimSite`) | anime-база на Rust + 2 html | **не портфолио** |
| `D:\SOOBSHESTVA\PRODUCT\TDEvuris` | AV-сканеры на C++ | не портфолио |
| `D:\SOOBSHESTVA\AUTOMATIC\Many\service` → **teivrim.github.io** | витрина услуг + раздел «Портфолио» | **ЭТО ОНО** |

Подтверждение: `Many\profile\README.md:9` и `:129` — бейдж
`teivrim.github.io` с подписью «услуги и портфолио».
Репозиторий `Many` без remote, генерируется вручную.

## Ключевой факт: сайт генерируется

`service/index.html` и `service/proof.html` **не редактировать руками** —
их перезаписывает `python tooling/offer.py`.
Правки вносить в `tooling/offer.py`:
- `SERVICES` (список услуг) ~стр. 53
- `CSS` ~стр. 383
- `build_page()` ~стр. 449
- `build_proof_page()` ~стр. 588
- `main()` ~стр. 649 (список `extra` — robots/sitemap/.nojekyll)

## Проверенные факты для текста (не выдумывать)

Данные брались запуском реального кода, не из README.

**Анализ данных** — `Many`-соседний `D:\SOOBSHESTVA\AUTOMATIC\NeiroHub`,
вывод `target\release\neurohub.exe summary` (FlyWire FAFB v783):
- 139 255 нейронов
- 3 869 878 строк связей
- 34 153 566 синапсов
- 9 csv.gz → `neurohub.sqlite` 564 МБ
- Dorkenwald et al., Nature (2024), doi:10.1038/s41586-024-07558-y

**Автотестирование** — `D:\SOOBSHESTVA\AUTOMATIC\UnityGame\SimpleFPS\Source\SimpleFPS\Tests`,
подсчёт `IMPLEMENT_*_AUTOMATION_TEST` по 12 .cpp:
- **55 автотестов** (Character 7, Combat 8, Control 4, Gameplay 12,
  InputDiagnostics 1, Interaction 4, Inventory 7, Retarget 3,
  RigReport 1, Save 3, Stamina 4, WeaponKind 1)
- CI: `Many\ci\*.yml` — 6 workflow (FlyTest, NovellEngine, PolygonEditor,
  rust-course, TDEvuris, YandexGame)

**Системное программирование**:
- TDEvuris: 13 бинарников, чистый Win32, 0 зависимостей, 3 253 строки
- rust-course: 14 912 строк, 0 зависимостей, `unsafe_code = "deny"`
- NovellEngine: 3 319 строк, 0 зависимостей
- PolygonEditor: 3 801 строка, 4 зависимости

**Проекты/цифры** — из `catalog\products.json` (источник правды для таблиц).

## Образование

УРТК / НИЯУ МИФИ в сайте **отсутствует** (проверено rg по service/ и
storefront/). Задача: не дать ему всплыть в hero/описание.
Решение: одна строка, приглушённая, в самом низу резюме.

## Найденные баги (попутно, чинить)

1. `offer.py:466` — `if pr["loc"] else "%d проекта в сторе" % pr["files"]`.
   У FlyTest `loc=0, files=12` → на сайт попадает «FlyTest … 12 проекта
   в сторе». FlyTest ни в каком сторе не находится. Фактическая ошибка.
2. Русская declined не согласована: «3 801 строк», «3 253 строк»,
   «12 проекта» — надо `plural_ru()`.
3. `offer.py:89` в услуге: «Показать код: … Исходники закрыты пока
   готовлю релиз» — для трёх продуктов без URL.

## Что сделано в этом цикле

- [x] Найти проект, подтвердить генератор
- [x] Снять реальные цифры (запуск neurohub, подсчёт автотестов)
- [x] NOTES.md
- [x] offer.py: `num`/`plural_ru`/`loc_ru`, блоки EXPERIENCE и RESUME
- [x] offer.py: de-AI текст (hero, «Как работаю», услуги, proof)
- [x] offer.py: секция «Чем занимаюсь» + полоса скачивания + `resume.html`
- [x] offer.py: баг «12 проекта в сторе» у FlyTest починен (`measure`)
- [x] offer.py: «строк» → «строка/строки» через `plural_ru`
- [x] tooling/resume_pdf.py — PDF через headless Chrome
- [x] Резюме влезло в одну страницу A4 (заполнение 91 %)
- [x] Проверено: 0 битых внутренних ссылок, нет горизонтального скролла,
      УРТК/МИФИ только в подвале resume.html
- [x] profile/README.md — то же позиционирование, бейдж на резюме
- [x] distribute/RESUME.md — текст под hh.ru синхронизирован
- [x] resume_pdf.py — воспроизводимая сборка (2 байта даты Chrome)

### Как проверить

```powershell
cd D:\SOOBSHESTVA\AUTOMATIC\Many
python tooling\offer.py        # собрать HTML
python tooling\resume_pdf.py   # собрать PDF (сам проверит число страниц)
python -m http.server 8099 --directory service
```

`resume_pdf.py` сам ругается, если PDF не на одну страницу.

### PDF воспроизводим

Chrome пишет в PDF текущее время, из-за чего пересборка давала «изменённый»
файл в git. `resume_pdf.py` подменяет `/CreationDate` и `/ModDate` на
фиксированную метку — длина сохраняется, xref не едет. Переопределяется
через `RESUME_PDF_DATE=YYYYMMDDHHMMSS`.

Проверено: две сборки с интервалом 10 с дают одинаковый SHA-256;
`startxref` указывает на `xref`, все 162 смещения объектов резолвятся.

Текст в PDF не ищется грепом по-русски: Chrome сабсетит шрифты и кодирует
глифы своими кодами. Это норма, а не признак битого файла. Проверять
структуру, а не содержимое.

### Замеры de-AI

| | было | стало |
|---|---:|---:|
| тире «—» на 1000 символов, index.html | 1.27 | 0.99 |
| тире «—» на 1000 символов, proof.html | 0.38 | 0.24 |
| тире «—» на 1000 символов, profile/README.md | 2.42 | 2.02 |
| объём текста index.html | 15 001 | 20 167 |

Плотность тире упала, хотя текст вырос на 34 % — это и был признак
машинной сборки. Плюс убраны 22 % маркетинговых слов
(«уникальный», «эффективный», «масштабируемый» и т. п.), их в файлах нет.
Оставшиеся тире — в заголовках `### Название — пояснение`, там это норма.

### Что было исправлено по факту

- FlyTest показывался как «12 проекта в сторе»: у него `loc=0`, и старая
  формула подставляла `files`. Теперь у каждого доказательства своё поле
  `measure`.
- Склонение: было «3 801 строк», «3 253 строк», «14 файлах» на любое
  число. Добавлены `num` / `plural_ru` / `loc_ru`.
- «Не «дизайнер с премиумом», не « универсал»» — риторическая фигура и
  опечатка с лишним пробелом, заменены на конкретику.

## Что дальше

1. `Many\tooling\offer.py`: в `GIGS` нет гигов для `ai-systems`, `games`,
   `rev-legacy` — 4 из 7 услуг без текста для биржи.
2. `storefront\*.html` — витрина товаров, тексты не трогал.
3. Задеплоить: `service/` едет в репозиторий сайта, PDF теперь
   воспроизводим, можно коммитить смело.
4. Тексты услуг в `offer.py` и в `service/gigs/*.txt` разошлись: гиги
   старые, в них ещё «геймплей и AI» без данных и тестов. Стоит
   перегенерировать после правки словаря `GIGS`.
5. `distribute/POSTS.md` — посты для рассылки, тоже на старом
   позиционировании.

## Где что лежит (итого)

| Файл | Роль | Генерируется? |
|---|---|---|
| `Many/tooling/offer.py` | генератор сайта, все тексты | — |
| `Many/tooling/resume_pdf.py` | `resume.html` → PDF | — |
| `Many/service/index.html` | главная | да, `offer.py` |
| `Many/service/proof.html` | портфолио | да, `offer.py` |
| `Many/service/resume.html` | резюме | да, `offer.py` |
| `Many/service/teivrim-resume.pdf` | резюме в PDF | да, `resume_pdf.py` |
| `Many/profile/README.md` | профиль GitHub | нет, руками |
| `Many/distribute/RESUME.md` | текст под hh.ru | нет, руками |

Правки в `service/*.html` руками перетрутся следующим прогоном
`offer.py`. Править нужно `tooling/offer.py`.




## Среда

- Chrome: `C:\Program Files\Google\Chrome\Application\chrome.exe` (для PDF)
- Python: `C:\Users\teivrim\AppData\Local\Programs\Python\Python314\python.exe`
- Локальный просмотр: `python -m http.server 8080 --directory service`
