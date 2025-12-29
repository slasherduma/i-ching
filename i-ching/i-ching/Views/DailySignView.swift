import SwiftUI

struct DailySignView: View {
    @State private var hexagram: Hexagram?
    @State private var lines: [Line] = []
    @State private var isGenerating = false
    @State private var showResult = false
    @State private var showHistory = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                if isGenerating {
                    // Индикатор генерации
                    VStack(spacing: 20) {
                        Text("Генерация знака дня...")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.gray)
                    }
                } else if let hexagram = hexagram {
                    // Результат
                    VStack(spacing: 40) {
                        // Гексаграмма
                        VStack(spacing: 12) {
                            ForEach(Array(lines.reversed()), id: \.id) { line in
                                LineView(line: line)
                            }
                        }
                        .padding(.bottom, 40)
                        
                        // Иероглиф
                        Text(hexagram.character)
                            .font(.system(size: 80))
                            .padding(.bottom, 40)
                        
                        // Название
                        Text(hexagram.name)
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                        
                        // Краткая рекомендация
                        if let keyPhrase = hexagram.keyPhrase {
                            Text(keyPhrase)
                                .font(.system(size: 16, weight: .ultraLight))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 60)
                                .padding(.bottom, 20)
                        }
                        
                        Text(hexagram.interpretation)
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(.horizontal, 60)
                    }
                    .padding(.vertical, 40)
                } else {
                    // Начальный экран
                    VStack(spacing: 40) {
                        Text("Знак дня")
                            .font(.system(size: 24, weight: .ultraLight))
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                        
                        Text("Краткое гадание для настрой на день")
                            .font(.system(size: 14, weight: .ultraLight))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 60)
                            .padding(.bottom, 40)
                        
                        Button(action: {
                            generateDailySign()
                        }) {
                            Text("Получить знак")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.black)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 12)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                        .disabled(isGenerating)
                    }
                }
                
                Spacer()
                
                // Кнопки
                if hexagram != nil {
                    HStack(spacing: 30) {
                        Button(action: {
                            saveToHistory()
                        }) {
                            Text("Сохранить в дневник")
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
                            dismiss()
                        }) {
                            Text("Закрыть")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 60)
                } else {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Назад")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 60)
                }
            }
        }
        .fullScreenCover(isPresented: $showHistory) {
            HistoryView()
        }
    }
    
    private func generateDailySign() {
        isGenerating = true
        
        // Небольшая задержка для UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Генерируем 6 линий автоматически
            var generatedLines: [Line] = []
            for i in 1...6 {
                let isYang = Bool.random()
                let isChanging = Bool.random() && Bool.random() // Реже меняющиеся линии
                generatedLines.append(Line(
                    isYang: isYang,
                    isChanging: isChanging,
                    position: i
                ))
            }
            
            if let hexagram = Hexagram.find(byLines: generatedLines) {
                self.lines = generatedLines
                self.hexagram = hexagram
            } else {
                // Fallback
                let fallback = Hexagram.loadAll().first!
                self.hexagram = fallback
            }
            
            isGenerating = false
            showResult = true
        }
    }
    
    private func saveToHistory() {
        guard let hexagram = hexagram else { return }
        
        let secondHexagram = Hexagram.findSecond(byLines: lines)
        let reading = Reading(
            date: Date(),
            question: nil, // Знак дня без вопроса
            hexagram: hexagram,
            lines: lines,
            secondHexagram: secondHexagram
        )
        
        StorageService.shared.saveReading(reading)
        
        // Показываем подтверждение
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dismiss()
        }
    }
}

