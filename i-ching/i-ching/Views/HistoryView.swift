import SwiftUI

struct HistoryView: View {
    @State private var readings: [Reading] = []
    @State private var selectedReading: Reading?
    @State private var showDetail = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                DesignConstants.HistoryScreen.Colors.backgroundBeige
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Заголовок
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Назад")
                                .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.HistoryScreen.Typography.backButtonSize, for: geometry)))
                                .foregroundColor(DesignConstants.HistoryScreen.Colors.textBlue)
                        }
                        .padding(.leading, scaledValue(DesignConstants.HistoryScreen.Spacing.headerHorizontalPadding, for: geometry))
                        
                        Spacer()
                        
                        Text("Мой дневник")
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.HistoryScreen.Typography.titleSize, for: geometry)))
                            .foregroundColor(DesignConstants.HistoryScreen.Colors.textBlue)
                        
                        Spacer()
                        
                        // Заглушка для симметрии
                        Text("Назад")
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.HistoryScreen.Typography.backButtonSize, for: geometry)))
                            .foregroundColor(.clear)
                            .padding(.trailing, scaledValue(DesignConstants.HistoryScreen.Spacing.headerHorizontalPadding, for: geometry))
                    }
                    .padding(.top, scaledValue(DesignConstants.HistoryScreen.Spacing.headerTop, for: geometry, isVertical: true))
                    .padding(.bottom, scaledValue(DesignConstants.HistoryScreen.Spacing.headerBottom, for: geometry, isVertical: true))
                    
                    if readings.isEmpty {
                        Spacer()
                        Text("Пока нет сохраненных раскладов")
                            .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.HistoryScreen.Typography.emptyStateSize, for: geometry)))
                            .foregroundColor(DesignConstants.HistoryScreen.Colors.textBlue.opacity(0.6))
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 0) {
                                let reversedReadings = Array(readings.reversed())
                                ForEach(Array(reversedReadings.enumerated()), id: \.element.id) { index, reading in
                                    ReadingRow(reading: reading, dateFormatter: dateFormatter, geometry: geometry)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            selectedReading = reading
                                            showDetail = true
                                        }
                                        .padding(.bottom, index < reversedReadings.count - 1 ? scaledValue(DesignConstants.HistoryScreen.Spacing.itemSpacing, for: geometry, isVertical: true) : 0)
                                }
                            }
                            .padding(.horizontal, scaledValue(DesignConstants.HistoryScreen.Spacing.horizontalPadding, for: geometry))
                            .padding(.top, scaledValue(DesignConstants.HistoryScreen.Spacing.listTop, for: geometry, isVertical: true))
                            .padding(.bottom, scaledValue(DesignConstants.HistoryScreen.Spacing.listBottom, for: geometry, isVertical: true))
                        }
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
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ReturnToStartView"))) { _ in
            // Закрываем экран при получении уведомления о возврате на стартовый экран
            // Используем transaction без анимации для мгновенного закрытия
            var transaction = Transaction(animation: .none)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                dismiss()
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
    
    // MARK: - Helper Functions
    
    /// Создает шрифт Helvetica Neue Light
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
    
    /// Создает шрифт Roboto Mono Thin
    private func robotoMonoThinFont(size: CGFloat) -> Font {
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
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        return .system(size: size, weight: .ultraLight, design: .monospaced)
    }
    
    /// Масштабирует значение относительно базового размера экрана
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.HistoryScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.HistoryScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let widthScaleFactor = geometry.size.width / DesignConstants.HistoryScreen.baseScreenWidth
        let heightScaleFactor = geometry.size.height / DesignConstants.HistoryScreen.baseScreenHeight
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
    }
}

struct ReadingRow: View {
    let reading: Reading
    let dateFormatter: DateFormatter
    let geometry: GeometryProxy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Вопрос пользователя (если есть)
            if let question = reading.question, !question.isEmpty {
                Text(question)
                    .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.HistoryScreen.Typography.questionSize, for: geometry)))
                    .foregroundColor(DesignConstants.HistoryScreen.Colors.textBlue)
                    .lineLimit(2)
                    .padding(.bottom, scaledValue(DesignConstants.HistoryScreen.Spacing.itemVerticalPadding, for: geometry, isVertical: true))
            }
            
            // Ключевая фраза или название
            Text(reading.summary ?? reading.hexagramName)
                .font(helveticaNeueLightFont(size: scaledFontSize(DesignConstants.HistoryScreen.Typography.readingTitleSize, for: geometry)))
                .foregroundColor(DesignConstants.HistoryScreen.Colors.textBlue)
                .lineLimit(2)
                .padding(.bottom, scaledValue(DesignConstants.HistoryScreen.Spacing.itemVerticalPadding, for: geometry, isVertical: true))
            
            // Дата
            Text(dateFormatter.string(from: reading.date))
                .font(robotoMonoThinFont(size: scaledFontSize(DesignConstants.HistoryScreen.Typography.dateSize, for: geometry)))
                .foregroundColor(DesignConstants.HistoryScreen.Colors.textBlue.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Создает шрифт Helvetica Neue Light
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
    
    /// Создает шрифт Roboto Mono Thin
    private func robotoMonoThinFont(size: CGFloat) -> Font {
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
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: size) != nil {
                return .custom(fontName, size: size)
            }
        }
        
        return .system(size: size, weight: .ultraLight, design: .monospaced)
    }
    
    /// Масштабирует значение относительно базового размера экрана
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.HistoryScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.HistoryScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
    
    /// Масштабирует размер шрифта пропорционально размерам экрана
    private func scaledFontSize(_ size: CGFloat, for geometry: GeometryProxy) -> CGFloat {
        let widthScaleFactor = geometry.size.width / DesignConstants.HistoryScreen.baseScreenWidth
        let heightScaleFactor = geometry.size.height / DesignConstants.HistoryScreen.baseScreenHeight
        let scaleFactor = min(widthScaleFactor, heightScaleFactor)
        return size * scaleFactor
    }
}
