import SwiftUI

// MARK: - Design Constants для переноса из макета
// Замените значения ниже на значения из вашего макета (Figma, Sketch и т.д.)

struct DesignConstants {
    
    // MARK: - Spacing (Отступы)
    struct Spacing {
        // Горизонтальные отступы (safe zone) - Фибоначчи: 21, 34, 55
        static let horizontalPadding: CGFloat = 34 // Используем 34 для мобильных устройств
        
        // Вертикальные отступы
        static let titleBottom: CGFloat = 60        // Отступ под заголовком
        static let infoBottom: CGFloat = 30        // Отступ под информационным текстом
        static let templatesBottom: CGFloat = 40   // Отступ под примерами
        static let buttonBottom: CGFloat = 60       // Отступ под кнопкой
        
        // Отступы между элементами
        static let templatesSpacing: CGFloat = 16   // Между примерами вопросов
        static let templateVertical: CGFloat = 8   // Вертикальный padding для примера
    }
    
    // MARK: - Typography (Типографика)
    struct Typography {
        // Заголовок
        static let titleSize: CGFloat = 18
        static let titleWeight: Font.Weight = .light
        
        // Информационный текст
        static let infoSize: CGFloat = 12
        static let infoWeight: Font.Weight = .ultraLight
        static let infoLineSpacing: CGFloat = 4
        
        // Примеры вопросов
        static let templateSize: CGFloat = 14
        static let templateWeight: Font.Weight = .ultraLight
        
        // Поле ввода
        static let inputSize: CGFloat = 16
        static let inputWeight: Font.Weight = .light
        
        // Кнопка
        static let buttonSize: CGFloat = 16
        static let buttonWeight: Font.Weight = .light
    }
    
    // MARK: - Colors (Цвета)
    struct Colors {
        static let background: Color = .white
        static let title: Color = .black
        static let info: Color = .gray
        static let template: Color = .gray
        static let input: Color = .black
        static let button: Color = .black
        static let buttonBorder: Color = .black
        
        // Legacy aliases для совместимости
        static let textPrimary: Color = .black
        static let textSecondary: Color = .gray
        static let accent: Color = .black
    }
    
    // MARK: - Sizes (Размеры)
    struct Sizes {
        static let inputHeight: CGFloat = 100      // Высота поля ввода
        static let cursorWidth: CGFloat = 1.5      // Ширина курсора
        static let cursorHeight: CGFloat = 24      // Высота курсора
        static let buttonBorderWidth: CGFloat = 1 // Толщина рамки кнопки
    }
    
    // MARK: - Button (Кнопка)
    struct Button {
        static let horizontalPadding: CGFloat = 30
        static let verticalPadding: CGFloat = 12
        static let backgroundColor: Color = .clear // transparent
    }
    
    // MARK: - Animation (Анимация)
    struct Animation {
        static let cursorBlinkDuration: Double = 0.8
        static let focusDelay: Double = 0.5
    }
    
    // MARK: - Start Screen Design Constants
    struct StartScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")
            static let titleRed = Color(hex: "F44336") // Новый красный
            static let buttonBlue = Color(hex: "286196") // Новый синий
        }
        
        // MARK: - Typography
        struct Typography {
            // Иероглифы 乾 и 坤
            static let chineseCharactersSize: CGFloat = 190
            static let chineseCharactersFontName = "Zen Old Mincho"
            static let chineseCharactersWeight: Font.Weight = .bold
            
            // Название "И-ЦЗИН"
            static let mainTitleSize: CGFloat = 133
            static let mainTitleFontName = "Druk XXCondensed Cyr Super"
            static let mainTitleWeight: Font.Weight = .regular
            
            // Подзаголовок "КНИГА ПЕРЕМЕН"
            static let subtitleSize: CGFloat = 22
            static let subtitleFontName = "Helvetica Neue"
            static let subtitleWeight: Font.Weight = .regular
            
            // Кнопки
            static let buttonTextSize: CGFloat = 22
            static let buttonFontName = "Druk Wide Cyr"
            static let buttonWeight: Font.Weight = .medium
        }
        
        // MARK: - Spacing (точные значения из Figma 660×1434)
        struct Spacing {
            // От верха экрана до иероглифов
            static let topToChineseCharacters: CGFloat = 210
            
            // Расстояние между иероглифами
            static let betweenChineseCharacters: CGFloat = 137
            
            // От иероглифов до драконов
            static let chineseCharactersToDragons: CGFloat = 12
            
            // Размеры драконов из Figma (точные значения)
            static let dragonsWidth: CGFloat = 467.49
            static let dragonsHeight: CGFloat = 440.2
            
            // От драконов до первой кнопки
            static let dragonsToFirstButton: CGFloat = 190
            
            // Расстояние между кнопками
            static let buttonSpacing: CGFloat = 12
            
            // От последней кнопки до низа
            static let lastButtonToBottom: CGFloat = 183
            
            // Горизонтальные отступы для иероглифов
            static let chineseCharactersHorizontalPadding: CGFloat = 71
            
            // Позиционирование текстов относительно нижнего края
            static let mainTitleFromBottom: CGFloat = 476  // "И-ЦЗИН" от нижнего края
            static let subtitleFromMainTitle: CGFloat = 20  // "КНИГА ПЕРЕМЕН" от "И-ЦЗИН"
        }
        
        // MARK: - Base Screen Size (для масштабирования)
        static let baseScreenWidth: CGFloat = 660 // Размер фрейма в Figma (660x1434)
        static let baseScreenHeight: CGFloat = 1434 // Высота фрейма в Figma
    }
    
    // MARK: - Question Screen Design Constants
    struct QuestionScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")
            static let textBlue = Color(hex: "286196")
        }
        
        // MARK: - Typography
        struct Typography {
            // Заголовок "СФОРМУЛИРУЙТЕ ВОПРОС"
            static let titleSize: CGFloat = 22
            static let titleFontName = "Druk Wide Cyr Medium"
            
            // Параграфы
            static let paragraphSize: CGFloat = 22
            static let paragraphFontName = "Roboto Mono Thin"
            
            // Placeholder в поле ввода
            static let placeholderSize: CGFloat = 22
            static let placeholderFontName = "Helvetica Neue Light"
            
            // Кнопки
            static let buttonSize: CGFloat = 22
            static let buttonFontName = "Druk Wide Cyr Medium"
        }
        
        // MARK: - Spacing (точные значения из Figma 660×1434)
        struct Spacing {
            // Вертикальные отступы
            static let topToTitle: CGFloat = 247 // От верха до заголовка
            static let titleToFirstParagraph: CGFloat = 40 // От заголовка до первого параграфа
            static let betweenParagraphs: CGFloat = 20 // Между параграфами
            static let secondParagraphToInput: CGFloat = 200 // От второго параграфа до поля ввода
            static let inputToButtons: CGFloat = 497 // От поля ввода до кнопок
            static let buttonsToBottom: CGFloat = 156 // От кнопок до нижнего края
            
            // Горизонтальные отступы
            static let titleHorizontalPadding: CGFloat = 108 // Для заголовка
            static let contentHorizontalPadding: CGFloat = 78 // Для параграфов и поля ввода
            static let buttonHorizontalPadding: CGFloat = 46.77 // Для кнопок
            static let buttonSpacing: CGFloat = 0 // Расстояние между кнопками
        }
        
        // MARK: - Base Screen Size (для масштабирования)
        static let baseScreenWidth: CGFloat = 660 // Размер фрейма в Figma (660x1434)
        static let baseScreenHeight: CGFloat = 1434 // Высота фрейма в Figma
    }
    
    // MARK: - Coins Screen Design Constants
    struct CoinsScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")
            static let lineColor = Color(hex: "286196")
            static let circleBorderColor = Color(hex: "286196")
            static let chineseCharacterColor = Color(hex: "286196")
            static let buttonTextColor = Color(hex: "286196")
            static let counterTextColor = Color(hex: "286196")
        }
        
        // MARK: - Typography
        struct Typography {
            // Иероглифы в кругах
            static let chineseCharacterSize: CGFloat = 22
            static let chineseCharacterFontName = "Shippori Mincho"
            static let chineseCharacterWeight: Font.Weight = .light
            
            // Кнопка "БРОСИТЬ МОНЕТЫ"
            static let buttonTextSize: CGFloat = 22
            static let buttonFontName = "Druk Wide Cyr Medium"
            static let buttonWeight: Font.Weight = .medium
            
            // Счетчик "1/6"
            static let counterTextSize: CGFloat = 22
            static let counterFontName = "RobotoMono-VariableFont_wght" // Временно, уточнить
            static let counterWeight: Font.Weight = .thin
        }
        
        // MARK: - Spacing (точные значения из Figma 660×1434)
        struct Spacing {
            // Вертикальные отступы
            static let topToHexagram: CGFloat = 259 // От верха до первой линии гексаграммы
            static let hexagramToCircles: CGFloat = 157 // От гексаграммы до кругов
            static let circlesToCounter: CGFloat = 60 // От кругов до счетчика
            static let buttonToBottom: CGFloat = 164 // От кнопки до нижнего края
            
            // Горизонтальные отступы
            static let betweenCircles: CGFloat = 60 // Расстояние между кругами
            static let buttonHorizontalPadding: CGFloat = 175 // Горизонтальный padding кнопки
            static let counterHorizontalPadding: CGFloat = 310 // Горизонтальный padding счетчика
            
            // Вертикальный padding кнопки (предположение)
            static let buttonVerticalPadding: CGFloat = 13
        }
        
        // MARK: - Sizes
        struct Sizes {
            // Круги с иероглифами
            static let circleDiameter: CGFloat = 147
            static let circleBorderWidth: CGFloat = 3
            
            // Линии гексаграммы
            static let lineLength: CGFloat = 204 // Длина одной линии
            static let lineSegmentLength: CGFloat = 68 // Для прерывистой линии
            static let lineThickness: CGFloat = 13 // Толщина линии
            static let lineSpacing: CGFloat = 18.4 // Расстояние между линиями (рассчитано: (170 - 6*13) / 5 = 18.4)
            static let hexagramTotalHeight: CGFloat = 170 // Общая высота гексаграммы (6 линий + промежутки)
            
            // Монеты (предположение: ~85% от диаметра круга)
            static let coinDiameter: CGFloat = 125
        }
        
        // MARK: - Base Screen Size (для масштабирования)
        static let baseScreenWidth: CGFloat = 660 // Размер фрейма в Figma (660x1434)
        static let baseScreenHeight: CGFloat = 1434 // Высота фрейма в Figma
    }
    
    // MARK: - Hexagram Screen Design Constants
    struct HexagramScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")
            static let textBlue = Color(hex: "286196")
        }
        
        // MARK: - Typography
        struct Typography {
            // Заголовок "Текущее состояние"
            static let currentStateTitleSize: CGFloat = 22
            static let currentStateTitleFontName = "Roboto Mono"
            
            // "Гексограмма X: ..."
            static let hexagramLabelSize: CGFloat = 22
            static let hexagramLabelFontName = "Roboto Mono"
            
            // Текст интерпретации
            static let interpretationSize: CGFloat = 22
            static let interpretationFontName = "Helvetica Neue Thin"
            
            // Вопрос "Куда всё движется если ничего не менять"
            static let questionSize: CGFloat = 22
            static let questionFontName = "Roboto Mono"
            
            // Кнопка "ПОДРОБНЕЕ"
            static let buttonSize: CGFloat = 22
            static let buttonFontName = "Druk Wide Cyr"
        }
        
        // MARK: - Spacing (точные значения из Figma 660×1434)
        struct Spacing {
            // Вертикальные отступы
            static let topToCurrentStateTitle: CGFloat = 150 // От верха до "Текущее состояние"
            static let currentStateTitleToHexagram: CGFloat = 80 // От "Текущее состояние" до первой гексограммы
            static let hexagramToLabel: CGFloat = 80 // От первой гексограммы до "Гексограмма 11: МИР"
            static let labelToInterpretation: CGFloat = 20 // От "Гексограмма 11: МИР" до текста интерпретации
            static let interpretationToQuestion: CGFloat = 100 // От текста интерпретации до "Куда всё движется"
            static let questionToSecondHexagram: CGFloat = 80 // От "Куда всё движется" до второй гексограммы
            static let secondHexagramToLabel: CGFloat = 80 // От второй гексограммы до "Гексограмма 14: ..."
            static let secondLabelToButton: CGFloat = 120 // От "Гексограмма 14: ..." до кнопки "ПОДРОБНЕЕ"
            
            // Позиция первой гексограммы (как на CoinsScreen)
            static let topToFirstHexagram: CGFloat = 259 // От верха до первой линии гексограммы
        }
        
        // MARK: - Sizes (используем те же размеры, что и в CoinsScreen)
        struct Sizes {
            // Линии гексаграммы
            static let lineLength: CGFloat = 204 // Длина одной линии
            static let lineSegmentLength: CGFloat = 68 // Для прерывистой линии
            static let lineThickness: CGFloat = 13 // Толщина линии
            static let lineSpacing: CGFloat = 18.4 // Расстояние между линиями
            static let hexagramTotalHeight: CGFloat = 170 // Общая высота гексаграммы (6 линий + промежутки)
        }
        
        // MARK: - Base Screen Size (для масштабирования)
        static let baseScreenWidth: CGFloat = 660 // Размер фрейма в Figma (660x1434)
        static let baseScreenHeight: CGFloat = 1434 // Высота фрейма в Figma
    }
    
    // MARK: - Interpretation Screen Design Constants
    struct InterpretationScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")
            static let textBlue = Color(hex: "286196")
        }
        
        // MARK: - Typography
        struct Typography {
            // Main title (keyPhrase)
            static let mainTitleSize: CGFloat = 36
            static let mainTitleFontName = "Helvetica Neue Light"
            
            // Labels/headings ("Гексаграмма X: Y", "Образ: Z", "Сейчас", "Выбери свою роль", "Что будет меняться", "Линия X")
            static let labelSize: CGFloat = 22
            static let labelFontName = "Roboto Mono Thin"
            
            // Body text (interpretations, strategies)
            static let bodySize: CGFloat = 22
            static let bodyFontName = "Helvetica Neue Light"
            
            // Continue button
            static let buttonSize: CGFloat = 22
            static let buttonFontName = "Druk Wide Cyr Medium"
        }
        
        // MARK: - Spacing (точные значения из Figma 660×1434)
        struct Spacing {
            // Горизонтальные отступы
            static let horizontalPadding: CGFloat = 48 // Отступ по горизонтали для всего контента
            
            // Главный заголовок
            static let topToTitle: CGFloat = 170 // От верха до главного заголовка
            static let titleBottom: CGFloat = 13 // Отступ снизу главного заголовка
            
            // Информация о гексаграмме
            static let hexagramNumberBottom: CGFloat = 8 // Отступ снизу номера гексаграммы
            static let hexagramImageBottom: CGFloat = 13 // Отступ снизу образа
            static let qualitiesTop: CGFloat = 8 // Отступ сверху качеств (тегов)
            static let dividerTop: CGFloat = 20 // Отступ сверху разделителя
            static let hexagramInfoBlockBottom: CGFloat = 20 // Отступ снизу всего блока информации о гексаграмме
            
            // Блок "Сейчас"
            static let nowHeaderBottom: CGFloat = 20 // Отступ снизу заголовка "Сейчас"
            static let nowParagraphSpacing: CGFloat = 20 // Между предложениями в блоке "Сейчас"
            static let nowBlockBottom: CGFloat = 40 // Отступ снизу всего блока "Сейчас"
            
            // Блок выбора роли
            static let roleSelectorHeaderBottom: CGFloat = 20 // Отступ снизу заголовка "Выбери свою роль"
            static let roleButtonsSpacing: CGFloat = 60 // Отступ между кнопками "Лидер" и "Участник"
            static let roleButtonsBottom: CGFloat = 40 // Отступ снизу кнопок ролей
            static let strategyTextTop: CGFloat = 20 // Отступ сверху текста стратегии
            static let roleSelectorBlockBottom: CGFloat = 40 // Отступ снизу всего блока выбора роли
            
            // Блок "Что будет меняться"
            static let changesHeaderBottom: CGFloat = 20 // Отступ снизу заголовка "Что будет меняться"
            static let lineHeaderToText: CGFloat = 20 // Отступ между заголовком линии и текстом
            static let lineItemBottom: CGFloat = 40 // Отступ снизу элемента линии
            static let changesBlockBottom: CGFloat = 0 // Отступ снизу всего блока "Что будет меняться"
            
            // Блок "Тенденция"
            static let trendHeaderBottom: CGFloat = 20 // Отступ снизу заголовка "Тенденция"
            static let trendParagraphSpacing: CGFloat = 20 // Между предложениями в блоке "Тенденция"
            static let trendBlockBottom: CGFloat = 40 // Отступ снизу всего блока "Тенденция"
            
            // Блок "Практические шаги"
            static let practicalStepsHeaderBottom: CGFloat = 20 // Отступ снизу заголовка "Практические шаги"
            static let practicalStepsBlockBottom: CGFloat = 40 // Отступ снизу всего блока "Практические шаги"
            
            // Блок "Для размышления"
            static let reflectionHeaderBottom: CGFloat = 40 // Отступ снизу заголовка "Для размышления"
            static let reflectionBlockBottom: CGFloat = 120 // Отступ снизу всего блока "Для размышления"
            
            // Переключатель углубленного режима
            static let advancedToggleBottom: CGFloat = 80 // Отступ снизу кнопки "Подробнее об этом раскладе"
            
            // Кнопка "Продолжить"
            static let continueButtonBottom: CGFloat = 148 // Отступ снизу кнопки "Продолжить"
            
            // Внутренние отступы (используются как междуParagraphs)
            static let betweenParagraphs: CGFloat = 20 // Между параграфами внутри секции
            
            // Специальные отступы для блоков с буллитами
            static let bulletBlockLeftPadding: CGFloat = 81 // Отступ слева для блоков с буллитами
            static let bulletBlockRightPadding: CGFloat = 48 // Отступ справа для блоков с буллитами
        }
        
        // MARK: - Base Screen Size (для масштабирования)
        static let baseScreenWidth: CGFloat = 660 // Размер фрейма в Figma (660x1434)
        static let baseScreenHeight: CGFloat = 1434 // Высота фрейма в Figma
    }
}

// MARK: - Расширение для HEX цветов из макета
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


