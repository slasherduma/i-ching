import SwiftUI

struct ReadingDetailView: View {
    let reading: Reading
    let onDismiss: (() -> Void)?
    @State private var userNotes: String = ""
    @State private var outcome: String = ""
    @State private var showDeleteConfirmation = false
    
    init(reading: Reading, onDismiss: (() -> Void)? = nil) {
        self.reading = reading
        self.onDismiss = onDismiss
    }
    
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
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Button(action: {
                        onDismiss?()
                    }) {
                        Text("Назад")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 40)
                    
                    Spacer()
                    
                    Text("Расклад")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("Назад")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.clear)
                        .padding(.trailing, 40)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        // Дата
                        Text(dateFormatter.string(from: reading.date))
                            .font(.system(size: 12, weight: .ultraLight))
                            .foregroundColor(.gray)
                            .padding(.horizontal, 60)
                            .padding(.top, 20)
                        
                        // Вопрос
                        if let question = reading.question, !question.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Вопрос")
                                    .font(.system(size: 12, weight: .ultraLight))
                                    .foregroundColor(.gray)
                                
                                Text(question)
                                    .font(.system(size: 16, weight: .light))
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 60)
                        }
                        
                        // Гексаграмма
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Гексаграмма")
                                .font(.system(size: 12, weight: .ultraLight))
                                .foregroundColor(.gray)
                            
                            Text("\(reading.hexagramNumber). \(reading.hexagramName)")
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 60)
                        
                        // Интерпретация
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Интерпретация")
                                .font(.system(size: 12, weight: .ultraLight))
                                .foregroundColor(.gray)
                            
                            Text(reading.interpretation)
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(.black)
                                .lineSpacing(6)
                        }
                        .padding(.horizontal, 60)
                        
                        // Заметки пользователя
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Мои заметки")
                                .font(.system(size: 12, weight: .ultraLight))
                                .foregroundColor(.gray)
                            
                            TextField("Добавь свои мысли...", text: $userNotes, axis: .vertical)
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.black)
                                .lineLimit(5...10)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 60)
                        
                        // Как потом всё сложилось?
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Как потом всё сложилось?")
                                .font(.system(size: 12, weight: .ultraLight))
                                .foregroundColor(.gray)
                            
                            TextField("Опиши, что произошло...", text: $outcome, axis: .vertical)
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.black)
                                .lineLimit(5...10)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 60)
                        .padding(.bottom, 40)
                        
                        // Кнопка удаления
                        Button(action: {
                            showDeleteConfirmation = true
                        }) {
                            Text("Удалить")
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 60)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .onAppear {
            userNotes = reading.userNotes ?? ""
            outcome = reading.outcome ?? ""
        }
        .onDisappear {
            saveChanges()
        }
        .alert("Удалить расклад?", isPresented: $showDeleteConfirmation) {
            Button("Отмена", role: .cancel) { }
            Button("Удалить", role: .destructive) {
                deleteReading()
            }
        }
    }
    
    private func saveChanges() {
        let updatedReading = reading.updated(
            userNotes: userNotes.isEmpty ? nil : userNotes,
            tags: nil, // Теги убраны из MVP
            outcome: outcome.isEmpty ? nil : outcome
        )
        
        StorageService.shared.updateReading(updatedReading)
    }
    
    private func deleteReading() {
        StorageService.shared.deleteReading(reading)
        onDismiss?()
    }
}

