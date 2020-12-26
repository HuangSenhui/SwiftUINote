//
//  LandmarkCommands.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/26.
//

import SwiftUI

struct LandmarkCommands: Commands {
    
    private struct MenuContent: View {
        @FocusedBinding(\.seletedLandmark) var selectedLandmark
        
        var body: some View {
            Button((selectedLandmark?.isFavorite == true ? "移除" : "标记") + "最爱") {
                selectedLandmark?.isFavorite.toggle()
            }
            .keyboardShortcut("f", modifiers: [.shift, .option])
            .disabled(selectedLandmark == nil)
        }
    }
    
    var body: some Commands {
        SidebarCommands()
        CommandMenu("地标") {
            MenuContent()
        }
    }
}

private struct SelectedLandmarkKey: FocusedValueKey {
    typealias Value = Binding<Landmark>
}

extension FocusedValues {
    var seletedLandmark: Binding<Landmark>? {
        get { self[SelectedLandmarkKey.self] }
        set { self[SelectedLandmarkKey.self] = newValue }
    }
}
