//
//  MeetingFooterView.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/23.
//

import SwiftUI

struct MeetingFooterView: View {
    
    @Binding var speakers: [ScrumTimer.Speaker]
    
    var skipAction: ()->Void
    
    private var speakerNumber: Int? {
        guard let index = speakers.firstIndex(where: { !$0.isCompleted }) else { return nil }
        return index + 1
    }
    private var isLastSpeaker: Bool {
        return speakers.dropLast().allSatisfy({ $0.isCompleted })
    }
    private var speakerText: String {
        guard let speakerNumber = speakerNumber else { return "没有人" }
        return "演讲嘉宾 \(speakerNumber) / \(speakers.count) "
    }
    
    var body: some View {
        VStack {
            HStack {
                if isLastSpeaker {
                    Text("最后一位演讲嘉宾")
                } else {
                    Text(speakerText)
                    Spacer()
                    Button(action: skipAction, label: {
                        Image(systemName: "forward.fill")
                    })
                    .accessibilityLabel(Text("下一条演讲"))
                }
                
            }
        }
        .padding([.bottom, .horizontal])
    }
}

struct MeetingFooterView_Previews: PreviewProvider {
    static var speakers = [ScrumTimer.Speaker(name: "小明", isCompleted: false),
                           ScrumTimer.Speaker(name: "小红", isCompleted: false)]
    static var previews: some View {
        MeetingFooterView(speakers: .constant(speakers),skipAction: {})
            .previewLayout(.sizeThatFits)
    }
}
