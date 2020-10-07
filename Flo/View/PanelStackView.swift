//
//  playerStackView.swift
//  Flo
//
//  Created by 신의연 on 2020/10/08.
//

import Foundation
import UIKit

class PanelStackView: UIStackView {
    
    lazy var musicInfoStackView = MusicInfoStackView(subViews: [songInfoStackView, artist])
    lazy var songInfoStackView = SongInfoStackView(subViews: [songTitle,albumTitle])
    lazy var controlButtonStackView = ControlButtonStackView(subViews: [randomPlayButton, backwardButton, playButton, forwardButton, repeatButton])
    lazy var songTitle = PlayerButton(fontSize: 22)
    lazy var albumTitle = PlayerButton(fontSize: 18)
    lazy var artist = PlayerButton(fontSize: 20)
    
    lazy var playButton = PlayerButton(buttonImage: UIImage(named: "Play")!)
    lazy var pauseButton = PlayerButton(buttonImage: UIImage(named: "Pause")!)
        
    lazy var forwardButton = PlayerButton(buttonImage: UIImage(named: "forward")!)
        
    lazy var backwardButton = PlayerButton(buttonImage: UIImage(named: "backward")!)
        
    lazy var repeatButton = PlayerButton(buttonImage: UIImage(named: "repeat")!)
    
    lazy var randomPlayButton = PlayerButton(buttonImage: UIImage(named: "mix")!)
    
    lazy var lyricsTextView: UITextView = {
        var textView = UITextView()
        textView.backgroundColor = .purple
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.textColor = .yellow
        textView.text = "Sleep inside the eye of your mind~ don't you know in ma mind, a better place to play"
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addArrangedSubview(musicInfoStackView)
        self.addArrangedSubview(controlButtonStackView)
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .fill
        fetchMusicInfo()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchMusicInfo() {
        songTitle.setTitle(playList[0].title, for: .normal)
        albumTitle.setTitle(playList[0].albumTitle, for: .normal)
        artist.setTitle(playList[0].singer, for: .normal)
    }
    
}
