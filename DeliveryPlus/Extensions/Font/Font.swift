//
//  Font.swift
//  Graffity
//
//  Created by Karen Khachatryan on 25.11.24.
//

import UIKit

extension UIFont {
    
    static func regular(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular", size: CGFloat(size))
    }
    
    static func medium(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Medium", size: CGFloat(size))
    }
    
    static func semibold(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-SemiBold", size: CGFloat(size))
    }
}
