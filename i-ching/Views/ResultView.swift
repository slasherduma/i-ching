import SwiftUI

struct ResultView: View {
    let hexagram: Hexagram
    let lines: [Line]
    let question: String?
    @State private var showStart = false
    @State private var savedDate: Date = Date()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Дата и время
                Text(dateFormatter.string(from: savedDate))
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.gray)
                
                // Миниатюра гексаграммы
                VStack(spacing: 6) {
                    ForEach(Array(lines.reversed()), id: \.id) { line in
                        LineView(line: line)
                            .scaleEffect(0.6)
                    }
                }
                .padding(.vertical, 20)
                
                Text("\(hexagram.number). \(hexagram.name)")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.black)
                
                Spacer()
                
                HStack(spacing: 30) {
                    Button(action: {
                        saveReading()
                    }) {
                        Text("Сохранить")
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
                        showStart = true
                    }) {
                        Text("Новый вопрос")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showStart) {
            StartView()
        }
    }
    
    private func saveReading() {
        let reading = Reading(
            date: Date(),
            question: question,
            hexagram: hexagram,
            lines: lines
        )
        StorageService.shared.saveReading(reading)
        
        // Простая обратная связь
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showStart = true
        }
    }
}

