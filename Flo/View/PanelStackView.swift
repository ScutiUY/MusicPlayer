//
//  playerStackView.swift
//  Flo
//
//  Created by 신의연 on 2020/10/08.
//

import Foundation
import UIKit

class PanelStackView: UIStackView {
    
    lazy var lyricsTextView: UITextView = {
        
        var textView = UITextView()
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = .clear
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle: style]
        textView.attributedText = NSAttributedString(string: playList[0].lyrics, attributes: attributes)
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.textColor = .white
        
        return textView
    }()
    lazy var musicInfoStackView = MusicInfoStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addArrangedSubview(musicInfoStackView)
        self.addArrangedSubview(lyricsTextView)
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .fill
        self.spacing = 10
        
        lyricsTextView.snp.makeConstraints { (m) in
            m.height.equalTo(70)
            m.width.equalToSuperview()
        }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
