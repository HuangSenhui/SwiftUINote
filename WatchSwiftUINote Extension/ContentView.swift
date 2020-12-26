//
//  ContentView.swift
//  WatchSwiftUINote Extension
//
//  Created by HuangSenhui on 2020/12/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
