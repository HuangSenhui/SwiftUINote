//
//  SwiftUINoteApp.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/22.
//

import SwiftUI

@main
struct SwiftUINoteApp: App {
    
    @ObservedObject private var data = ScrumData()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ScrumsView(scrums: $data.scrums) {
                    data.save()
                }
            }
            .onAppear(perform: {
                data.load()
            })
        }
    }
}
