//
//  NotificationView.swift
//  WatchSwiftUINote Extension
//
//  Created by HuangSenhui on 2020/12/26.
//

import SwiftUI

struct NotificationView: View {
    
    var title: String?
    var message: String?
    var landmark: Landmark?
    
    var body: some View {
        VStack {
            if let lm = landmark {
                CircleImage(image: lm.image.resizable())
            }
            
            Text(title ?? "未知地标")
            
            Divider()
            
            Text(message ?? "新消息....")
                .font(.caption)
        }
        .lineLimit(0)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(title: "公园", message: "新公园", landmark: ModelData().landmarks[0])
    }
}
