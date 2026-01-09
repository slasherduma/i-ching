import SwiftUI

struct HandAnimationView: View {
    let isThrowing: Bool
    let geometry: GeometryProxy
    let onTap: (() -> Void)? // Обработчик тапа
    
    @State private var currentFrame: Int = 1 // 1 или 2 для петли, 3 для броска, 4 для стоп-кадра
    @State private var animationTimer: Timer?
    @State private var hasCompletedThrow: Bool = false // Флаг завершения броска
    @State private var returnToLoopTask: DispatchWorkItem? // Задача возврата к петле
    
    var body: some View {
        ZStack {
            // Прозрачный фон для обработки тапов в области руки
            // Используем максимальную область всех кадров для покрытия всей области руки
            let maxX = max(
                max(DesignConstants.CoinsScreen.HandAnimation.Frame1.x + DesignConstants.CoinsScreen.HandAnimation.Frame1.width,
                    DesignConstants.CoinsScreen.HandAnimation.Frame2.x + DesignConstants.CoinsScreen.HandAnimation.Frame2.width),
                max(DesignConstants.CoinsScreen.HandAnimation.Frame3.x + DesignConstants.CoinsScreen.HandAnimation.Frame3.width,
                    DesignConstants.CoinsScreen.HandAnimation.Frame4.x + DesignConstants.CoinsScreen.HandAnimation.Frame4.width)
            )
            let minX = min(
                min(DesignConstants.CoinsScreen.HandAnimation.Frame1.x,
                    DesignConstants.CoinsScreen.HandAnimation.Frame2.x),
                min(DesignConstants.CoinsScreen.HandAnimation.Frame3.x,
                    DesignConstants.CoinsScreen.HandAnimation.Frame4.x)
            )
            let maxY = max(
                max(DesignConstants.CoinsScreen.HandAnimation.Frame1.y + DesignConstants.CoinsScreen.HandAnimation.Frame1.height,
                    DesignConstants.CoinsScreen.HandAnimation.Frame2.y + DesignConstants.CoinsScreen.HandAnimation.Frame2.height),
                max(DesignConstants.CoinsScreen.HandAnimation.Frame3.y + DesignConstants.CoinsScreen.HandAnimation.Frame3.height,
                    DesignConstants.CoinsScreen.HandAnimation.Frame4.y + DesignConstants.CoinsScreen.HandAnimation.Frame4.height)
            )
            let minY = min(
                min(DesignConstants.CoinsScreen.HandAnimation.Frame1.y,
                    DesignConstants.CoinsScreen.HandAnimation.Frame2.y),
                min(DesignConstants.CoinsScreen.HandAnimation.Frame3.y,
                    DesignConstants.CoinsScreen.HandAnimation.Frame4.y)
            )
            
            // Прозрачный Rectangle, покрывающий область руки
            Color.clear
                .frame(
                    width: scaledValue(maxX - minX, for: geometry),
                    height: scaledValue(maxY - minY, for: geometry, isVertical: true)
                )
                .position(
                    x: scaledValue(minX + (maxX - minX) / 2, for: geometry),
                    y: scaledValue(minY + (maxY - minY) / 2, for: geometry, isVertical: true)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    // Вызываем обработчик тапа, если он предоставлен и не идет бросок
                    if !isThrowing, let onTap = onTap {
                        ButtonSoundService.shared.playRandomSound()
                        onTap()
                    }
                }
            
            // Анимация руки
            Group {
                switch currentFrame {
                case 1:
                    handFrame(
                        imageName: "hand1",
                        x: DesignConstants.CoinsScreen.HandAnimation.Frame1.x,
                        y: DesignConstants.CoinsScreen.HandAnimation.Frame1.y,
                        width: DesignConstants.CoinsScreen.HandAnimation.Frame1.width,
                        height: DesignConstants.CoinsScreen.HandAnimation.Frame1.height
                    )
                case 2:
                    handFrame(
                        imageName: "hand2",
                        x: DesignConstants.CoinsScreen.HandAnimation.Frame2.x,
                        y: DesignConstants.CoinsScreen.HandAnimation.Frame2.y,
                        width: DesignConstants.CoinsScreen.HandAnimation.Frame2.width,
                        height: DesignConstants.CoinsScreen.HandAnimation.Frame2.height
                    )
                case 3:
                    handFrame(
                        imageName: "hand3",
                        x: DesignConstants.CoinsScreen.HandAnimation.Frame3.x,
                        y: DesignConstants.CoinsScreen.HandAnimation.Frame3.y,
                        width: DesignConstants.CoinsScreen.HandAnimation.Frame3.width,
                        height: DesignConstants.CoinsScreen.HandAnimation.Frame3.height
                    )
                case 4:
                    handFrame(
                        imageName: "hand4",
                        x: DesignConstants.CoinsScreen.HandAnimation.Frame4.x,
                        y: DesignConstants.CoinsScreen.HandAnimation.Frame4.y,
                        width: DesignConstants.CoinsScreen.HandAnimation.Frame4.width,
                        height: DesignConstants.CoinsScreen.HandAnimation.Frame4.height
                    )
                default:
                    handFrame(
                        imageName: "hand1",
                        x: DesignConstants.CoinsScreen.HandAnimation.Frame1.x,
                        y: DesignConstants.CoinsScreen.HandAnimation.Frame1.y,
                        width: DesignConstants.CoinsScreen.HandAnimation.Frame1.width,
                        height: DesignConstants.CoinsScreen.HandAnimation.Frame1.height
                    )
                }
            }
            .allowsHitTesting(false) // Отключаем обработку тапов на самой руке, чтобы тап проходил через прозрачный фон
        }
        .onChange(of: isThrowing) { newValue in
            if newValue {
                // Начало броска - отменяем возврат к петле, если он был запланирован
                returnToLoopTask?.cancel()
                returnToLoopTask = nil
                hasCompletedThrow = false
                startThrowAnimation()
            } else {
                // Бросок завершился - остаемся на hand4 некоторое время
                // Через 2 секунды возвращаемся к петле (готовимся к следующему броску), если пользователь ничего не делает
                returnToLoopTask?.cancel()
                let task = DispatchWorkItem {
                    startLoopAnimation()
                }
                returnToLoopTask = task
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: task)
            }
        }
        .onAppear {
            // Начинаем с петли hand1-hand2
            hasCompletedThrow = false
            startLoopAnimation()
        }
        .onDisappear {
            // Останавливаем таймер при исчезновении view
            animationTimer?.invalidate()
            animationTimer = nil
        }
    }
    
    private func handFrame(imageName: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                width: scaledValue(width, for: geometry),
                height: scaledValue(height, for: geometry, isVertical: true)
            )
            .position(
                x: scaledValue(x + width / 2, for: geometry),
                y: scaledValue(y + height / 2, for: geometry, isVertical: true)
            )
    }
    
    private func startLoopAnimation() {
        // Останавливаем предыдущий таймер
        animationTimer?.invalidate()
        
        // Устанавливаем первый кадр
        currentFrame = 1
        
        // Запускаем бесконечную петлю между hand1 и hand2
        animationTimer = Timer.scheduledTimer(withTimeInterval: DesignConstants.CoinsScreen.HandAnimation.loopAnimationDuration, repeats: true) { _ in
            withAnimation(.easeInOut(duration: DesignConstants.CoinsScreen.HandAnimation.loopAnimationDuration)) {
                currentFrame = currentFrame == 1 ? 2 : 1
            }
        }
        // Добавляем таймер в RunLoop для правильной работы в SwiftUI
        RunLoop.main.add(animationTimer!, forMode: .common)
    }
    
    private func startThrowAnimation() {
        // Останавливаем петлю
        animationTimer?.invalidate()
        animationTimer = nil
        
        // Переходим к hand3
        withAnimation(.easeOut(duration: DesignConstants.CoinsScreen.HandAnimation.throwAnimationDuration)) {
            currentFrame = 3
        }
        
        // Затем переходим к hand4 (стоп-кадр)
        DispatchQueue.main.asyncAfter(deadline: .now() + DesignConstants.CoinsScreen.HandAnimation.throwAnimationDuration) {
            withAnimation(.easeIn(duration: DesignConstants.CoinsScreen.HandAnimation.finalFrameDuration)) {
                currentFrame = 4
            }
        }
    }
    
    
    // MARK: - Helper Functions
    
    /// Масштабирует значение относительно базового размера экрана
    private func scaledValue(_ value: CGFloat, for geometry: GeometryProxy, isVertical: Bool = false) -> CGFloat {
        let scaleFactor: CGFloat
        if isVertical {
            scaleFactor = geometry.size.height / DesignConstants.CoinsScreen.baseScreenHeight
        } else {
            scaleFactor = geometry.size.width / DesignConstants.CoinsScreen.baseScreenWidth
        }
        return value * scaleFactor
    }
}


