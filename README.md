# Teivrim Sound Studio (TS Studio)

Мобильная музыкальная студия для Android, построенная на Flutter.

## Функционал

- **Step Sequencer** — сетка 16 шагов для создания битов и мелодий
- **8 треков** — Kick, Snare, Hi-Hat, Bass, Synth, Pad, Lead, Pluck
- **Реальные сэмплы** — синтезированные WAV-сэмплы для каждого инструмента
- **Управление воспроизведением** — Play/Pause/Stop
- **Настройка BPM** — от 60 до 200 BPM
- **Mute треков** — отключение отдельных дорожек
- **Громкость треков** — индивидуальная громкость каждого трека
- **Панорама треков** — настройка панорамы
- **Master Volume** — общая громкость
- **Эквалайзер** — 3-полосный EQ (Low, Mid, High)
- **Эффекты** — Reverb, Delay (mix и time), Distortion, Chorus, Filter
- **Запись с микрофона** — запись аудио в проект
- **Сохранение проектов** — сохранение и загрузка проектов
- **Экспорт WAV** — экспорт проекта в WAV файл
- **Очистка** — сброс всех шагов
- **Undo/Redo** — история изменений
- **Пресеты** — готовые паттерны для быстрого старта
- **Паттерны** — создание и сохранение собственных паттернов
- **Визуализация волны** — отображение аудио волны
- **Микшер** — полноценный микшер с каналами
- **Рандомайзер** — генерация случайных паттернов
- **LFO** — модуляция параметров
- **Параметрический фильтр** — срез и резонанс

## Технологии

- Flutter (Dart)
- Flutter Riverpod — управление состоянием
- Audioplayers — воспроизведение звука
- Record — запись с микрофона
- Path Provider — файловая система
- Permission Handler — разрешения

## Установка и запуск

```bash
# Клонировать репозиторий
git clone https://github.com/Teivrim/TS-Studio.git

# Перейти в папку проекта
cd TS-Studio

# Установить зависимости
flutter pub get

# Запустить на устройстве/эмуляторе
flutter run
```

## Структура проекта

```
lib/
├── main.dart                 # Точка входа
├── screens/
│   └── sequencer_screen.dart # Главный экран с секвенсором
├── widgets/
│   ├── step_sequencer.dart   # Виджет сетки секвенсора
│   ├── track_header.dart     # Заголовок трека
│   ├── transport_controls.dart # Кнопки управления
│   ├── effects_panel.dart    # Панель эффектов
│   ├── project_dialog.dart   # Диалог сохранения
│   ├── pattern_dialog.dart   # Диалог паттернов
│   ├── preset_dialog.dart    # Диалог пресетов
│   ├── mixer_screen.dart     # Экран микшера
│   ├── randomizer_dialog.dart # Диалог рандомайзера
│   └── waveform_widget.dart  # Визуализация волны
├── models/
│   ├── track.dart            # Модели данных
│   ├── pattern.dart          # Модели паттернов
│   └── mixer_channel.dart    # Модели микшера
├── services/
│   ├── audio_service.dart    # Аудио-сервис
│   ├── project_service.dart  # Сервис проектов
│   ├── export_service.dart   # Сервис экспорта
│   ├── recording_service.dart # Сервис записи
│   ├── pattern_service.dart  # Сервис паттернов
│   ├── preset_service.dart   # Сервис пресетов
│   ├── history_service.dart  # Сервис истории
│   ├── mixer_service.dart    # Сервис микшера
│   └── randomizer_service.dart # Сервис рандомайзера
└── theme/
    └── app_theme.dart        # Тема приложения
```

## Планы

- [ ] Реальные сэмплы и звук
- [ ] Экспорт в MP3
- [ ] Аудио запись с микрофона
- [ ] Поддержка Android
