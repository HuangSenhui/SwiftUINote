//
//  MeetingView.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/22.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    @State private var transcript = ""  // 转录结果
    @State private var isRecording = false
    private let speechRecognizer = SpeechRecognizer()   // 语音识别器
    var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(scrum.color)
            
            VStack {
                MeetingHeaderView(secondsElapsed: $scrumTimer.secondsElapsed, secondsRemaining: $scrumTimer.secondsRemaining, scrumColor: scrum.color)
                MeetingTimerView(speakers: $scrumTimer.speakers, isRecording: $isRecording, scrumColor: scrum.color)
                MeetingFooterView(speakers: $scrumTimer.speakers) {
                    scrumTimer.skipSpeaker()
                }
            }
        }
        .padding()
        .foregroundColor(scrum.color.accessibleFontColor)
        .onAppear(perform: {
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            scrumTimer.speakerChangedAction = {
                player.seek(to: .zero)
                player.play()
            }
            speechRecognizer.record(to: $transcript)
            isRecording = true
            scrumTimer.startScrum()
        })
        .onDisappear(perform: {
            scrumTimer.stopScrum()
            speechRecognizer.stopRecording()
            isRecording = false
            // 添加历史记录
            let history = History(attendees: scrum.attendees, lengthInMinutes: scrumTimer.secondsElapsed / 60, transcript: transcript)
            scrum.history.append(history)
        })
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.data[2]))
    }
}

extension AVPlayer {
    static let sharedDingPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "ding", withExtension: "wav") else {  fatalError("文件缺失") }
        return AVPlayer(url: url)
    }()
}
