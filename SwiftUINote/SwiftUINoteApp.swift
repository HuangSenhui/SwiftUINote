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
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
