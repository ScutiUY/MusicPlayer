//
//  MusicStackView.swift
//  Flo
//
//  Created by 신의연 on 2020/10/08.
//

import Foundation
import UIKit

class MusicInfoStackView: UIStackView {
    
    init(subViews: [UIView]) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .fill
        subViews.forEach{ self.addArrangedSubview($0) }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
