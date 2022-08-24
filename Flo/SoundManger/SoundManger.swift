//
//  SoundManger.swift
//  Flo
//
//  Created by 신의연 on 2020/10/09.
//

import Foundation
import UIKit
import AVFoundation

class SoundManager: NSObject {
    
    static let shared = SoundManager()
    
    var player: AVAudioPlayer!
    
    override init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
    }
    
    func initializedPlayer(soundData: Data?) {
        
        guard let data = soundData else { fatalError("Invalid soundData") }
        do {
            try self.player = AVAudioPlayer(data: data)
            self.player.delegate = self
        } catch let error as NSError {
            print("플레이어 초기화 실패")
            print("코드 : \(error.code), 메세지 : \(error.localizedDescription)")
        }
    }
    
}

extension SoundManager: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류발생")
            return
        }
        
        let message: String
        message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in
            
            // Post Notification
            NotificationCenter.default.post(name: .AudioPlateyDecodeError, object: nil)
        }
        
        alert.addAction(okAction)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: .AudioPlayerDidFinishPlaying, object: nil)
    }
}

extension Notification.Name {
    static let AudioPlateyDecodeError = Notification.Name("AudioPlayerDecodeError")
    static let AudioPlayerDidFinishPlaying = Notification.Name("AudioPlayerDidFinishPlaying")
}
