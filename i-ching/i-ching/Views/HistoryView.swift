import SwiftUI

struct HistoryView: View {
    @State private var readings: [Reading] = []
    @State private var selectedReading: Reading?
    @State private var showDetail = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Заголовок
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Назад")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 40)
                    
                    Spacer()
                    
                    Text("Мой дневник")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Заглушка для симметрии
                    Text("Назад")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.clear)
                        .padding(.trailing, 40)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                if readings.isEmpty {
                    Spacer()
                    Text("Пока нет сохраненных раскладов")
                        .font(.system(size: 14, weight: .ultraLight))
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 30) {
                            ForEach(readings.reversed()) { reading in
                                ReadingRow(reading: reading, dateFormatter: dateFormatter)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedReading = reading
                                        showDetail = true
                                    }
                            }
                        }
                        .padding(.horizontal, 60)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .onAppear {
            loadReadings()
        }
        .onChange(of: showDetail) { _, newValue in
            if !newValue {
                // Обновляем список при закрытии детального просмотра
                loadReadings()
            }
        }
        .sheet(isPresented: $showDetail) {
            if let reading = selectedReading {
                NavigationView {
                    ReadingDetailView(reading: reading, onDismiss: {
                        showDetail = false
                        loadReadings()
                    })
                    .navigationBarHidden(true)
                }
            } else {
                Text("Ошибка загрузки")
                    .font(.system(size: 16, weight: .light))
            }
        }
    }
    
    private func loadReadings() {
        readings = StorageService.shared.loadReadings()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }
}

struct ReadingRow: View {
    let reading: Reading
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Мини-превью гексаграммы
            HStack {
                // Здесь будет мини-превью гексаграмм (можно добавить позже)
                Spacer()
            }
            .padding(.bottom, 8)
            
            // Ключевая фраза или название
            Text(reading.summary ?? reading.hexagramName)
                .font(.system(size: 16, weight: .light))
                .foregroundColor(.black)
                .lineLimit(2)
            
            // Дата
            Text(dateFormatter.string(from: reading.date))
                .font(.system(size: 12, weight: .ultraLight))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

