//
//  MeetingHeaderView.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/23.
//

import SwiftUI

struct MeetingHeaderView: View {
    
    @Binding var secondsElapsed: Int
    @Binding var secondsRemaining: Int
    
    private var progress: Double {
        guard secondsRemaining > 0 else {
            return 1
        }
        let total = Double(secondsElapsed + secondsRemaining)
        return Double(secondsElapsed) / total
    }
    private var minutesRemaining: Int {
        secondsRemaining / 60
    }
    // 分钟单位
    private var minutesRemainingMetric: String {
        minutesRemaining == 1 ? "1分钟" : "几分钟"
    }
    
    let scrumColor: Color
    
    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(ScrumProgressViewStyle(scrumColor: scrumColor))
            
            HStack {
                VStack(alignment: .leading) {
                    Text("倒计时")
                        .font(.caption)
                    Label("\(secondsElapsed)", systemImage: "hourglass.bottomhalf.fill")
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("剩余时间")
                        .font(.caption)
                    //Label("\(secondsRemaining)", systemImage: "hourglass.tophalf.fill")
                    HStack {
                        Text("\(secondsRemaining)")
                        Image(systemName: "hourglass.tophalf.fill")
                    }
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("倒计时剩余"))
        .accessibilityValue(Text("\(minutesRemaining) \(minutesRemainingMetric)"))
        .padding([.top, .horizontal])
    }
}

struct MeetingHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingHeaderView(secondsElapsed: .constant(60), secondsRemaining: .constant(180),scrumColor: DailyScrum.data[0].color)
            .previewLayout(.sizeThatFits)
    }
}

struct ScrumProgressViewStyle: ProgressViewStyle {
    
    var scrumColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(scrumColor.accessibleFontColor)
                .frame(height: 20)
            ProgressView(configuration)
                .frame(height: 12)
                .padding(.horizontal)
        }
    }
    
}
