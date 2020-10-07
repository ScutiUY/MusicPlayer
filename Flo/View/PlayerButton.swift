//
//  PlayerButtonView.swift
//  Flo
//
//  Created by 신의연 on 2020/10/08.
//

import Foundation
import UIKit
class PlayerButton: UIButton {
    
    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        
    }
    
    init(buttonImage: UIImage) {
        super.init(frame: .zero)
        setImage(buttonImage, for: .normal)
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
