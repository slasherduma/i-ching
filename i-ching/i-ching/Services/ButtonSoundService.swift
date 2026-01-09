import AVFoundation
import Foundation

class ButtonSoundService {
    static let shared = ButtonSoundService()
    
    private let soundNames = ["bell1", "bell2", "bell3", "bell4"]
    private var audioPlayers: [AVAudioPlayer] = []
    private let maxConcurrentPlayers = 10 // Максимальное количество одновременных воспроизведений
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("❌ Ошибка настройки аудио сессии для звуков кнопок: \(error.localizedDescription)")
        }
    }
    
    func playRandomSound() {
        // Тактильная обратная связь (такая же, как у кнопки "БРОСИТЬ МОНЕТЫ")
        // Вибрация работает всегда, независимо от настройки звука
        HapticManager.shared.triggerCoinsReleasedHaptic()
        
        // Проверяем, включен ли звук (фоновая музыка)
        // Если звук выключен, не воспроизводим звуки bell
        guard BackgroundMusicService.shared.isPlaying else { return }
        
        // Выбираем случайный звук
        guard let soundName = soundNames.randomElement() else { return }
        
        // Загружаем и воспроизводим звук
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "m4a") else {
            print("⚠️ Файл \(soundName).m4a не найден в Bundle")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.2 // Громкость звуков кнопок
            player.prepareToPlay()
            player.play()
            
            // Добавляем в массив для отслеживания
            audioPlayers.append(player)
            
            // Очищаем завершившиеся воспроизведения
            cleanupFinishedPlayers()
            
            // Ограничиваем количество одновременных воспроизведений
            if audioPlayers.count > maxConcurrentPlayers {
                // Останавливаем самый старый
                if let oldestPlayer = audioPlayers.first {
                    oldestPlayer.stop()
                    audioPlayers.removeFirst()
                }
            }
        } catch {
            print("❌ Ошибка воспроизведения звука \(soundName): \(error.localizedDescription)")
        }
    }
    
    private func cleanupFinishedPlayers() {
        audioPlayers.removeAll { !$0.isPlaying }
    }
}
