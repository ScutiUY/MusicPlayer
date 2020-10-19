//
//  playerStackView.swift
//  Flo
//
//  Created by 신의연 on 2020/10/08.
//

import Foundation
import UIKit

class PanelStackView: UIStackView {
    
    lazy var lyricsTableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var musicInfoStackView = MusicInfoStackView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addArrangedSubview(musicInfoStackView)
        self.addArrangedSubview(lyricsTableView)
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .fill
        self.spacing = 10
        
        lyricsTableView.snp.makeConstraints { (m) in
            m.height.equalTo(70)
            m.width.equalToSuperview()
            m.centerX.equalToSuperview()
        }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
