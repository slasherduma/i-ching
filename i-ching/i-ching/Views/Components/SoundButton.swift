import SwiftUI

// Функция-хелпер для добавления звука к action кнопки
func withButtonSound(_ action: @escaping () -> Void) -> () -> Void {
    return {
        ButtonSoundService.shared.playRandomSound()
        action()
    }
}

// Кастомная кнопка, которая автоматически воспроизводит звук при нажатии
struct SoundButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label
    
    init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = withButtonSound(action)
        self.label = label
    }
    
    var body: some View {
        Button(action: action, label: label)
    }
}

// Extension для удобного использования с текстом
extension SoundButton where Label == Text {
    init(_ title: String, action: @escaping () -> Void) {
        self.action = withButtonSound(action)
        self.label = { Text(title) }
    }
}
