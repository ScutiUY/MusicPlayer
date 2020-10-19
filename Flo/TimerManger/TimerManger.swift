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
    
    func makeAndFireTimer() {
        TimerManger.shared.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [unowned self] (timer: Timer) in
            
            if ProgressBarAndTimeLabelStackView.shared.progressSlider.isTracking { return }
            
            NotificationCenter.default.post(name: .getCurrentTime, object: nil, userInfo: nil)
            
            ProgressBarAndTimeLabelStackView.shared.progressSlider.value = Float(SoundManager.shared.player.currentTime)
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
