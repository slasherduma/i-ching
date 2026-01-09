# АНАЛИЗ ПРОЕКТА И-ЦЗИН ДЛЯ ИНТЕГРАЦИИ УЛУЧШЕНИЙ

## 1. СТРУКТУРА ПРОЕКТА

### Дерево файлов и папок

```
I-CHING/
├── i-ching/
│   ├── i-ching/
│   │   ├── Assets.xcassets/          # Ресурсы (иконки, изображения)
│   │   ├── ContentView.swift          # Корневой view с навигацией
│   │   ├── IChingApp.swift           # Точка входа приложения
│   │   ├── hexagrams.json             # ⭐ JSON с данными 64 гексаграмм
│   │   ├── Models/
│   │   │   └── Hexagram.swift         # ⭐ Модели: Hexagram, Trigram, Line, Reading
│   │   ├── Services/
│   │   │   ├── InterpretationService.swift  # ⭐ Генерация интерпретаций
│   │   │   ├── SafetyService.swift          # ⭐ Проверка вопросов
│   │   │   ├── StorageService.swift         # Сохранение данных
│   │   │   ├── NavigationManager.swift     # Навигация
│   │   │   └── NotificationsService.swift   # Уведомления
│   │   └── Views/
│   │       ├── StartView.swift              # Стартовый экран
│   │       ├── QuestionView.swift           # Экран вопроса
│   │       ├── CoinsView.swift              # Экран броска монет
│   │       ├── HexagramView.swift           # Экран гексаграммы
│   │       ├── InterpretationView.swift     # ⭐ Экран интерпретации
│   │       ├── ResultView.swift             # Финальный экран результата
│   │       ├── TutorialView.swift           # ⭐ Онбординг/помощь
│   │       ├── HistoryView.swift            # Дневник предсказаний
│   │       ├── DailySignView.swift          # Знак дня
│   │       ├── AdvancedInterpretationView.swift  # ⭐ Углубленная интерпретация
│   │       ├── ReadingDetailView.swift      # Детали записи
│   │       ├── DesignConstants.swift        # ⭐ Константы дизайна
│   │       └── Components/                  # UI компоненты
│   │           ├── BottomBar.swift
│   │           ├── MenuBarView.swift
│   │           ├── RoleSelectorView.swift
│   │           ├── QualitiesView.swift
│   │           └── ...
│   └── ...
└── ...
```

### Расположение ключевых элементов

#### Тексты о философии И-Цзин, введение, инструкции
- **TutorialView.swift** (строки 9-25) — 3 страницы онбординга:
  - "Что такое гексаграмма"
  - "Метод трёх монет"
  - "Зачем нужен вопрос"
- **QuestionView.swift** (строка 172) — краткая инструкция:
  - "Формулировка не влияет на ответ. Важно лишь удерживать вопрос в сознании во время броска монет"
- **StartView.swift** — стартовый экран без текстовых блоков о философии

#### JSON с данными гексаграмм
- **Файл**: `i-ching/i-ching/hexagrams.json`
- **Структура**: Массив из 64 объектов `Hexagram`
- **Размер**: ~2627 строк
- **Формат**: Стандартный JSON, загружается через `Bundle.main.url(forResource: "hexagrams", withExtension: "json")`

#### Описания триграмм
- **В JSON**: Поле `trigrams` в каждой гексаграмме (структура `TrigramPair` с `upper` и `lower`)
- **Модель**: `Models/Hexagram.swift` (строки 3-6, 19, 29-32)
- **Отображение**: `AdvancedInterpretationView.swift` (строки 85-158) — показываются в углубленном режиме

#### Код генерации интерпретаций
- **Файл**: `Services/InterpretationService.swift` (225 строк)
- **Структура результата**: `InterpretationResult` (строки 16-24)
- **Методы генерации**:
  - `generateNowBlock()` — блок "Сейчас" (3-5 предложений)
  - `generateChangesBlock()` — блок "Что будет меняться" (1-3 пункта)
  - `generateTrendBlock()` — блок "Тенденция" (2-4 предложения, если есть 2-я гексаграмма)
  - `generatePracticalBlock()` — блок "Практическая подсказка" (2-3 действия)

#### UI компоненты для отображения информации
- **InterpretationView.swift** — основной экран интерпретации
- **AdvancedInterpretationView.swift** — углубленный режим (триграммы, линии, вопросы)
- **ResultView.swift** — финальный экран с кратким текстом

---

## 2. СОДЕРЖАНИЕ ТЕКСТОВ

### Экран "Что такое И-Цзин" / "О методе"
**Статус**: ❌ Отдельного экрана нет

**Существующие тексты**:
- **TutorialView** (строка 11-12): "Гексаграмма состоит из шести линий, которые строятся снизу вверх. Каждая линия может быть сплошной (ян) или прерванной (инь)."
- **TutorialView** (строка 16-17): "Бросай три монеты шесть раз. Каждый бросок создаёт одну линию гексаграммы. Меняющиеся линии (6 и 9) показывают точки перемен."

### Экран "Как работает метод" / "Философия"
**Статус**: ❌ Отдельного экрана нет

**Существующие тексты**: Нет философских текстов о том, почему метод работает.

### Экран "Как бросать монеты" / "Инструкция"
**Статус**: ✅ Частично реализовано

**TutorialView** (строка 16-17):
```
"Метод трёх монет"
"Бросай три монеты шесть раз. Каждый бросок создаёт одну линию гексаграммы. Меняющиеся линии (6 и 9) показывают точки перемен."
```

**QuestionView** (строка 172):
```
"Формулировка не влияет на ответ.
Важно лишь удерживать вопрос в сознании во время броска монет"
```

### Экран "Как читать результат" / "Интерпретация"
**Статус**: ✅ Реализовано через InterpretationView

**Структура интерпретации**:
1. **keyPhrase** (главный заголовок) — Helvetica Neue Light 36pt
2. **Информация о гексаграмме**:
   - Номер и название (Roboto Mono Light 22pt)
   - Образ (Roboto Mono Light 22pt)
   - Качества (теги)
3. **Блок "Сейчас"** (Roboto Mono Light 22pt заголовок, Helvetica Neue Light 22pt текст)
4. **Выбор роли и стратегия** (если есть `leadershipStrategy` или `subordinateStrategy`)
5. **Блок "Что будет меняться"** (если есть меняющиеся линии)
6. **Блок "Тенденция"** (если есть вторая гексаграмма)
7. **Практические шаги** (нумерованный список)
8. **Кнопка "Подробнее об этом раскладе"** → открывает AdvancedInterpretationView

### Любые другие информационные экраны
- **TutorialView** — 3 страницы онбординга (показывается при первом запуске)
- **StartView** — стартовый экран с кнопками (без текстовых блоков)

---

## 3. КОД ИНТЕРПРЕТАЦИИ

### InterpretationService.swift

**Полный путь**: `i-ching/i-ching/Services/InterpretationService.swift`

**Структура InterpretationResult** (строки 16-24):
```swift
struct InterpretationResult {
    let now: [String]        // 3–5 предложений
    let changes: [String]    // 1–3 пункта
    let trend: [String]?     // 2–4, если есть 2-я гекс.
    let practical: [String]  // 2–3 действия
    let mood: MoodLevel      // cautious/balanced/opportunities
    let anchors: [AnchorIcon] // wave/mountain/lightning/sun
    let safetyCheck: SafetyCheck
}
```

**Логика формирования блоков**:

#### Блок "Сейчас" (`generateNowBlock`, строки 66-87)
- Использует `hexagram.generalStrategy` как основу
- Разбивает по точкам, берет первые 3 предложения
- Если нет `generalStrategy`, использует `keyPhrase` или `interpretation`
- Ограничение: до 5 предложений

#### Блок "Что меняется" (`generateChangesBlock`, строки 89-116)
- Фильтрует меняющиеся линии (`lines.filter { $0.isChanging }`)
- Если есть `hexagram.lineTexts`, использует тексты линий
- Иначе генерирует общий текст о количестве меняющихся линий
- Ограничение: до 3 пунктов

#### Блок "Тенденция" (`generateTrendBlock`, строки 118-134)
- Показывается только если есть `secondHexagram`
- Использует `keyPhrase` или `interpretation` второй гексаграммы
- Добавляет качества второй гексаграммы
- Ограничение: до 4 предложений

#### Блок "Практика" (`generatePracticalBlock`, строки 136-168)
- Приоритет: `hexagram.practicalAdvice` (если есть)
- Fallback: анализ `interpretation` на ключевые слова:
  - "терпение"/"ждать" → "Не торопи события"
  - "осторожн"/"опасн" → "Действуй осторожно и обдуманно"
  - "активн"/"действ" → "Время для решительных действий"
  - "гармони"/"сотрудничеств" → "Согласуй ожидания с партнерами"
- Ограничение: до 3 действий

### SafetyService.swift

**Полный путь**: `i-ching/i-ching/Services/SafetyService.swift`

**Структура SafetyCheck** (строки 10-14):
```swift
struct SafetyCheck {
    let level: SafetyLevel  // normal/health/legal/danger
    let disclaimer: String
    let recommendation: String?
}
```

**Логика проверки** (`checkQuestion`, строки 37-79):
- Анализирует вопрос на ключевые слова:
  - **healthKeywords**: здоровье, болезнь, лечение, врач, медицин...
  - **legalKeywords**: юридическ, закон, суд, адвокат, право...
  - **dangerKeywords**: опасность, риск, угроза, безопасность...
- Возвращает соответствующий `SafetyCheck` с предупреждением и рекомендацией

---

## 4. ДАННЫЕ О ТРИГРАММАХ

### Где описаны триграммы

**В JSON гексаграмм**: Поле `trigrams` в каждой гексаграмме (опционально)

**Структура данных** (из `Hexagram.swift`, строки 19, 29-32):
```swift
let trigrams: TrigramPair?

struct TrigramPair: Codable, Hashable {
    let upper: Trigram  // Верхняя триграмма (линии 4-6)
    let lower: Trigram  // Нижняя триграмма (линии 1-3)
}

struct Trigram: Codable, Hashable {
    let name: String        // Название: "Небо", "Земля", "Вода" и т.д.
    let description: String // Описание триграммы
}
```

**Пример из JSON** (гексаграмма 1):
```json
"trigrams": {
  "upper": {
    "name": "Небо",
    "description": "Верхняя триграмма Небо — внешняя среда высокой энергии: поддержка инициативы, ускорение процессов, ясный запрос на лидерство и созидание."
  },
  "lower": {
    "name": "Небо",
    "description": "Нижняя триграмма Небо — внутренняя сила: воля, творческий импульс, готовность брать ответственность и начинать новые циклы."
  }
}
```

### Показываются ли они пользователю в UI

**Да**, но только в углубленном режиме:

**AdvancedInterpretationView.swift** (строки 85-158):
- Показываются только если `hexagram.trigrams != nil`
- Отображаются визуально (3 линии) через компонент `TrigramView`
- Показываются название и описание каждой триграммы
- Формат:
  - Заголовок "Объяснение триграмм" (Roboto Mono Thin)
  - Верхняя триграмма (линии 4-6): визуализация + название + описание
  - Нижняя триграмма (линии 1-3): визуализация + название + описание

**Доступ**: Кнопка "Подробнее об этом раскладе" в `InterpretationView` → открывает `AdvancedInterpretationView`

---

## 5. USER FLOW

### Что видит при первом запуске

1. **StartView** (стартовый экран):
   - Иероглифы 乾 и 坤
   - Название "И-ЦЗИН" и "КНИГА ПЕРЕМЕН"
   - Изображение драконов
   - Кнопки:
     - "СДЕЛАТЬ РАСКЛАД"
     - "ЗНАК ДНЯ"
     - "ДНЕВНИК ПРЕДСКАЗАНИЙ"
     - "ПОМОЩЬ"

2. **Автоматически показывается TutorialView** (если `hasSeenTutorial == false`):
   - 3 страницы онбординга
   - Можно закрыть через "ВЫХОД В МЕНЮ" или пролистать до конца

### Как приходит к броску монет

**Путь 1: Через вопрос**
1. StartView → "СДЕЛАТЬ РАСКЛАД"
2. QuestionView → ввод вопроса (опционально) → "БРОСИТЬ МОНЕТЫ" или "ПРОПУСТИТЬ"
3. CoinsView → бросок монет (6 раз)

**Путь 2: Без вопроса**
1. StartView → "СДЕЛАТЬ РАСКЛАД"
2. QuestionView → "ПРОПУСТИТЬ"
3. CoinsView → бросок монет (6 раз)

### Какие экраны показываются после броска и в каком порядке

1. **CoinsView** → бросок 6 раз (счетчик 0/6 → 6/6)
2. **HexagramView** → автоматически после 6-го броска:
   - Гексаграмма (6 линий)
   - Номер и название
   - Иероглиф
   - Кнопка "Продолжить"
3. **InterpretationView** → после нажатия "Продолжить":
   - keyPhrase (главный заголовок)
   - Информация о гексаграмме
   - Блок "Сейчас"
   - Выбор роли и стратегия (если есть)
   - Блок "Что будет меняться" (если есть меняющиеся линии)
   - Блок "Тенденция" (если есть вторая гексаграмма)
   - Практические шаги
   - Кнопка "Подробнее об этом раскладе" (если есть углубленный контент)
   - Кнопка "ПРОДОЛЖИТЬ"
4. **ResultView** → финальный экран:
   - Дата и время
   - Гексаграмма
   - Номер и название
   - keyPhrase
   - 2-3 предложения из generalStrategy
   - Кнопки "СОХРАНИТЬ" и "ВЫХОД В МЕНЮ"

### Есть ли: онбординг, раздел "Справка", история бросков, возможность добавлять заметки

- ✅ **Онбординг**: TutorialView (3 страницы, показывается при первом запуске)
- ✅ **Раздел "Справка"**: Кнопка "ПОМОЩЬ" на StartView → открывает TutorialView
- ✅ **История бросков**: Кнопка "ДНЕВНИК ПРЕДСКАЗАНИЙ" → HistoryView → список всех сохраненных раскладов
- ⚠️ **Заметки**: Частично реализовано:
  - В `Reading` есть поле `userNotes: String?` (строка 108 в Hexagram.swift)
  - В `ReadingDetailView` можно просматривать и редактировать заметки
  - Но нет явной кнопки "Добавить заметку" на экране результата

---

## 6. СТИЛИСТИКА

### Тон коммуникации

**Форма обращения**: **"ты"** (неформальный, дружелюбный тон)

**Примеры из кода**:
- "Бросай три монеты шесть раз" (TutorialView)
- "Если ты в роли участника/исполнителя..." (generalStrategy)
- "Твоя задача — надежность и последовательность" (subordinateStrategy)
- "Где в моей жизни сейчас нужен большой старт..." (reflectionQuestions)

### Длина абзацев

**Короткие абзацы** (1-3 предложения):
- Блок "Сейчас": 3-5 предложений
- Блок "Что меняется": 1-3 пункта
- Блок "Тенденция": 2-4 предложения
- Практические шаги: 2-3 действия

**Средние абзацы** (4-6 предложений):
- generalStrategy: обычно 2-4 предложения
- subordinateStrategy/leadershipStrategy: 2-3 предложения

### Использование списков, таблиц, выделений

**Списки**:
- ✅ Нумерованные списки для практических шагов (1., 2., 3.)
- ✅ Маркированные списки для вопросов размышления (•)
- ✅ Теги для качеств (QualitiesView)

**Таблицы**: ❌ Не используются

**Выделения**:
- ✅ Кавычки для цитат из классических текстов: «Спящий дракон — не действуй»
- ✅ Жирный текст для заголовков (Roboto Mono Light)
- ✅ Разные шрифты для заголовков и текста

### Наличие эмодзи, иконок

**Эмодзи**: ❌ Не используются в UI (только в коде для отладки)

**Иконки**:
- ✅ SVG иконки для линий (Line, Line_s)
- ✅ SVG для монет (Coin1, Coin2)
- ✅ SVG для визуальных элементов (dragons-hero, sun, question_mark)
- ✅ Системные иконки для chevron (в кнопке "Подробнее")

### Примеры экранов с текстом

#### Пример 1: TutorialView (строка 12)
```
"Гексаграмма состоит из шести линий, которые строятся снизу вверх. 
Каждая линия может быть сплошной (ян) или прерванной (инь)."
```
- **Шрифт**: Helvetica Neue Light
- **Размер**: 22pt (scaled)
- **Цвет**: textBlue (#286196)
- **Выравнивание**: по центру
- **Стиль**: короткий абзац, простое объяснение

#### Пример 2: InterpretationView — блок "Сейчас"
```
"Гексаграмма 1 — это чистая творящая сила и старт цикла. 
Внешние обстоятельства поддерживают инициативу, но требуют точного ритма: 
сначала созревание и выверка, затем действие, затем контроль пика и грамотное снижение."
```
- **Заголовок**: "Сейчас" (Roboto Mono Light 22pt)
- **Текст**: Helvetica Neue Light 22pt
- **Цвет**: textBlue (#286196)
- **Стиль**: 3-5 предложений, философский тон, практические советы

#### Пример 3: Практические шаги
```
1. Не форсируй начало: подготовь основу (план, ресурсы, роли), чтобы старт был точным.
2. Собери союзников и поддержку заранее — рост ускорится через правильные связи.
3. Действуй последовательно: дисциплина важнее скорости, особенно в фазе разгона.
```
- **Формат**: Нумерованный список
- **Шрифт**: Helvetica Neue Light 22pt
- **Стиль**: Короткие действия, императивный тон

---

## 7. ТЕХНИЧЕСКИЕ ОГРАНИЧЕНИЯ

### Есть ли лимиты на объём текста

**В JSON гексаграмм**: ❌ Нет явных лимитов в коде, но есть практические ограничения:
- `now`: до 5 предложений (код ограничивает через `prefix(5)`)
- `changes`: до 3 пунктов (код ограничивает через `prefix(3)`)
- `trend`: до 4 предложений (код ограничивает через `prefix(4)`)
- `practical`: до 3 действий (код ограничивает через `prefix(3)`)

**В UI**: Ограничения через `fixedSize(horizontal: false, vertical: true)` — текст может быть любой длины, но будет переноситься

### Можно ли добавлять новые поля в JSON гексаграмм

**Да**, но нужно:
1. Добавить поле в структуру `Hexagram` (`Models/Hexagram.swift`)
2. Сделать поле опциональным (`let newField: String?`) для обратной совместимости
3. Обновить все 64 записи в `hexagrams.json` (или оставить `null` для старых записей)

**Пример добавления нового поля**:
```swift
// В Hexagram.swift
let newField: String? // Новое поле

// В hexagrams.json
{
  "id": 1,
  "number": 1,
  ...
  "newField": "новое значение" // или null
}
```

### Планируется ли локализация на другие языки

**Статус**: ❌ Не реализовано

**Текущее состояние**:
- Все тексты на русском языке
- Нет системы локализации (нет `.lproj` папок, нет `Localizable.strings`)
- JSON гексаграмм содержит только русские тексты

**Для добавления локализации нужно**:
1. Создать структуру локализации (`.lproj` папки)
2. Вынести все строки в `Localizable.strings`
3. Создать отдельные JSON файлы для каждого языка (или добавить поля `name_en`, `interpretation_en` и т.д.)

### Контент вшит в приложение или подгружается динамически

**Вшит в приложение** (Bundle Resources):
- `hexagrams.json` загружается из Bundle: `Bundle.main.url(forResource: "hexagrams", withExtension: "json")`
- Все тексты статичны
- Нет backend API
- Нет динамической загрузки контента

**Хранение данных пользователя**:
- `UserDefaults` через `StorageService` (локальное хранение)
- Сохранение раскладов, заметок, настроек

---

## 8. ПОЗИЦИОНИРОВАНИЕ

### Целевая аудитория проекта

**Из анализа кода и дизайна**:
- Люди, интересующиеся И-Цзин как инструментом размышления
- Пользователи, ищущие практические советы для принятия решений
- Аудитория, ценящая минималистичный дизайн и философский подход

**Тон коммуникации**: Дружелюбный, неформальный ("ты"), но уважительный к традиции

### Тон коммуникации с пользователем

**Характеристики**:
- **Обращение**: "ты" (неформальное)
- **Стиль**: Философский, но практичный
- **Длина текстов**: Короткие абзацы (1-5 предложений)
- **Формат**: Прямые советы, вопросы для размышления, практические шаги
- **Эмодзи**: Не используются
- **Выделения**: Кавычки для классических текстов, нумерованные списки для действий

**Примеры тона**:
- "Если ты в роли участника/исполнителя, действуй как тот, кто видит момент..."
- "Где в моей жизни сейчас нужен большой старт — и что должно созреть прежде, чем я нажму «пуск»?"
- "Не форсируй начало: подготовь основу (план, ресурсы, роли), чтобы старт был точным."

### Roadmap или список желаемых улучшений

**Из APP_STORE_CHECKLIST.md**:
- Подключение рекламы (AdMob)
- Privacy Policy
- Исправление версии iOS (сейчас указано iOS 26.1, что неверно)

**Из IMPLEMENTATION_PLAN.md** (частично реализовано):
- ✅ TutorialView
- ✅ HistoryView
- ✅ DailySignView
- ⚠️ Видео-фон (упоминается, но не реализовано)

**Потенциальные улучшения** (из анализа кода):
- Добавление текстов о философии И-Цзин
- Таблица триграмм (сейчас показываются только в контексте гексаграммы)
- Чеклист работы с гексаграммой
- Связи между гексаграммами
- Расширенный дневник (теги, исходы — поля есть, но не все реализовано)

---

## 9. ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ

### Дизайн-система

**Цвета**:
- `backgroundBeige`: #EFE7D4 (бежевый фон)
- `textBlue`: #286196 (синий текст)
- `titleRed`: #F44336 (красный для заголовков)
- `buttonTextColor`: #FF3636 (красный для кнопок)

**Шрифты**:
- **Заголовки**: Roboto Mono Light/Thin (22-36pt)
- **Основной текст**: Helvetica Neue Light (22pt)
- **Кнопки**: Roboto Mono Light (размер зависит от экрана)
- **Иероглифы**: Rampart One (190pt на стартовом экране)

**Отступы**:
- Горизонтальные: 34px (базовый), 48px, 80px (для текста)
- Вертикальные: варьируются в зависимости от экрана

### Навигация

**NavigationManager** управляет стеком экранов:
- `.question` → QuestionView
- `.coins` → CoinsView
- `.hexagram` → HexagramView
- `.interpretation` → InterpretationView
- `.result` → ResultView

**Переходы**: Fade transitions (`.opacity`) с длительностью 0.2s

### Хранение данных

**StorageService** использует `UserDefaults`:
- Сохранение раскладов (`Reading`)
- Сохранение знака дня
- Сохранение флага `hasSeenTutorial`

**Формат Reading**:
```swift
struct Reading {
    let id: String
    let date: Date
    let question: String?
    let hexagramNumber: Int
    let hexagramName: String
    let lines: [LineData]
    let interpretation: String
    let summary: String?
    let userNotes: String?
    let secondHexagramNumber: Int?
    let tags: [String]?
    let outcome: String?
}
```

---

## 10. РЕКОМЕНДАЦИИ ДЛЯ ИНТЕГРАЦИИ УЛУЧШЕНИЙ

### Где добавить новые текстовые блоки

1. **"Почему метод работает"**:
   - Создать новый экран `PhilosophyView.swift`
   - Или добавить страницу в `TutorialView` (4-я страница)
   - Или добавить раздел в `StartView` (кнопка "О методе")

2. **Таблица триграмм**:
   - Создать новый экран `TrigramsTableView.swift`
   - Или добавить в `AdvancedInterpretationView` (новый блок)
   - Или добавить в `TutorialView` (5-я страница)

3. **Чеклист работы с гексаграммой**:
   - Добавить в `InterpretationView` (новый блок после "Практические шаги")
   - Или создать компонент `ChecklistView.swift` и использовать в `InterpretationView`

4. **Связи между гексаграммами**:
   - Добавить поле `relatedHexagrams: [Int]?` в `Hexagram`
   - Создать компонент `RelatedHexagramsView.swift`
   - Показывать в `AdvancedInterpretationView` или `InterpretationView`

### Соответствие стилю проекта

**При добавлении текстов**:
- Использовать обращение "ты"
- Короткие абзацы (1-5 предложений)
- Шрифты: Roboto Mono Light для заголовков, Helvetica Neue Light для текста
- Цвета: textBlue (#286196) для текста, titleRed для акцентов
- Отступы: 34px горизонтальные, вертикальные по дизайн-константам

**При добавлении новых экранов**:
- Использовать `DesignConstants` для отступов и размеров
- Использовать `scaledValue()` и `scaledFontSize()` для адаптивности
- Добавить в `NavigationManager` новый case
- Использовать fade transitions

---

## 11. ТЕКУЩИЙ КОД KeyboardTextView И ОБРАБОТЧИКОВ

### KeyboardTextView (makeUIView/updateUIView/Coordinator)

**Файл**: `Views/QuestionView.swift` (строки 5-106)

```swift
// UITextView с Return key настроенным как Done
struct KeyboardTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool
    var font: UIFont
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.textColor = .black
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = true
        
        // Явно выставляем свойства для гарантированного получения фокуса
        textView.isEditable = true
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        
        // Отключаем автокоррекцию
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.smartDashesType = .no
        textView.smartQuotesType = .no
        textView.smartInsertDeleteType = .no
        textView.spellCheckingType = .no
        
        // Настраиваем Return key как Done
        textView.returnKeyType = .done
        textView.enablesReturnKeyAutomatically = true
        
        // Сохраняем ссылку на textView
        context.coordinator.textView = textView
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Обновляем текст только если он изменился извне
        if uiView.text != text {
            uiView.text = text
        }
        
        // Обновляем ссылку
        context.coordinator.textView = uiView
        
        // Сохраняем настройки автокоррекции
        uiView.autocorrectionType = .no
        uiView.autocapitalizationType = .none
        uiView.smartDashesType = .no
        uiView.smartQuotesType = .no
        uiView.smartInsertDeleteType = .no
        uiView.spellCheckingType = .no
        
        // Принудительное управление first responder
        if isFirstResponder == true && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if isFirstResponder == false && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: KeyboardTextView
        weak var textView: UITextView?
        
        init(_ parent: KeyboardTextView) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            // Обновляем состояние first responder при начале редактирования
            parent.isFirstResponder = true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // Сохраняем текст в binding при каждом изменении
            parent.text = textView.text
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // Обрабатываем нажатие Return key (Done)
            if text == "\n" {
                handleDone()
                return false // Предотвращаем вставку новой строки
            }
            return true
        }
        
        private func handleDone() {
            // Закрываем клавиатуру и обновляем состояние
            parent.isFirstResponder = false
            textView?.resignFirstResponder()
        }
    }
}
```

### Обработчик "галочки" (кнопка / toolbar item)

**Статус**: ❌ Нет кастомной кнопки "галочки" (toolbar item)

**Реализация**: Используется только системная кнопка "Done" на клавиатуре iOS

**Код обработки Return key (вместо "галочки")**:
```swift
func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    // Обрабатываем нажатие Return key (Done)
    if text == "\n" {
        handleDone()
        return false // Предотвращаем вставку новой строки
    }
    return true
}

private func handleDone() {
    // Закрываем клавиатуру и обновляем состояние
    parent.isFirstResponder = false
    textView?.resignFirstResponder()
}
```

### FocusState или .onTapGesture вокруг контейнера

**FocusState**: ❌ Не используется `@FocusState`, используется `@State private var isEditorFocused: Bool = false`

**Код в QuestionView** (`Views/QuestionView.swift`, строки 108-167):
```swift
struct QuestionView: View {
    @State private var question: String = ""
    @State private var showCoins = false
    @State private var isEditorFocused = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                Text("Сформулируй вопрос")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(.black)
                
                KeyboardTextView(
                    text: $question,
                    isFirstResponder: $isEditorFocused,
                    font: .systemFont(ofSize: 16, weight: .light)
                )
                .frame(minHeight: 60, maxHeight: 120)
                .padding(.horizontal, 40)
                .onTapGesture {
                    isEditorFocused = true
                }
                
                // ... остальной код ...
            }
        }
        // ... остальной код ...
    }
}
```

**Альтернативная версия с более продвинутым обработчиком** (`i-ching/i-ching/Views/QuestionView.swift`, строки 214-223):
```swift
.contentShape(Rectangle())
.simultaneousGesture(
    TapGesture()
        .onEnded { _ in
            // Закрываем клавиатуру при тапе по любому месту экрана
            if isTextFieldFocused {
                isTextFieldFocused = false
            }
        }
)
```

**Использование .onTapGesture на самом поле ввода** (`i-ching/i-ching/Views/QuestionView.swift`, строки 195-197):
```swift
.onTapGesture {
    isTextFieldFocused = true
}
```

---

**Дата анализа**: 2025-01-27
**Версия проекта**: 1.0
**Анализированные файлы**: 20+ Swift файлов, JSON, документация
