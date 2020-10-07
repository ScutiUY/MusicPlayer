//
//  AlbumCover.swift
//  Flo
//
//  Created by 신의연 on 2020/10/07.
//

import Foundation
import UIKit
class AlbumCoverView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
