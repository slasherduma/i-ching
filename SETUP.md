# Инструкция по настройке проекта

## Создание проекта в Xcode

1. Откройте Xcode
2. Создайте новый проект: **File → New → Project**
3. Выберите **iOS → App**
4. Заполните:
   - Product Name: `IChing`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Minimum Deployment: **iOS 17.0**
5. Сохраните проект в папку с кодом

## Добавление файлов

1. Скопируйте все файлы из этой папки в проект Xcode:
   - Перетащите папки `Models`, `Services`, `Views` в навигатор проекта
   - Добавьте `hexagrams.json` в проект (важно: отметьте "Copy items if needed" и добавьте в Target)

2. Замените содержимое автоматически созданных файлов:
   - `IChingApp.swift` - уже создан
   - `ContentView.swift` - уже создан

## Настройка Bundle

Убедитесь, что `hexagrams.json` добавлен в **Bundle Resources**:
1. Выберите `hexagrams.json` в навигаторе
2. В правой панели (File Inspector) проверьте, что файл отмечен для вашего Target

## Запуск

1. Выберите симулятор iOS 17+ или подключенное устройство
2. Нажмите **Run** (⌘R)

## Структура файлов в Xcode

```
IChing/
├── IChingApp.swift
├── ContentView.swift
├── Models/
│   └── Hexagram.swift
├── Services/
│   └── StorageService.swift
├── Views/
│   ├── StartView.swift
│   ├── QuestionView.swift
│   ├── CoinsView.swift
│   ├── HexagramView.swift
│   ├── InterpretationView.swift
│   └── ResultView.swift
└── hexagrams.json (в Bundle Resources)
```


