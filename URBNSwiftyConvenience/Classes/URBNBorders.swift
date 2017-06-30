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
    var urbn_leftBorder: URBNBorder?
    var urbn_rightBorder: URBNBorder?
    var urbn_topBorder: URBNBorder?
    var urbn_bottomBorder: URBNBorder?
    
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
    
    // MARK: Clear
    func clearAllBorders() {
        guard
            let leftBorder = urbn_leftBorder,
            let rightBorder = urbn_rightBorder,
            let topBorder = urbn_topBorder,
            let bottomBorder = urbn_bottomBorder else {
                return
        }
        
        unregisterKVO(forBorder: leftBorder)
        unregisterKVO(forBorder: rightBorder)
        unregisterKVO(forBorder: topBorder)
        unregisterKVO(forBorder: bottomBorder)
        
        urbn_leftBorder = nil
        urbn_rightBorder = nil
        urbn_topBorder = nil
        urbn_bottomBorder = nil
    }
    
    func urbn_resetBorders() {
        clearAllBorders()
        setNeedsDisplay()
    }
}
