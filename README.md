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
- **Project Browser** — браузер проектов
- **Spectrum Visualizer** — визуализатор спектра
- **Settings** — настройки приложения
- **Synthesizer** — синтезатор с пресетами
- **MIDI Monitor** — MIDI монитор
- **Waveform Display** — отображение волны
- **Effect Browser** — браузер эффектов
- **Realtime Spectrum** — спектр в реальном времени
- **Chord Progressions** — аккордовые прогрессии
- **Drum Pads** — драм-пэды
- **Loop Browser** — браузер лупов
- **Loop Sequencer** — секвенсер лупов
- **Waveform Editor** — редактор волны
- **Sample Pack Browser** — браузер паков сэмплов
- **Master Section** — мастер-секция
- **Tempo Tapper** — тап-темпо
- **About** — информация о приложении

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
│   ├── modern_step_sequencer.dart # Секвенсор
│   ├── modern_track_header.dart  # Заголовок трека
│   ├── modern_transport.dart     # Транспортные кнопки
│   ├── modern_effects_panel.dart # Панель эффектов
│   ├── modern_metronome.dart     # Метроном
│   ├── modern_app_bar.dart       # Верхняя панель
│   ├── modern_button.dart        # Кнопка
│   ├── modern_step.dart          # Шаг
│   ├── modern_slider.dart        # Слайдер
│   ├── modern_panel.dart         # Панель
│   ├── mixer_screen.dart         # Экран микшера
│   ├── randomizer_dialog.dart    # Диалог рандомайзера
│   ├── sample_manager_screen.dart # Менеджер сэмплов
│   ├── automation_screen.dart    # Экран автоматизации
│   ├── piano_roll_screen.dart    # Пиано-ролл
│   ├── tap_tempo_button.dart     # Кнопка тап-темпо
│   ├── project_browser_screen.dart # Браузер проектов
│   ├── spectrum_visualizer.dart  # Визуализатор спектра
│   ├── settings_screen.dart      # Настройки
│   ├── export_dialog.dart        # Диалог экспорта
│   ├── synth_screen.dart         # Синтезатор
│   ├── midi_monitor_screen.dart  # MIDI монитор
│   ├── waveform_display.dart     # Отображение волны
│   ├── effect_browser_screen.dart # Браузер эффектов
│   ├── realtime_spectrum.dart    # Спектр в реальном времени
│   ├── chord_progression_screen.dart # Аккордовые прогрессии
│   ├── drum_pad_screen.dart      # Драм-пэды
│   ├── loop_browser_screen.dart  # Браузер лупов
│   ├── loop_sequencer_screen.dart # Секвенсер лупов
│   ├── waveform_editor_screen.dart # Редактор волны
│   ├── sample_pack_browser.dart  # Браузер паков сэмплов
│   ├── master_section_screen.dart # Мастер-секция
│   ├── tempo_tapper_screen.dart # Тап-темпо
│   └── about_screen.dart         # О приложении
├── models/
│   ├── track.dart                # Модели данных
│   ├── pattern.dart              # Модели паттернов
│   ├── mixer_channel.dart        # Модели микшера
│   ├── sample.dart               # Модели сэмплов
│   ├── project.dart              # Модели проектов
│   ├── synth_preset.dart         # Модели пресетов синтезатора
│   ├── effect_preset.dart        # Модели пресетов эффектов
│   ├── loop.dart                 # Модели лупов
│   └── sample_pack.dart          # Модели паков сэмплов
├── services/
│   ├── audio_service.dart        # Аудио-сервис
│   ├── project_service.dart      # Сервис проектов
│   ├── export_service.dart       # Сервис экспорта
│   ├── recording_service.dart    # Сервис записи
│   ├── pattern_service.dart      # Сервис паттернов
│   ├── preset_service.dart       # Сервис пресетов
│   ├── history_service.dart      # Сервис истории
│   ├── mixer_service.dart        # Сервис микшера
│   ├── randomizer_service.dart   # Сервис рандомайзера
│   ├── metronome_service.dart    # Сервис метронома
│   ├── sample_service.dart       # Сервис сэмплов
│   ├── automation_service.dart   # Сервис автоматизации
│   ├── project_browser_service.dart # Сервис браузера проектов
│   ├── spectrum_service.dart     # Сервис спектра
│   ├── settings_service.dart     # Сервис настроек
│   ├── synth_service.dart        # Сервис синтезатора
│   ├── midi_service.dart         # MIDI сервис
│   ├── effect_service.dart       # Сервис эффектов
│   ├── loop_service.dart         # Сервис лупов
│   ├── waveform_service.dart     # Сервис волны
│   ├── sample_pack_service.dart  # Сервис паков сэмплов
│   └── performance_service.dart  # Сервис производительности
└── theme/
    └── app_theme.dart            # Тема приложения
```

## Планы

- [ ] Реальные сэмплы и звук
- [ ] Экспорт в MP3
- [ ] Аудио запись с микрофона
- [ ] Поддержка Android
