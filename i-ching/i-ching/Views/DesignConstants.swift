import SwiftUI
import UIKit

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
    
    // MARK: - Layout (Глобальные константы для layout)
    struct Layout {
        // Небольшой отступ от safe area для CTA (чтобы контент не перекрывал home indicator)
        static let ctaSafeBottomPadding: CGFloat = 16
        
        // "Подъем" CTA над safe area - большое пустое пространство под кнопкой (соответствует buttonToBottom)
        static let ctaLiftHigh: CGFloat = 80
        
        // "Подъем" для sticky CTA - небольшой отступ от низа для визуального разделения
        static let ctaLiftSticky: CGFloat = 44
        
        // Отступ для sticky CTA overlay, чтобы выровнять с flow CTA baseline
        static let ctaStickyOffset: CGFloat = 56
        
        // Горизонтальный padding для двух кнопок (double layout)
        static let ctaHorizontalPaddingDouble: CGFloat = 48
        
        // UIKit цвет для текста CTA кнопок (красный #FF3636)
        static let ctaTextUIColor: UIColor = UIColor(red: 255/255, green: 54/255, blue: 54/255, alpha: 1)
    }
    
    // MARK: - Start Screen Design Constants
    struct StartScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")
            static let titleRed = Color(hex: "F44336") // Новый красный
            static let buttonBlue = Color(hex: "286196") // Новый синий
            static let buttonTextColor = Color(hex: "FF3636") // Красный для кнопок
        }
        
        // MARK: - Typography
        struct Typography {
            // Иероглифы 乾 и 坤
            static let chineseCharactersSize: CGFloat = 190
            static let chineseCharactersFontName = "Rampart One"
            static let chineseCharactersWeight: Font.Weight = .regular
            
            // Название "И-ЦЗИН"
            static let mainTitleSize: CGFloat = 133
            static let mainTitleFontName = "Druk XXCondensed Cyr Super"
            static let mainTitleWeight: Font.Weight = .regular
            
            // Подзаголовок "КНИГА ПЕРЕМЕН"
            static let subtitleSize: CGFloat = 22
            static let subtitleFontName = "Helvetica Neue"
            static let subtitleWeight: Font.Weight = .regular
            
            // Кнопки
            static let buttonTextSize: CGFloat = 36
            static let buttonFontName = "Roboto Mono Light"
            static let buttonWeight: Font.Weight = .light
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
            static let buttonTextColor = Color(hex: "FF3636") // Красный для кнопок
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
            static let buttonSize: CGFloat = 36
            static let buttonFontName = "Roboto Mono Light"
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
            static let buttonTextColor = Color(hex: "FF3636")
            static let counterTextColor = Color(hex: "FF3636")
        }
        
        // MARK: - Typography
        struct Typography {
            // Иероглифы в кругах
            static let chineseCharacterSize: CGFloat = 22
            static let chineseCharacterFontName = "Shippori Mincho"
            static let chineseCharacterWeight: Font.Weight = .light
            
            // Кнопка "БРОСИТЬ МОНЕТЫ"
            static let buttonTextSize: CGFloat = 36
            static let buttonFontName = "Roboto Mono Light"
            static let buttonWeight: Font.Weight = .light
            
            // Счетчик "1/6"
            static let counterTextSize: CGFloat = 22
            static let counterFontName = "Roboto Mono Light"
            static let counterWeight: Font.Weight = .light
            static let counterLineHeight: CGFloat = 29
        }
        
        // MARK: - Spacing (точные значения из Figma 660×1434)
        struct Spacing {
            // Вертикальные отступы
            static let topToMenu: CGFloat = 133 // От верха экрана до строки меню
            static let topToHexagram: CGFloat = 360 // От верха экрана (над черным островком) до первой линии гексаграммы
            static let hexagramToCircles: CGFloat = 160 // От низа гексаграммы до монет
            static let circlesToCounter: CGFloat = 60 // От кругов до счетчика
            static let counterToButton: CGFloat = 400 // От счетчика до кнопки "БРОСИТЬ МОНЕТЫ"
            static let buttonToBottom: CGFloat = 150 // От кнопки до нижнего края
            
            // Горизонтальные отступы
            static let menuHorizontalPadding: CGFloat = 48 // Отступ слева/справа для кнопок меню
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
            static let lineLength: CGFloat = 160 // Ширина линии
            static let lineSegmentLength: CGFloat = 68 // Для прерывистой линии
            static let lineThickness: CGFloat = 10 // Толщина линии (палки)
            static let lineSpacing: CGFloat = 8 // Расстояние между линиями (100px общая высота - 60px линии = 40px / 5 промежутков = 8px)
            static let hexagramTotalHeight: CGFloat = 100 // Общая высота гексаграммы
            
            // Монеты
            static let coinDiameter: CGFloat = 150
            
            // OPTIONAL FIX: Fixed button height to guarantee identical frames across screens
            static let buttonHeight: CGFloat = 52
        }
        
        // MARK: - Hand Animation
        struct HandAnimation {
            // Базовая линия снизу (общая для всех кадров)
            static let bottomBaseLine: CGFloat = 222 // Отступ от нижнего края экрана
            
            // Кадр 1 (hand1)
            struct Frame1 {
                static let x: CGFloat = 197 // От левого края
                static let y: CGFloat = 936 // От верхнего края
                static let width: CGFloat = 266
                static let height: CGFloat = 276
            }
            
            // Кадр 2 (hand2)
            struct Frame2 {
                static let x: CGFloat = 148 // От левого края
                static let y: CGFloat = 932 // От верхнего края
                static let width: CGFloat = 244
                static let height: CGFloat = 280
            }
            
            // Кадр 3 (hand3)
            struct Frame3 {
                static let x: CGFloat = 167 // От левого края
                static let y: CGFloat = 884 // От верхнего края (рассчитано от базовой линии)
                static let width: CGFloat = 327
                static let height: CGFloat = 328
            }
            
            // Кадр 4 (hand4) - стоп-кадр
            struct Frame4 {
                static let x: CGFloat = 167 // От левого края
                // Y рассчитывается от базовой линии снизу: baseScreenHeight (1434) - bottomBaseLine (222) - height (296) = 916
                static let y: CGFloat = 916 // От верхнего края (рассчитано от базовой линии снизу)
                static let width: CGFloat = 287
                static let height: CGFloat = 296
            }
            
            // Длительности анимации
            static let loopAnimationDuration: Double = 0.5 // Длительность перехода между hand1 и hand2
            static let throwAnimationDuration: Double = 0.3 // Длительность перехода к hand3
            static let finalFrameDuration: Double = 0.2 // Длительность перехода к hand4
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
            static let buttonTextColor = Color(hex: "FF3636") // Красный для кнопок
        }
        
        // MARK: - Typography
        struct Typography {
            // Заголовок "Текущее состояние"
            static let currentStateTitleSize: CGFloat = 22
            static let currentStateTitleFontName = "Roboto Mono Thin"
            
            // "Гексограмма X: ..."
            static let hexagramLabelSize: CGFloat = 22
            static let hexagramLabelFontName = "Roboto Mono Thin"
            
            // Текст интерпретации
            static let interpretationSize: CGFloat = 22
            static let interpretationFontName = "Helvetica Neue Thin"
            
            // Вопрос "Куда всё движется если ничего не менять"
            static let questionSize: CGFloat = 22
            static let questionFontName = "Roboto Mono Thin"
            
            // Кнопка "ПОДРОБНЕЕ"
            static let buttonSize: CGFloat = 36
            static let buttonFontName = "Roboto Mono Light"
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
            static let topToFirstHexagram: CGFloat = 360 // От верха до первой линии гексограммы (совпадает с CoinsScreen)
        }
        
        // MARK: - Sizes (используем те же размеры, что и в CoinsScreen)
        struct Sizes {
            // Линии гексаграммы
            static let lineLength: CGFloat = 160 // Ширина линии
            static let lineSegmentLength: CGFloat = 68 // Для прерывистой линии
            static let lineThickness: CGFloat = 10 // Толщина линии (палки)
            static let lineSpacing: CGFloat = 8 // Расстояние между линиями (100px общая высота - 60px линии = 40px / 5 промежутков = 8px)
            static let hexagramTotalHeight: CGFloat = 100 // Общая высота гексаграммы
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
            static let buttonTextColor = Color(hex: "FF3636") // Красный для кнопок
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
            static let buttonSize: CGFloat = 36
            static let buttonFontName = "Roboto Mono Light"
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
            static let bulletBlockLeftPadding: CGFloat = 80 // Отступ слева для блоков с буллитами
            static let bulletBlockRightPadding: CGFloat = 48 // Отступ справа для блоков с буллитами
        }
        
        // MARK: - Base Screen Size (для масштабирования)
        static let baseScreenWidth: CGFloat = 660 // Размер фрейма в Figma (660x1434)
        static let baseScreenHeight: CGFloat = 1434 // Высота фрейма в Figma
    }
    
    // MARK: - Advanced Interpretation Screen Design Constants
    struct AdvancedInterpretationScreen {
        // MARK: - Colors
        struct Colors {
            static let textBlue = Color(hex: "286196")
            static let backgroundBeige = Color(hex: "EFE7D4")
        }
        
        // MARK: - Typography
        struct Typography {
            // Используем существующие размеры из InterpretationScreen
            static let bodySize: CGFloat = 22
            static let labelSize: CGFloat = 22
        }
        
        // MARK: - Spacing (точные значения из Figma 660×1434)
        struct Spacing {
            // Кнопка "Скрыть подробности"
            static let topToHideButton: CGFloat = 40
            static let hideButtonBottom: CGFloat = 120
            
            // Разделитель и заголовки секций
            static let dividerToSectionHeader: CGFloat = 40
            static let sectionHeaderBottom: CGFloat = 20
            
            // Блок "Текст по меняющимся линиям"
            static let lineVisualToLabel: CGFloat = 36
            static let lineLabelToText: CGFloat = 20
            static let lineItemTopFirst: CGFloat = 20 // Отступ сверху для первого элемента (Линия 4)
            static let lineItemTopOther: CGFloat = 40 // Отступ сверху для остальных элементов (Линия 5, 6)
            static let lineItemBottom: CGFloat = 0
            static let changingLinesBlockBottom: CGFloat = 0
            
            // Между блоками
            static let betweenBlocks: CGFloat = 60
            
            // Блок "Объяснение триграмм"
            static let trigramsHeaderBottom: CGFloat = 20
            static let trigramHeaderToSymbol: CGFloat = 40 // Отступ от заголовка "Верхняя триграмма" до первой линии
            static let trigramSymbolToName: CGFloat = 20
            static let trigramNameToDescription: CGFloat = 20
            static let betweenTrigrams: CGFloat = 40 // Отступ между описанием верхней триграммы и верхней линией нижней триграммы
            static let trigramsBlockBottom: CGFloat = 40
            static let trigramsToReflection: CGFloat = 0
            
            // Блок "Для размышления"
            static let reflectionHeaderBottom: CGFloat = 20
            static let reflectionItemSpacing: CGFloat = 20
            static let reflectionBlockBottom: CGFloat = 160 // Отступ снизу блока "Для размышления" до кнопки "Продолжить"
            
            // Горизонтальные отступы
            static let horizontalPadding: CGFloat = 48
            static let bulletBlockLeftPadding: CGFloat = 80 // Отступ слева для буллитов и трактовок триграмм
            static let bulletBlockRightPadding: CGFloat = 48 // Отступ справа для буллитов и трактовок триграмм
            static let lineLeftOffset: CGFloat = 32 // Дополнительный отступ слева для линий (80 - 48 = 32)
        }
        
        // MARK: - Sizes
        struct Sizes {
            static let dividerHeight: CGFloat = 1
            static let chevronSize: CGFloat = 16
        }
        
        // MARK: - Base Screen Size (для масштабирования)
        static let baseScreenWidth: CGFloat = 660 // Размер фрейма в Figma (660x1434)
        static let baseScreenHeight: CGFloat = 1434 // Высота фрейма в Figma
    }
    
    // MARK: - Daily Sign Screen Design Constants
    struct DailySignScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")
            static let textBlue = Color(hex: "286196")
            static let buttonTextColor = Color(hex: "FF3636") // Красный для кнопок
        }
        
        // MARK: - Typography
        struct Typography {
            // Дата (например, "29 декабря 2025 г.")
            static let dateSize: CGFloat = 22
            static let dateFontName = "Roboto Mono Thin"
            
            // Время (например, "00:23")
            static let timeSize: CGFloat = 22
            static let timeFontName = "Roboto Mono Thin"
            
            // Название гексаграммы (например, "14 : ВЕЛИКОЕ ОБЛАДАНИЕ")
            static let hexagramNameSize: CGFloat = 22
            static let hexagramNameFontName = "Roboto Mono Thin"
            
            // Короткий абзац (центрированный)
            static let shortParagraphSize: CGFloat = 22
            static let shortParagraphFontName = "Roboto Mono Thin"
            
            // Основной текст
            static let bodyTextSize: CGFloat = 22
            static let bodyTextFontName = "Helvetica Neue Thin"
            
            // Кнопки
            static let buttonSize: CGFloat = 36
            static let buttonFontName = "Roboto Mono Light"
        }
        
        // MARK: - Spacing (точные значения из Figma 660×1434)
        struct Spacing {
            // От верха экрана до даты
            static let topToDate: CGFloat = 140
            
            // От блока даты/времени до верха гексаграммы
            static let dateTimeBlockToHexagram: CGFloat = 345
            
            // От низа гексаграммы до названия "ВЕЛИКОЕ ОБЛАДАНИЕ"
            static let hexagramBottomToName: CGFloat = 80
            
            // От названия до короткого абзаца
            static let nameToShortParagraph: CGFloat = 40
            
            // От короткого абзаца до основного текста
            static let shortParagraphToBody: CGFloat = 40
            
            // От основного текста до кнопок
            static let bodyToButtons: CGFloat = 140
            
            // Горизонтальный отступ для основного текста
            static let bodyTextHorizontalPadding: CGFloat = 48
            
            // Отступ между параграфами основного текста (если несколько)
            static let bodyParagraphSpacing: CGFloat = 20
            
            // Расстояние между датой и временем (одна строка под другой, без дополнительного отступа)
            static let dateToTime: CGFloat = 0
            
            // Горизонтальные отступы для кнопок
            static let buttonHorizontalPadding: CGFloat = 80
            
            // Расстояние между кнопками
            static let buttonSpacing: CGFloat = 48
            
            // Отступ снизу до кнопок
            static let buttonsToBottom: CGFloat = 158
        }
        
        // MARK: - Sizes (используем те же размеры, что и в CoinsScreen)
        struct Sizes {
            // Линии гексаграммы (такие же как в CoinsScreen)
            static let lineLength: CGFloat = 160 // Ширина линии
            static let lineSegmentLength: CGFloat = 68 // Для прерывистой линии
            static let lineThickness: CGFloat = 10 // Толщина линии (палки)
            static let lineSpacing: CGFloat = 8 // Расстояние между линиями (100px общая высота - 60px линии = 40px / 5 промежутков = 8px)
            static let hexagramTotalHeight: CGFloat = 100 // Общая высота гексаграммы
        }
        
        // MARK: - Base Screen Size (для масштабирования)
        static let baseScreenWidth: CGFloat = 660 // Размер фрейма в Figma (660x1434)
        static let baseScreenHeight: CGFloat = 1434 // Высота фрейма в Figma
    }
    
    // MARK: - History Screen Design Constants
    struct HistoryScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")
            static let textBlue = Color(hex: "286196")
        }
        
        // MARK: - Typography
        struct Typography {
            // Заголовок "Мой дневник"
            static let titleSize: CGFloat = 22
            static let titleFontName = "Helvetica Neue Light"
            
            // Кнопка "Назад"
            static let backButtonSize: CGFloat = 22
            static let backButtonFontName = "Helvetica Neue Light"
            
            // Вопрос пользователя
            static let questionSize: CGFloat = 22
            static let questionFontName = "Helvetica Neue Light"
            
            // Название/ключевая фраза в списке
            static let readingTitleSize: CGFloat = 22
            static let readingTitleFontName = "Helvetica Neue Light"
            
            // Дата
            static let dateSize: CGFloat = 22
            static let dateFontName = "Roboto Mono Thin"
            
            // Пустое состояние
            static let emptyStateSize: CGFloat = 22
            static let emptyStateFontName = "Helvetica Neue Light"
        }
        
        // MARK: - Spacing
        struct Spacing {
            // Горизонтальные отступы
            static let horizontalPadding: CGFloat = 48
            
            // Заголовок
            static let headerTop: CGFloat = 40
            static let headerBottom: CGFloat = 40
            static let headerHorizontalPadding: CGFloat = 48
            
            // Элементы списка
            static let listTop: CGFloat = 20
            static let listBottom: CGFloat = 40
            static let itemSpacing: CGFloat = 40
            static let itemVerticalPadding: CGFloat = 20
            
            // Пустое состояние
            static let emptyStateSpacing: CGFloat = 0
        }
        
        // MARK: - Base Screen Size
        static let baseScreenWidth: CGFloat = 660
        static let baseScreenHeight: CGFloat = 1434
    }
    
    // MARK: - Tutorial Screen Design Constants
    struct TutorialScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")
            static let textBlue = Color(hex: "286196")
            static let buttonTextColor = Color(hex: "FF3636") // Красный для кнопок
        }
        
        // MARK: - Typography
        struct Typography {
            // Заголовок страницы
            static let titleSize: CGFloat = 22
            static let titleFontName = "Roboto Mono Thin"
            
            // Основной текст
            static let bodySize: CGFloat = 22
            static let bodyFontName = "Helvetica Neue Light"
            
            // Кнопки навигации
            static let buttonSize: CGFloat = 36
            static let buttonFontName = "Roboto Mono Light"
            
            // Кнопка "Начать"
            static let startButtonSize: CGFloat = 36
            static let startButtonFontName = "Roboto Mono Light"
        }
        
        // MARK: - Spacing (точные значения из Figma 660×1434)
        struct Spacing {
            // Вертикальные отступы
            static let topToVisual: CGFloat = 200 // От верха до визуализации
            static let visualToTitle: CGFloat = 60 // От визуализации до заголовка
            static let titleToContent: CGFloat = 20 // От заголовка до текста
            static let contentToNavigation: CGFloat = 80 // От текста до навигации
            
            // Горизонтальные отступы
            static let horizontalPadding: CGFloat = 60 // Для заголовка и текста
            static let navigationHorizontalPadding: CGFloat = 60 // Для навигации
            
            // Навигация
            static let navigationBottom: CGFloat = 60 // От навигации до низа
            static let navigationSpacing: CGFloat = 30 // Между элементами навигации
            static let indicatorSpacing: CGFloat = 8 // Между индикаторами страниц
            
            // Визуализация
            static let visualHeight: CGFloat = 200 // Высота визуализации
        }
        
        // MARK: - Base Screen Size (для масштабирования)
        static let baseScreenWidth: CGFloat = 660 // Размер фрейма в Figma (660x1434)
        static let baseScreenHeight: CGFloat = 1434 // Высота фрейма в Figma
    }
    
    // MARK: - Reading Detail Screen Design Constants
    struct ReadingDetailScreen {
        // MARK: - Colors
        struct Colors {
            static let backgroundBeige = Color(hex: "EFE7D4")
            static let textBlue = Color(hex: "286196")
        }
        
        // MARK: - Typography
        struct Typography {
            // Заголовок "Расклад"
            static let titleSize: CGFloat = 22
            static let titleFontName = "Helvetica Neue Light"
            
            // Кнопка "Назад"
            static let backButtonSize: CGFloat = 22
            static let backButtonFontName = "Helvetica Neue Light"
            
            // Заголовки секций (дата, вопрос, гексаграмма, интерпретация и т.д.)
            static let sectionLabelSize: CGFloat = 22
            static let sectionLabelFontName = "Roboto Mono Thin"
            
            // Основной текст (вопрос, интерпретация, заметки)
            static let bodySize: CGFloat = 22
            static let bodyFontName = "Helvetica Neue Light"
            
            // Поля ввода
            static let inputSize: CGFloat = 22
            static let inputFontName = "Helvetica Neue Light"
            
            // Кнопка удаления
            static let deleteButtonSize: CGFloat = 22
            static let deleteButtonFontName = "Helvetica Neue Light"
        }
        
        // MARK: - Spacing
        struct Spacing {
            // Горизонтальные отступы
            static let horizontalPadding: CGFloat = 48
            
            // Заголовок
            static let headerTop: CGFloat = 40
            static let headerBottom: CGFloat = 40
            static let headerHorizontalPadding: CGFloat = 48
            
            // Контент
            static let contentTop: CGFloat = 20
            static let contentBottom: CGFloat = 40
            static let sectionSpacing: CGFloat = 40
            static let sectionLabelBottom: CGFloat = 20
            static let paragraphSpacing: CGFloat = 20
            
            // Поля ввода
            static let inputTop: CGFloat = 20
            static let inputBottom: CGFloat = 40
            static let inputInternalPadding: CGFloat = 12
            
            // Кнопка удаления
            static let deleteButtonTop: CGFloat = 40
            static let deleteButtonBottom: CGFloat = 40
        }
        
        // MARK: - Base Screen Size
        static let baseScreenWidth: CGFloat = 660
        static let baseScreenHeight: CGFloat = 1434
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


