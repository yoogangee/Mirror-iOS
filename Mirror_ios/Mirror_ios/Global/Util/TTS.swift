//
//  TTS.swift
//  Mirror_ios
//
//  Created by 장윤정 on 2024/03/13.
//

import Foundation
import UIKit
import AVFAudio

class TTS {
    let ID = "TTS"
    static let shared = TTS()
    private let synthesizer = AVSpeechSynthesizer()
    
    var isSpeaking = false
    
    internal func play(_ text: String) {
        print("TTS 음성 재생")
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: "Yuna")
        utterance.rate = 0.5
        utterance.pitchMultiplier = 0.8
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
        
        isSpeaking = true
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .allowBluetooth)
    }
    
    internal func stop() {
        print("TTS 음성 재생 중지")
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    internal func checkSpeechCompletion() -> Bool {
            if !synthesizer.isSpeaking && isSpeaking {
                isSpeaking = false // TTS 재생이 완료되면 상태를 업데이트
                return true // TTS 재생이 완료되었음을 반환
            }
            return false // TTS가 아직 완료되지 않았음을 반환
        }
}
