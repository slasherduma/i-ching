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
    
    init() {
        // Инициализируем сервис уведомлений
        _ = NotificationsService.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notificationsService)
        }
    }
}

