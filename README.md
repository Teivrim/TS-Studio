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
- **Экспорт MIDI** — экспорт проекта в MIDI файл
- **Очистка** — сброс всех шагов
- **Undo/Redo** — история изменений
- **Пресеты** — готовые паттерны для быстрого старта
- **Паттерны** — создание и сохранение собственных паттернов
- **Визуализация волны** — отображение аудио волны
- **Микшер** — полноценный микшер с каналами
- **Рандомайзер** — генерация случайных паттернов
- **LFO** — модуляция параметров
- **Параметрический фильтр** — срез и резонанс
- **Горячие клавиши** — поддержка клавиатуры (Desktop/Web)
- **Метроном** — визуальный метроном
- **Tap Tempo** — установка BPM тапом
- **Анимации** — плавные анимации шагов
- **Кроссплатформенность** — Android, iOS, Web, Desktop
- **Sample Manager** — управление сэмплами
- **Piano Roll** — пиано-ролл для мелодий
- **Automation** — автоматизация параметров

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

## Горячие клавиши (Desktop/Web)

| Клавиша | Действие |
|---------|----------|
| Space | Play / Pause |
| Ctrl + Z | Отменить |
| Ctrl + Y | Повторить |
| Ctrl + S | Сохранить |
| Ctrl + O | Загрузить |
| Ctrl + E | Экспорт |
| M | Метроном |
| C | Очистить |
| 1-8 | Mute трек |

## Структура проекта

```
lib/
├── main.dart                 # Точка входа
├── screens/
│   └── sequencer_screen.dart # Главный экран с секвенсором
├── widgets/
│   ├── fl_step_sequencer.dart # Секвенсор в стиле FL Studio
│   ├── fl_track_header.dart  # Заголовок трека
│   ├── fl_transport.dart     # Транспортные кнопки
│   ├── fl_effects_panel.dart # Панель эффектов
│   ├── fl_metronome.dart     # Метроном
│   ├── fl_app_bar.dart       # Верхняя панель
│   ├── fl_button.dart        # Кнопка в стиле FL Studio
│   ├── fl_step.dart          # Шаг в стиле FL Studio
│   ├── fl_slider.dart        # Слайдер в стиле FL Studio
│   ├── fl_panel.dart         # Панель в стиле FL Studio
│   ├── mixer_screen.dart     # Экран микшера
│   ├── randomizer_dialog.dart # Диалог рандомайзера
│   ├── sample_manager_screen.dart # Менеджер сэмплов
│   ├── automation_screen.dart # Экран автоматизации
│   ├── piano_roll_screen.dart # Пиано-ролл
│   ├── tap_tempo_button.dart # Кнопка тап-темпо
│   ├── hotkey_help_dialog.dart # Справка по горячим клавишам
│   ├── platform_indicator.dart # Индикатор платформы
│   └── waveform_widget.dart  # Визуализация волны
├── models/
│   ├── track.dart            # Модели данных
│   ├── pattern.dart          # Модели паттернов
│   ├── mixer_channel.dart    # Модели микшера
│   └── sample.dart           # Модели сэмплов
├── services/
│   ├── audio_service.dart    # Аудио-сервис
│   ├── project_service.dart  # Сервис проектов
│   ├── export_service.dart   # Сервис экспорта
│   ├── recording_service.dart # Сервис записи
│   ├── pattern_service.dart  # Сервис паттернов
│   ├── preset_service.dart   # Сервис пресетов
│   ├── history_service.dart  # Сервис истории
│   ├── mixer_service.dart    # Сервис микшера
│   ├── randomizer_service.dart # Сервис рандомайзера
│   ├── metronome_service.dart # Сервис метронома
│   ├── sample_service.dart   # Сервис сэмплов
│   ├── automation_service.dart # Сервис автоматизации
│   ├── platform_service.dart # Сервис платформы
│   └── performance_service.dart # Сервис производительности
└── theme/
    └── app_theme.dart        # Тема приложения
```

## Планы

- [ ] Реальные сэмплы и звук
- [ ] Экспорт в MP3
- [ ] Аудио запись с микрофона
- [ ] Поддержка Android
