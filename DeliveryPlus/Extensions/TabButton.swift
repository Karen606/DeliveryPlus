//
//  TabButton.swift
//  SmartRestaurantManager
//
//  Created by Karen Khachatryan on 08.12.24.
//

import UIKit

class TabButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .baseGreen : .white
        }
    }
    
    func commonInit() {
        self.titleLabel?.font = .regular(size: 17)
        self.setTitleColor(.black, for: .normal)
        self.setTitleColor(.black, for: .selected)
        self.layer.cornerRadius = 18
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
