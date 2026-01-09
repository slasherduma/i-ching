import SwiftUI
import UIKit
import QuartzCore

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
        
        // Проверяем, не истекло ли время подавления
        if context.coordinator.suppressNextFocus && CACurrentMediaTime() >= context.coordinator.suppressUntil {
            context.coordinator.suppressNextFocus = false
        }
        
        // Принудительное управление first responder с защитой от re-focus
        if isFirstResponder == true && !uiView.isFirstResponder {
            // ANTI-BOUNCE: запрещаем мгновенный re-focus после Done
            if context.coordinator.suppressNextFocus && CACurrentMediaTime() < context.coordinator.suppressUntil {
                #if DEBUG
                print("🔒 updateUIView: Suppressed becomeFirstResponder (suppress until: \(context.coordinator.suppressUntil), current: \(CACurrentMediaTime()))")
                #endif
                return
            }
            #if DEBUG
            print("✅ updateUIView: Calling becomeFirstResponder (isFirstResponder=\(isFirstResponder))")
            #endif
            uiView.becomeFirstResponder()
        } else if isFirstResponder == false && uiView.isFirstResponder {
            #if DEBUG
            print("✅ updateUIView: Calling resignFirstResponder (isFirstResponder=\(isFirstResponder))")
            #endif
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: KeyboardTextView
        weak var textView: UITextView?
        
        // ANTI-BOUNCE: флаги подавления мгновенного re-focus
        var suppressNextFocus = false
        var suppressUntil: CFTimeInterval = 0
        
        init(_ parent: KeyboardTextView) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            // Обновляем состояние first responder при начале редактирования
            #if DEBUG
            print("✅ textViewDidBeginEditing: Setting isFirstResponder = true")
            #endif
            parent.isFirstResponder = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            // Синхронизация: при завершении редактирования сбрасываем флаг
            #if DEBUG
            print("✅ textViewDidEndEditing: Setting isFirstResponder = false")
            #endif
            parent.isFirstResponder = false
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
            #if DEBUG
            print("✅ handleDone: Closing keyboard, setting suppressNextFocus")
            #endif
            parent.isFirstResponder = false
            suppressNextFocus = true
            suppressUntil = CACurrentMediaTime() + 0.25
            textView?.resignFirstResponder()
        }
    }
}

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
                
                HStack(spacing: 30) {
                    Button(action: {
                        showCoins = true
                    }) {
                        Text("Продолжить")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        showCoins = true
                    }) {
                        Text("Пропустить")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showCoins) {
            CoinsView(question: question.isEmpty ? nil : question)
        }
    }
}
