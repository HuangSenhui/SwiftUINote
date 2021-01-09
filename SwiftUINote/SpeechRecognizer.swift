//
//  SpeechRecognizer.swift
//  SwiftUINote
//
//  Created by HuangSenhui on 2020/12/23.
//

import AVFoundation
import Foundation
import Speech
import SwiftUI

struct SpeechRecognizer {
    // MARK: 语音识别
    private class SpeechAssist {
        var audioEngine: AVAudioEngine?
        var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
        var recognitionTask: SFSpeechRecognitionTask?
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: Locale.preferredLanguages.first!))
        
        deinit {
            reset()
        }
        
        func reset() {
            recognitionTask?.cancel()
            audioEngine?.stop()
            audioEngine = nil
            recognitionRequest = nil
            recognitionTask = nil
        }
    }
    
    private let assistant = SpeechAssist()
    
    func record(to speech: Binding<String>) {
        print(Locale.preferredLanguages.first ?? "未识别出语言")
        relay(speech, message: "正在请求访问")
        canAccess { authorized in
            relay(speech, message: "访问被拒绝")
            return
        }
        
        assistant.audioEngine = AVAudioEngine()
        guard let audioEngine = assistant.audioEngine else { fatalError("无法启用音频") }
        
        assistant.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = assistant.recognitionRequest else { fatalError("无法创建请求") }
        recognitionRequest.shouldReportPartialResults = true
        
        do {
            relay(speech, message: "正在运行音频系统")
            let audioSession = AVAudioSession.sharedInstance()
            
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let inputNode = audioEngine.inputNode
            relay(speech, message: "找到输入节点")
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
                recognitionRequest.append(buffer)
            }
            
            relay(speech, message: "准备音频引擎")
            audioEngine.prepare()
            try audioEngine.start()
            
            assistant.recognitionTask = assistant.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                var isFinal = false
                if let result = result {
                    relay(speech, message: result.bestTranscription.formattedString)
                    isFinal = result.isFinal
                }
                
                if error != nil || isFinal {
                    audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.assistant.recognitionRequest = nil
                }
            })
            
        } catch  {
            print("音频转录错误：\(error.localizedDescription)")
            assistant.reset()
        }
    }
    func stopRecording() {
        assistant.reset()
    }
    
    // MARK: - 申请授权
    private func canAccess(withHandler handler: @escaping (Bool)->Void) {
        SFSpeechRecognizer.requestAuthorization { (status) in
            if status == .authorized {
                AVAudioSession.sharedInstance().requestRecordPermission { authorized in
                    handler(authorized)
                }
            } else {
                handler(false)
            }
        }
    }
    
    private func relay(_ binding: Binding<String>, message: String) {
        DispatchQueue.main.async {
            binding.wrappedValue = message
        }
    }
}


