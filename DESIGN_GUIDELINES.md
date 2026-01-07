# Инструкция по стилям, шрифтам и отступам для экранов приложения I-Ching

## КРИТИЧЕСКИ ВАЖНО: Система масштабирования

Все значения из Figma указаны для базового размера экрана: **660×1434 пикселей (@1x)**

### Правила масштабирования:

1. **Горизонтальные отступы и размеры** масштабируются относительно **ширины экрана**:
   - `scaleFactor = geometry.size.width / 660`
   - `значение = исходное_значение × scaleFactor`

2. **Вертикальные отступы и размеры** масштабируются относительно **высоты экрана**:
   - `scaleFactor = geometry.size.height / 1434`
   - `значение = исходное_значение × scaleFactor`

3. **Размеры шрифтов** масштабируются используя **минимальный коэффициент** для сохранения пропорций:
   - `widthScale = geometry.size.width / 660`
   - `heightScale = geometry.size.height / 1434`
   - `fontScale = min(widthScale, heightScale)`
   - `размер_шрифта = исходный_размер × fontScale`

### Обязательные helper-функции для каждого View:

```swift
/// Масштабирует значение относительно базового размера экрана
/// Для горизонтальных значений использует ширину, для вертикальных - высоту
private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
    let scaleFactor: CGFloat
    if isVertical {
        scaleFactor = geometry.size.height / DesignConstants.[YourScreen].baseScreenHeight
    } else {
        scaleFactor = geometry.size.width / DesignConstants.[YourScreen].baseScreenWidth
    }
    return value * scaleFactor
}

/// Масштабирует размер шрифта пропорционально размерам экрана
/// Использует минимальный коэффициент для сохранения пропорций макета
private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
    let widthScaleFactor = geometry.size.width / DesignConstants.[YourScreen].baseScreenWidth
    let heightScaleFactor = geometry.size.height / DesignConstants.[YourScreen].baseScreenHeight
    let scaleFactor = min(widthScaleFactor, heightScaleFactor)
    return size * scaleFactor
}
```

---

## Структура DesignConstants

Каждый экран должен иметь свою структуру в `DesignConstants.swift`:

```swift
struct DesignConstants {
    struct YourScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")  // Бежевый фон
            static let textBlue = Color(hex: "286196")          // Синий текст
        }
        
        // MARK: - Typography
        struct Typography {
            // Заголовки секций (labels)
            static let labelSize: CGFloat = 22
            static let labelFontName = "Roboto Mono Thin"
            
            // Основной текст (body)
            static let bodySize: CGFloat = 22
            static let bodyFontName = "Helvetica Neue Light"
            
            // Главный заголовок (если нужен)
            static let mainTitleSize: CGFloat = 36
            static let mainTitleFontName = "Helvetica Neue Light"
            
            // Кнопки
            static let buttonSize: CGFloat = 22
            static let buttonFontName = "Druk Wide Cyr Medium"
        }
        
        // MARK: - Spacing
        struct Spacing {
            // Горизонтальные отступы
            static let horizontalPadding: CGFloat = 48  // Стандартный padding для контента
            
            // Вертикальные отступы между элементами
            static let element1Bottom: CGFloat = XX     // Отступ снизу элемента 1
            static let element2Top: CGFloat = XX        // Отступ сверху элемента 2
            static let blockBottom: CGFloat = XX        // Отступ снизу всего блока
            
            // И так далее для всех элементов...
        }
        
        // MARK: - Base Screen Size
        static let baseScreenWidth: CGFloat = 660
        static let baseScreenHeight: CGFloat = 1434
    }
}
```

---

## Шрифты

### Доступные шрифты в проекте:

1. **Roboto Mono Thin** (22pt) - для заголовков секций, меток
   - Используется для: "Сейчас", "Что будет меняться", "Линия X", "Тенденция", и т.д.
   - Fallback: `.system(size: size, weight: .ultraLight, design: .monospaced)`

2. **Helvetica Neue Light** (22pt) - для основного текста
   - Используется для: параграфов, интерпретаций, стратегий
   - Fallback: `.system(size: size, weight: .light)`

3. **Helvetica Neue Light** (36pt) - для больших заголовков
   - Используется для: главного заголовка (keyPhrase)
   - Fallback: `.system(size: size, weight: .light)`

4. **Helvetica Neue UltraLight** (22pt) - для описаний триграмм
   - Используется для: описаний триграмм ("Верхняя земля — среда готова поддерживать...")
   - Fallback: `.system(size: size, weight: .ultraLight)`

5. **Druk Wide Cyr Medium** (22pt) - для кнопок
   - Используется для: "ПРОДОЛЖИТЬ", других кнопок
   - Fallback: `.system(size: size, weight: .medium)`

### Helper-функции для шрифтов (добавлять в каждый View):

```swift
private func robotoMonoThinFont(size: CGFloat) -> Font {
    let fontNames = [
        "Roboto Mono Thin",
        "RobotoMono-Thin",
        "RobotoMonoThin"
    ]
    
    for fontName in fontNames {
        if UIFont(name: fontName, size: size) != nil {
            return .custom(fontName, size: size)
        }
    }
    
    return .system(size: size, weight: .ultraLight, design: .monospaced)
}

private func helveticaNeueLightFont(size: CGFloat) -> Font {
    let fontNames = [
        "Helvetica Neue Light",
        "HelveticaNeue-Light",
        "HelveticaNeueLight",
        "Helvetica Neue",
        "HelveticaNeue"
    ]
    
    for fontName in fontNames {
        if UIFont(name: fontName, size: size) != nil {
            return .custom(fontName, size: size)
        }
    }
    
    return .system(size: size, weight: .light)
}

private func helveticaNeueUltraLightFont(size: CGFloat) -> Font {
    let fontNames = [
        "Helvetica Neue UltraLight",
        "HelveticaNeue-UltraLight",
        "HelveticaNeueUltraLight",
        "Helvetica Neue",
        "HelveticaNeue"
    ]
    
    for fontName in fontNames {
        if UIFont(name: fontName, size: size) != nil {
            return .custom(fontName, size: size)
        }
    }
    
    return .system(size: size, weight: .ultraLight)
}

private func drukWideCyrMediumFont(size: CGFloat) -> Font {
    let fontNames = [
        "Druk Wide Cyr Medium",
        "DrukWideCyr-Medium",
        "DrukWideCyrMedium",
        "Druk Wide Cyr Medium Regular",
        "DrukWideCyrMedium-Regular",
        "Druk Wide Cyr",
        "DrukWideCyr",
        "Druk Wide Cyr Regular",
        "DrukWideCyr-Regular"
    ]
    
    for fontName in fontNames {
        if UIFont(name: fontName, size: size) != nil {
            return .custom(fontName, size: size)
        }
    }
    
    return .system(size: size, weight: .medium)
}
```

---

## Цвета

- **Фон:** `Color(hex: "EFE7D4")` - бежевый
- **Текст:** `Color(hex: "286196")` - синий

Расширение для HEX цветов уже есть в `DesignConstants.swift`:
```swift
extension Color {
    init(hex: String) {
        // ... реализация уже есть
    }
}
```

---

## Принципы работы с отступами

### ВАЖНО: Использование GeometryReader

Каждый экран ДОЛЖЕН быть обернут в `GeometryReader { geometry in ... }`:

```swift
var body: some View {
    GeometryReader { geometry in
        ZStack {
            DesignConstants.YourScreen.Colors.backgroundBeige
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Контент с использованием scaledValue и scaledFontSize
                }
            }
        }
    }
}
```

### Правила применения отступов:

1. **Все VStack должны иметь `spacing: 0`** - отступы задаются вручную через `.padding()`

2. **Горизонтальные padding:**
   ```swift
   .padding(.horizontal, scaledValue(DesignConstants.YourScreen.Spacing.horizontalPadding, for: geometry))
   ```
   Или отдельно:
   ```swift
   .padding(.leading, scaledValue(XX, for: geometry))
   .padding(.trailing, scaledValue(XX, for: geometry))
   ```
   
   **Стандартные горизонтальные отступы:**
   - Основной контент: 48px
   - Буллиты и трактовки триграмм: **80px слева**, 48px справа

3. **Вертикальные padding:**
   ```swift
   .padding(.top, scaledValue(XX, for: geometry, isVertical: true))
   .padding(.bottom, scaledValue(XX, for: geometry, isVertical: true))
   ```
   
   **ВАЖНО: Отступы между блоками должны быть кратны 20px:**
   - 20px, 40px, 60px, 80px, 100px, 120px, 140px, 160px и т.д.
   - Это обеспечивает визуальную согласованность и ритм интерфейса

4. **Размеры шрифтов:**
   ```swift
   .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.YourScreen.Typography.bodySize, for: geometry)))
   ```

5. **Выравнивание:** Все тексты выровнены по **левому краю** (`.leading`)

---

## Пример структуры отступов (из InterpretationScreen):

- **Горизонтальный padding:** 48px (стандарт для большинства элементов)
- **Между заголовком и текстом:** 20px
- **Между секциями:** 40px (типично)
- **Специальные отступы:** 
  - Для буллитов и трактовок триграмм: **80px слева**, 48px справа
  - Между кнопками ролей: 60px
  - Крупные отступы (кнопка "Продолжить" снизу): 148px снизу фрейма

### ВАЖНО: Правила отступов между блоками

- **Отступы между блоками должны быть кратны 20px:**
  - 20px, 40px, 60px, 80px, 100px, 120px, 140px, 160px и т.д.
  - Это обеспечивает визуальную согласованность и ритм интерфейса
  - Примеры: между секциями - 40px, между триграммами - 40px, после последнего блока до кнопки - 160px

### Паттерн именования отступов:

- `[element]Bottom` - отступ снизу элемента
- `[element]Top` - отступ сверху элемента
- `[block]BlockBottom` - отступ снизу всего блока
- `[type]Spacing` - отступ между элементами одного типа (например, `paragraphSpacing`)

---

## Чеклист при создании нового экрана:

- [ ] Создана структура `YourScreen` в `DesignConstants.swift`
- [ ] Добавлены Colors, Typography, Spacing
- [ ] Добавлены `baseScreenWidth: 660` и `baseScreenHeight: 1434`
- [ ] View обернут в `GeometryReader { geometry in ... }`
- [ ] Все отступы используют `scaledValue(..., for: geometry, isVertical: Bool)`
- [ ] Все шрифты используют `scaledFontSize(..., for: geometry)`
- [ ] Добавлены helper-функции для шрифтов
- [ ] Добавлены функции `scaledValue` и `scaledFontSize`
- [ ] VStack имеют `spacing: 0`
- [ ] Все тексты выровнены по `.leading`
- [ ] Фон: бежевый `#EFE7D4`
- [ ] Текст: синий `#286196`

---

## Референс: InterpretationScreen

Для детального примера смотрите:
- `DesignConstants.swift` -> `InterpretationScreen` структура
- `InterpretationView.swift` -> реализация с правильными отступами

Все отступы там указаны точно из Figma и используются как эталон для других экранов.

---
rcj,thb vyt ctqxfc cnherenhe dct[ 'hfyjd d ghbkj;tybb c b[ yf[dfybzvb d cbcntvt xnj,s vyt ,skj ghjot lfkmit r ybv jncskfnm]]]
## Референс: AdvancedInterpretationScreen

Для примера расширенной интерпретации смотрите:
- `DesignConstants.swift` -> `AdvancedInterpretationScreen` структура
- `AdvancedInterpretationView.swift` -> реализация с правильными отступами

Особенности:
- Использует `SmallLineView` для визуализации линий (толщина 5px)
- Использует `TrigramView` для визуализации триграмм
- Отступы для текста описания триграмм: **80px слева**, 48px справа
- Отступы для буллитов в "Для размышления": **80px слева**, 48px справа
- Линии гексаграмм выровнены с текстом трактовок (80px от края)
- Отступы между блоками кратны 20px (20, 40, 60, 80, 100, 120, 140, 160 и т.д.)

