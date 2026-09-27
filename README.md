# Teivrim Sound Studio (TS Studio)

Мобильная музыкальная студия для Android, построенная на Flutter.

## Функционал

- **Step Sequencer** — сетка 16 шагов для создания битов и мелодий
- **6 треков** — Kick, Snare, Hi-Hat, Bass, Synth, Pad
- **Управление воспроизведением** — Play/Pause/Stop
- **Настройка BPM** — от 60 до 200 BPM
- **Mute треков** — отключение отдельных дорожек
- **Очистка** — сброс всех шагов

## Технологии

- Flutter (Dart)
- Flutter Riverpod — управление состоянием
- Audioplayers — воспроизведение звука

## Установка и запуск

```bash
# Клонировать репозиторий
git clone https://github.comTeivrim/TS-Studio.git

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
│   └── transport_controls.dart # Кнопки управления
├── models/
│   └── track.dart            # Модели данных
├── services/
│   └── audio_service.dart    # Аудио-сервис
└── theme/
    └── app_theme.dart        # Тема приложения
```

## Планы

- [ ] Реальный звук (сэмплы и синтез)
- [ ] Экспорт в WAV/MP3
- [ ] Эффекты (реверб, дилей, эквалайзер)
- [ ] Сохранение/загрузка проектов
- [ ] Больше треков и инструментов
