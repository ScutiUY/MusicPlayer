//
//  ControlButton.swift
//  Flo
//
//  Created by 신의연 on 2020/10/08.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation
class AudioControlButtonStackView: UIStackView {
    
    static var shared = AudioControlButtonStackView()
    
    lazy var playPauseButton = PlayerButton(normalImage: UIImage(named: "Play")!, selectedImage: UIImage(named: "Pause")!)
        
    lazy var forwardButton = PlayerButton(buttonImage: UIImage(named: "forward")!)
        
    lazy var backwardButton = PlayerButton(buttonImage: UIImage(named: "backward")!)
        
    lazy var repeatButton = PlayerButton(buttonImage: UIImage(named: "repeat")!)
    
    lazy var randomPlayButton = PlayerButton(buttonImage: UIImage(named: "mix")!)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .equalSpacing
        self.spacing = 20
        self.addArrangedSubview(randomPlayButton)
        self.addArrangedSubview(backwardButton)
        self.addArrangedSubview(playPauseButton)
        self.addArrangedSubview(forwardButton)
        self.addArrangedSubview(repeatButton)
        setLayout()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setLayout() {
        randomPlayButton.snp.makeConstraints { (m) in
            m.width.equalTo(20)
            m.height.equalTo(20)
        }
        backwardButton.snp.makeConstraints { (m) in
            m.width.equalTo(30)
            m.height.equalTo(20)
        }
        playPauseButton.snp.makeConstraints { (m) in
            m.width.equalTo(40)
            m.height.equalTo(40)
        }
        forwardButton.snp.makeConstraints { (m) in
            m.width.equalTo(30)
            m.height.equalTo(20)
        }
        repeatButton.snp.makeConstraints { (m) in
            m.width.equalTo(20)
            m.height.equalTo(20)
        }
        
    }
}
