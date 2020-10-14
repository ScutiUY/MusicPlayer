//
//  MusicStackView.swift
//  Flo
//
//  Created by 신의연 on 2020/10/08.
//

import Foundation
import UIKit

class MusicInfoStackView: UIStackView {
    
    lazy var artist = PlayerButton(fontSize: 20)
    lazy var songInfoStackView = SongInfoStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .fill
        self.addArrangedSubview(songInfoStackView)
        self.addArrangedSubview(artist)
        artist.setTitleColor(.lightGray, for: .normal)
        fetchMusicInfo()
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func fetchMusicInfo() {
        artist.setTitle(playList[0].singer, for: .normal)
    }
}
