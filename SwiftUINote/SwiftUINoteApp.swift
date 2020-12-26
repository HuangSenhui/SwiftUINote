//
//  SwiftUINoteApp.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/22.
//

import SwiftUI

@main
struct SwiftUINoteApp: App {
    
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        let mainWindow = WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
        
        #if os(macOS)
        mainWindow
            .commands {
                LandmarkCommands()
            }
        
        Settings {
            LandmarkSettings()
        }
        #else
        mainWindow
        #endif
        
        #if os(watchOS)
        WKNotificationScene(controller: NotificationController.self, category: "LandmarkNear")
        #endif
    }
}
