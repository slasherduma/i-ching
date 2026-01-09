import AVFoundation
import Combine

class BackgroundMusicService: ObservableObject {
    static let shared = BackgroundMusicService()
    
    @Published var isPlaying: Bool = false
    @Published var volume: Float = 0.5 {
        didSet {
            audioPlayer?.volume = volume
        }
    }
    
    private var audioPlayer: AVAudioPlayer?
    private var audioSession: AVAudioSession?
    
    private init() {
        setupAudioSession()
        loadMusic()
    }
    
    private func setupAudioSession() {
        do {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession?.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try audioSession?.setActive(true)
        } catch {
            print("❌ Ошибка настройки аудио сессии: \(error.localizedDescription)")
        }
    }
    
    private func loadMusic() {
        guard let url = Bundle.main.url(forResource: "background_music", withExtension: "m4a") else {
            print("⚠️ Файл background_music.m4a не найден в Bundle")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // -1 означает бесконечный цикл
            audioPlayer?.volume = volume
            audioPlayer?.prepareToPlay()
            print("✅ Фоновая музыка загружена успешно")
        } catch {
            print("❌ Ошибка загрузки музыки: \(error.localizedDescription)")
        }
    }
    
    func play() {
        guard let player = audioPlayer else {
            print("⚠️ Аудио плеер не инициализирован. Убедитесь, что файл background_music.m4a добавлен в проект.")
            return
        }
        
        guard !isPlaying else { return }
        
        player.play()
        isPlaying = true
        print("🎵 Фоновая музыка начала играть")
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
        print("⏹️ Фоновая музыка остановлена")
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        print("⏸️ Фоновая музыка приостановлена")
    }
    
    func setVolume(_ newVolume: Float) {
        volume = max(0.0, min(1.0, newVolume))
    }
}
