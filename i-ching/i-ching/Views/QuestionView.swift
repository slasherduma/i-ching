import SwiftUI
import UIKit

// MARK: - Custom UITextView Wrapper for Multiline Input with Done Key
struct MultilineTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    var font: UIFont
    var textColor: UIColor
    var placeholder: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.textColor = textColor
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        
        // Disable autocorrection
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .sentences
        textView.smartDashesType = .no
        textView.smartQuotesType = .no
        textView.smartInsertDeleteType = .no
        textView.spellCheckingType = .no
        
        // Set Return key as Done
        textView.returnKeyType = .done
        textView.enablesReturnKeyAutomatically = true
        
        // No accessory toolbar - only use system keyboard Done button
        textView.inputAccessoryView = nil
        
        // Debug marker
        textView.accessibilityIdentifier = "QuestionViewKeyboardTextView_USED"
        #if DEBUG
        print("✅ QuestionView UITextView makeUIView used")
        #endif
        
        context.coordinator.textView = textView
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Update text only if changed externally
        if uiView.text != text {
            uiView.text = text
        }
        
        // Update reference
        context.coordinator.textView = uiView
        
        // Maintain settings
        uiView.font = font
        uiView.textColor = textColor
        uiView.autocorrectionType = .no
        uiView.autocapitalizationType = .sentences
        uiView.smartDashesType = .no
        uiView.smartQuotesType = .no
        uiView.smartInsertDeleteType = .no
        uiView.spellCheckingType = .no
        
        // Ensure Return key is Done
        uiView.returnKeyType = .done
        uiView.enablesReturnKeyAutomatically = true
        
        // Ensure delegate is set
        uiView.delegate = context.coordinator
        
        // No accessory toolbar - only use system keyboard Done button
        uiView.inputAccessoryView = nil
        
        // Manage first responder - делаем это асинхронно, чтобы избежать модификации состояния во время обновления вида
        if isFocused && !uiView.isFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        } else if !isFocused && uiView.isFirstResponder {
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }
        
        #if DEBUG
        print("✅ QuestionView UITextView updateUIView used")
        #endif
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: MultilineTextField
        weak var textView: UITextView?
        
        init(_ parent: MultilineTextField) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
                if !self.parent.isFocused {
                    self.parent.isFocused = true
                }
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.text = textView.text
            }
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            // Handle Return key (Done)
            if text == "\n" {
                #if DEBUG
                print("✅ Return key pressed - shouldChangeTextIn fired")
                #endif
                // Immediately prevent newline insertion
                // Close keyboard after delegate returns to avoid focus bounce
                DispatchQueue.main.async {
                    self.parent.isFocused = false
                    textView.resignFirstResponder()
                }
                return false // Prevent newline insertion
            }
            return true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            #if DEBUG
            print("✅ textViewDidEndEditing called")
            #endif
            DispatchQueue.main.async {
                self.parent.isFocused = false
            }
        }
    }
}

struct QuestionView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var question: String = ""
    @State private var isTextFieldFocused: Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var swipeProgress: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            let bottomPadding = DesignConstants.Layout.ctaSafeBottomPadding
            VStack(spacing: 0) {
                // Отступ сверху до заголовка
                Spacer()
                    .frame(height: scaledValue(DesignConstants.QuestionScreen.Spacing.topToTitle, for: geometry, isVertical: true))
                
                // Заголовок "СФОРМУЛИРУЙТЕ ВОПРОС"
                Text("СФОРМУЛИРУЙТЕ ВОПРОС")
                        .font(robotoMonoLightFont(size: scaledFontSize(DesignConstants.CoinsScreen.Typography.buttonTextSize, for: geometry)))
                        .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                        .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, scaledValue(DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding, for: geometry, isVertical: true))
                
                // Отступ от заголовка до параграфа (уменьшен на 20%)
                Spacer()
                    .frame(height: scaledValue((DesignConstants.QuestionScreen.Spacing.titleToFirstParagraph + DesignConstants.QuestionScreen.Spacing.betweenParagraphs) * 0.8, for: geometry, isVertical: true))
                
                // Параграф
                Text("Формулировка не влияет на ответ.\nВажно лишь удерживать вопрос в сознании во время броска монет")
                        .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.QuestionScreen.Typography.paragraphSize, for: geometry)))
                        .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue)
                        .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                
                // Отступ от второго параграфа до поля ввода
                Spacer()
                    .frame(height: scaledValue(DesignConstants.QuestionScreen.Spacing.secondParagraphToInput, for: geometry, isVertical: true))
                
                // Поле ввода с placeholder
                ZStack(alignment: .center) {
                        MultilineTextField(
                            text: $question,
                            isFocused: $isTextFieldFocused,
                            font: UIFont(name: "HelveticaNeue-Light", size: scaledFontSize(DesignConstants.QuestionScreen.Typography.placeholderSize, for: geometry)) ?? .systemFont(ofSize: scaledFontSize(DesignConstants.QuestionScreen.Typography.placeholderSize, for: geometry), weight: .light),
                            textColor: UIColor(DesignConstants.QuestionScreen.Colors.textBlue),
                            placeholder: "Запишите ваш вопрос здесь, чтобы потом легко найти его в дневнике..."
                        )
                        .frame(minHeight: 60, maxHeight: 200)
                        .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                        
                        // Кастомный placeholder, который виден на всех устройствах
                        // Показываем placeholder когда поле пустое (даже при фокусе, чтобы пользователь понимал, что можно вводить)
                        Text("Запишите ваш вопрос здесь, чтобы потом легко найти его в дневнике...")
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.QuestionScreen.Typography.placeholderSize, for: geometry)))
                            .foregroundColor(DesignConstants.QuestionScreen.Colors.textBlue.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, scaledValue(DesignConstants.QuestionScreen.Spacing.contentHorizontalPadding, for: geometry))
                            .opacity(question.isEmpty ? 1 : 0)
                            .allowsHitTesting(false)
                            .accessibilityHidden(!question.isEmpty)
                }
                
                // Гибкий отступ для выталкивания контента вверх
                Spacer()
            }
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
            .overlay(alignment: .top) {
                MenuBarView(geometry: geometry, onDismiss: { navigationManager.popToRoot() })
                    .environmentObject(navigationManager)
            }
            .overlay(alignment: .bottom) {
                BottomBar.dual(
                    leftTitle: "ПРОПУСТИТЬ",
                    leftIsDisabled: false,
                    leftAction: {
                        navigationManager.navigate(to: .coins(question: question.isEmpty ? nil : question))
                    },
                    rightTitle: "БРОСИТЬ МОНЕТЫ",
                    rightIsDisabled: false,
                    rightAction: {
                        navigationManager.navigate(to: .coins(question: question.isEmpty ? nil : question))
                    },
                    lift: DesignConstants.Layout.ctaLiftSticky,
                    geometry: geometry
                )
                .padding(.bottom, bottomPadding)
            }
            .overlay(
                // Затемнение при свайпе
                Color.black.opacity(swipeProgress * 0.3)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
            )
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        // Проверяем, что свайп начинается от левого края (в пределах 30 пикселей)
                        if value.startLocation.x < 30 && value.translation.width > 0 {
                            // Ограничиваем прогресс от 0 до 1
                            swipeProgress = min(1.0, value.translation.width / 200)
                        }
                    }
                    .onEnded { value in
                        // Если свайп достаточно длинный (больше 100 пикселей), закрываем экран
                        if value.startLocation.x < 30 && value.translation.width > 100 {
                            navigationManager.pop()
                        } else {
                            // Иначе возвращаем затемнение в исходное состояние
                            withAnimation(.spring()) {
                                swipeProgress = 0
                            }
                        }
                    }
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // MARK: - Helper Functions
    
    /// Создает шрифт Druk Wide Cyr Medium для заголовка и кнопок
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
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .medium)
    }
    
    /// Создает шрифт Roboto Mono Light
    private func robotoMonoLightFont(size: CGFloat) -> Font {
        let fontNames = [
            "Roboto Mono Light",
            "RobotoMono-Light",
            "RobotoMonoLight",
            "RobotoMono-VariableFont_wght",
            "Roboto Mono",
            "RobotoMono"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        return .system(size: size, weight: .light, design: .monospaced)
    }
    
    /// Создает шрифт Roboto Mono Thin для параграфов
    private func robotoMonoThinFont(size: CGFloat) -> Font {
        // Пробуем разные варианты имен для variable font
        let fontNames = [
            "Roboto Mono",
            "RobotoMono",
            "RobotoMono-VariableFont_wght",
            "RobotoMono Variable",
            "Roboto Mono Variable",
            "Roboto Mono Thin",
            "RobotoMono-Thin",
            "RobotoMonoThin"
        ]
        
        // Проверяем все доступные шрифты в системе для отладки
        #if DEBUG
        let availableFonts = UIFont.familyNames.filter { $0.contains("Roboto") || $0.contains("roboto") }
        if !availableFonts.isEmpty {
            print("Available Roboto fonts: \(availableFonts)")
            for family in availableFonts {
                let fonts = UIFont.fontNames(forFamilyName: family)
                print("  Family '\(family)': \(fonts)")
            }
        }
        #endif
        
        for fontName in fontNames {
            if let font = UIFont(name: fontName, size: size) {
                #if DEBUG
                print("Found Roboto Mono font: \(fontName)")
                #endif
                return .custom(fontName, size: size)
            }
        }
        
        // Если не нашли, пробуем найти через семейство
        if let robotoFamily = UIFont.familyNames.first(where: { $0.lowercased().contains("roboto") && $0.lowercased().contains("mono") }) {
            let fonts = UIFont.fontNames(forFamilyName: robotoFamily)
            if let firstFont = fonts.first {
                #if DEBUG
                print("Using Roboto Mono from family: \(robotoFamily), font: \(firstFont)")
                #endif
                return .custom(firstFont, size: size)
            }
        }
        
        // Fallback на системный моноширинный шрифт
        #if DEBUG
        print("Roboto Mono not found, using system monospaced font")
        #endif
        return .system(size: size, weight: .ultraLight, design: .monospaced)
    }
    
    /// Создает шрифт Helvetica Neue Light для placeholder
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
        
        // Fallback на системный шрифт
        return .system(size: size, weight: .light)
    }


    
    
    /// Масштабирует значение относительно базового размера экрана
    /// Использует фиксированные размеры экрана, чтобы размеры не менялись при появлении клавиатуры
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let scaleFactor: CGFloat
        if isVertical {
            // Для вертикальных отступов используем высоту экрана (без учета клавиатуры)
            // Если значение относится к CoinsScreen, используем его базовые размеры
            if value == DesignConstants.CoinsScreen.Spacing.buttonToBottom || value == DesignConstants.CoinsScreen.Spacing.buttonVerticalPadding {
                scaleFactor = screenSize.height / DesignConstants.CoinsScreen.baseScreenHeight
            } else {
                scaleFactor = screenSize.height / DesignConstants.QuestionScreen.baseScreenHeight
            }
        } else {
            // Для горизонтальных отступов используем ширину экрана
            // Если значение относится к CoinsScreen, используем его базовые размеры
            if value == 40 {
                // Для отступов 40px используем базовые размеры CoinsScreen
                scaleFactor = screenSize.width / DesignConstants.CoinsScreen.baseScreenWidth
            } else {
                scaleFactor = screenSize.width / DesignConstants.QuestionScreen.baseScreenWidth
            }
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    /// Использует фиксированные размеры экрана, чтобы шрифты не менялись при появлении клавиатуры
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        // Вычисляем коэффициенты масштабирования по ширине и высоте экрана
        // Если размер относится к CoinsScreen, используем его базовые размеры
        let widthScaleFactor: CGFloat
        let heightScaleFactor: CGFloat
        
        if size == DesignConstants.CoinsScreen.Typography.buttonTextSize {
            widthScaleFactor = screenSize.width / DesignConstants.CoinsScreen.baseScreenWidth
            heightScaleFactor = screenSize.height / DesignConstants.CoinsScreen.baseScreenHeight
        } else {
            widthScaleFactor = screenSize.width / DesignConstants.QuestionScreen.baseScreenWidth
            heightScaleFactor = screenSize.height / DesignConstants.QuestionScreen.baseScreenHeight
        }
        
        // Используем минимальный коэффициент для сохранения пропорций макета
        // Это гарантирует, что шрифты будут соответствовать пропорциям исходного макета
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        
        return size * scaleFactor
    }
}
