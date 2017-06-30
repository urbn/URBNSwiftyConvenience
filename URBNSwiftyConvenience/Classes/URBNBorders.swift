//
//  URBNBorders.swift
//  Pods
//
//  Created by Lloyd Sykes on 6/30/17.
//
//

import Foundation

public class URBNBorder: NSObject {
    let color = UIColor()
    let width = CGFloat()
    let insets = UIEdgeInsets()
}

fileprivate class URBNBorderView: UIView {
    let urbn_leftBorder: URBNBorder?
    let urbn_topBorder: URBNBorder?
    let urbn_rightBorder: URBNBorder?
    let urbn_bottomBorder: URBNBorder?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
