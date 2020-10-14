//
//  SongInfoStackView.swift
//  Flo
//
//  Created by 신의연 on 2020/10/08.
//

import Foundation
import UIKit

class SongInfoStackView: UIStackView {
    
    lazy var songTitle = PlayerButton(fontSize: 22)
    lazy var albumTitle = PlayerButton(fontSize: 18)
    
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
        songTitle.setTitle(playList[0].title, for: .normal)
        albumTitle.setTitle(playList[0].albumTitle, for: .normal)
    }
}
