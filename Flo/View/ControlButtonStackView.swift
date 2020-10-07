//
//  ControlButton.swift
//  Flo
//
//  Created by 신의연 on 2020/10/08.
//

import Foundation
import UIKit
import SnapKit

class ControlButtonStackView: UIStackView {
    
    init(subViews: [UIView]) {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .equalSpacing
        self.spacing = 20
        subViews.forEach{ self.addArrangedSubview($0) }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
