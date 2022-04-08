//
//  TimerManger.swift
//  Flo
//
//  Created by 신의연 on 2020/10/12.
//

import Foundation
import UIKit

class TimerManger {
    
    static let shared = TimerManger()
    
    var timer: Timer!
    
    func makeAndFireTimer(vc: MusicPlayerViewController) {
        TimerManger.shared.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] (timer: Timer) in
            
            if ProgressBarAndTimeLabelStackView.shared.progressSlider.isTracking { return }
            
            NotificationCenter.default.post(name: .getCurrentTime, object: nil, userInfo: nil)
            
            ProgressBarAndTimeLabelStackView.shared.progressSlider.value = Float(SoundManager.shared.player.currentTime)
            
            // vc인자 실험
            let minute: Int = Int(SoundManager.shared.player.currentTime / 60)
            let second: Int = Int(SoundManager.shared.player.currentTime.truncatingRemainder(dividingBy: 60))
            
            let timeText: String = String(format: "%02ld:%02ld", minute, second)
            ProgressBarAndTimeLabelStackView.shared.timeLabel.text = timeText
            //vc.update
            
        })
        TimerManger.shared.timer.fire()
    }
    
    func invalidateTimer() {
        TimerManger.shared.timer?.invalidate()
        TimerManger.shared.timer = nil
    }
}
extension Notification.Name {
    static let getCurrentTime = Notification.Name("getCurrentTime")
}
