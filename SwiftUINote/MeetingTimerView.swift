//
//  MeetingTimerView.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/23.
//

import SwiftUI

struct MeetingTimerView: View {
    @Binding var speakers: [ScrumTimer.Speaker]
    @Binding var isRecording: Bool
    var scrumColor: Color
    
    private var currentSpeaker: String {
        speakers.first(where: { !$0.isCompleted })?.name ?? "其他人"
    }
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(lineWidth: 24, antialiased: true)
            
            VStack {
                Text(currentSpeaker)
                    .font(.title)
                Text("正在演讲")
                Image(systemName: isRecording ? "mic" : "mic.slash")
                    .font(.title)
                    .padding(.top)
                    .accessibilityLabel(isRecording ? "正在转录" : "没有转录")
            }
            .accessibilityElement(children: .combine) // 将两个Text一起读
            .foregroundColor(scrumColor.accessibleFontColor)
            
            ForEach(speakers) { speak in
                if speak.isCompleted, let index = speakers.firstIndex(where: { $0.id == speak.id}) {
                    SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
                        .rotation(Angle(degrees: -90))
                        .stroke(scrumColor, lineWidth: 12)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MeetingTimerView_Previews: PreviewProvider {
    @State static var speakers = [ScrumTimer.Speaker(name: "张三", isCompleted: false),ScrumTimer.Speaker(name: "李四", isCompleted: false)]
    static var previews: some View {
        MeetingTimerView(speakers: .constant(speakers),isRecording: .constant(false), scrumColor: Color("Design"))
    }
}

// MARK: - Shape

struct SpeakerArc: Shape {
    let speakerIndex: Int
    let totalSpeakers: Int
    
    private var degressPerSpeaker: Double {
        360.0 / Double(totalSpeakers)
    }
    private var startAngle: Angle {
        Angle(degrees: degressPerSpeaker * Double(speakerIndex) + 1.0)
    }
    private var endAngle: Angle {
        Angle(degrees: startAngle.degrees + degressPerSpeaker - 1.0)
    }
    
    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2
        let center = CGPoint(x: rect.origin.x + rect.size.width / 2.0,
                             y: rect.origin.y + rect.size.height / 2.0)
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}
