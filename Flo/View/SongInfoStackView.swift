//
//  SongInfoStackView.swift
//  Flo
//
//  Created by 신의연 on 2020/10/08.
//

import Foundation
import UIKit
import MarqueeLabel
class SongInfoStackView: UIStackView {
    
    //lazy var songTitle = PlayerButton(fontSize: 22)
    lazy var albumTitle = PlayerButton(fontSize: 18)
    lazy var songTitle: MarqueeLabel = {
        var label = MarqueeLabel(frame: .zero, duration: 8, fadeLength: 10)
        label.text = playList[0].title
        label.font = label.font.withSize(22)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .fillEqually
        self.spacing = -10
        self.addArrangedSubview(songTitle)
        self.addArrangedSubview(albumTitle)
        
        fetchMusicInfo()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func fetchMusicInfo() {
        albumTitle.setTitle(playList[0].albumTitle, for: .normal)
    }
}
