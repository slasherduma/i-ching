//
//  IChingApp.swift
//  i-ching
//
//  Created by ALEXEY DYMARSKIY on 19/12/2025.
//

import SwiftUI

@main
struct i_chingApp: App {
    @StateObject private var notificationsService = NotificationsService.shared
    @StateObject private var musicService = BackgroundMusicService.shared
    
    init() {
        // Инициализируем сервис уведомлений
        _ = NotificationsService.shared
        // Инициализируем сервис фоновой музыки
        _ = BackgroundMusicService.shared
        // Инициализируем сервис звуков кнопок
        _ = ButtonSoundService.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationsService)
                .environmentObject(musicService)
                .onAppear {
                    // Запускаем фоновую музыку при старте приложения
                    musicService.play()
                }
        }
    }
}

