//
//  HistoryView.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/23.
//

import SwiftUI

struct HistoryView: View {
    let history: History
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                
                Text("演讲嘉宾")
                    .font(.headline)
                Text(history.attendeeString)
                
                if let transcript = history.transcript {
                    Text("摘录")
                        .font(.headline)
                        .padding(.top)
                    Text(transcript)
                }
            }
        }
        .navigationTitle(Text(history.date, style: .time))
        .padding()
    }
}

extension History {
    var attendeeString: String {
        ListFormatter.localizedString(byJoining: attendees)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: History(attendees: ["张三", "李四", "王五"],
                                     lengthInMinutes: 10,
                                     transcript: "李四，你今天可以开始了吗？可以，昨天我已经看了预览，并和设计团队一起讨论了UI的最终结果..."))
    }
}

