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
    
    private final let width = "width"
    private final let color = "color"
    private final let insets = "insets"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: KVO
    func configuredBorder() -> URBNBorder {
        let border = URBNBorder()
        border.addObserver(self, forKeyPath: width, options: .new, context: nil)
        border.addObserver(self, forKeyPath: color, options: .new, context: nil)
        border.addObserver(self, forKeyPath: insets, options: .new, context: nil)
        
        return border
    }
    
    func unregisterKVO(forBorder border: URBNBorder) {
        border.removeObserver(self, forKeyPath: width)
        border.removeObserver(self, forKeyPath: color)
        border.removeObserver(self, forKeyPath: insets)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        setNeedsDisplay()
    }
}
