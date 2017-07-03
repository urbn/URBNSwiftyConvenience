//
//  URBNBorders.swift
//  Pods
//
//  Created by Lloyd Sykes on 6/30/17.
//
//

import Foundation

public class URBNBorder: NSObject {
    public let color = UIColor()
    public let width = CGFloat()
    public let insets = UIEdgeInsets()
}

fileprivate class URBNBorderView: UIView {
    private var leftBorder: URBNBorder?
    private var rightBorder: URBNBorder?
    private var topBorder: URBNBorder?
    private var bottomBorder: URBNBorder?
    
    private final let width = "width"
    private final let color = "color"
    private final let insets = "insets"
    
    fileprivate let kURBNorderViewKey = CChar()
    
    convenience init() {
        self.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: KVO
    private func configuredBorder() -> URBNBorder {
        let border = URBNBorder()
        border.addObserver(self, forKeyPath: width, options: .new, context: nil)
        border.addObserver(self, forKeyPath: color, options: .new, context: nil)
        border.addObserver(self, forKeyPath: insets, options: .new, context: nil)
        
        return border
    }
    
    private func unregisterKVO(forBorder border: URBNBorder) {
        border.removeObserver(self, forKeyPath: width)
        border.removeObserver(self, forKeyPath: color)
        border.removeObserver(self, forKeyPath: insets)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        setNeedsDisplay()
    }
    
    // MARK: Clear
    private func clearAllBorders() {
        guard
            let leftBorder = self.leftBorder,
            let rightBorder = self.rightBorder,
            let topBorder = self.topBorder,
            let bottomBorder = self.bottomBorder else {
                return
        }
        
        unregisterKVO(forBorder: leftBorder)
        unregisterKVO(forBorder: rightBorder)
        unregisterKVO(forBorder: topBorder)
        unregisterKVO(forBorder: bottomBorder)
        
        self.leftBorder = nil
        self.rightBorder = nil
        self.topBorder = nil
        self.bottomBorder = nil
    }
    
    private func urbn_resetBorders() {
        clearAllBorders()
        setNeedsDisplay()
    }
    
    // MARK: Border Check for Nil
    private func urbn_LeftBorder() -> URBNBorder? {
        guard var leftBorder = urbn_leftBorder else { return nil }
        leftBorder = configuredBorder()
        
        return leftBorder
    }
    
    private func urbn_RightBorder() -> URBNBorder? {
        guard var rightBorder = urbn_rightBorder else { return nil }
        rightBorder = configuredBorder()
        
        return rightBorder
    }
    
    private func urbn_TopBorder() -> URBNBorder? {
        guard var topBorder = urbn_topBorder else { return nil }
        topBorder = configuredBorder()
        
        return topBorder
    }
    
    private func urbn_BottomBorder() -> URBNBorder? {
        guard var bottomBorder = urbn_bottomBorder else { return nil }
        bottomBorder = configuredBorder()
        
        return bottomBorder
    }
    
    // MARK: Drawing
    private func renderingScaleFactor() -> CGFloat? {
        if window?.screen.nativeScale != nil {
            return contentScaleFactor
        }
        return nil
    }
    
    private func upscaleTransform() -> CGAffineTransform? {
        guard let scaleFactor = renderingScaleFactor() else { return nil }
        return CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
    }
    
    private func downscaleTransform() -> CGAffineTransform? {
        guard let upscale = upscaleTransform() else { return nil }
        return upscale.inverted()
    }
    
    override func draw(_ rect: CGRect) {
        guard
            let upscale = upscaleTransform(),
            let leftBorder = leftBorder,
            let rightBorder = rightBorder,
            let topBorder = topBorder,
            let bottomBorder = bottomBorder else {
                return
        }
        let viewRect = rect.applying(upscale)
        let minX = viewRect.minX
        let maxX = viewRect.maxX
        let minY = viewRect.minY
        let maxY = viewRect.maxY
        
        // Left
        borderDrawBlock(leftBorder) { (border) in
            let insets = border.insets
            let fromPoint = CGPoint(x: insets.left + minX + (border.width / 2), y: insets.top + minY)
            let toPoint = CGPoint(x: fromPoint.x, y: maxY - insets.bottom)
            drawBorder(border, fromPoint, toPoint)
        }
        
        // Right
        borderDrawBlock(rightBorder) { (border) in
            let insets = border.insets
            let fromPoint = CGPoint(x: maxX - insets.right - (border.width / 2), y: insets.top + minY)
            let toPoint = CGPoint(x: fromPoint.x, y: maxY - insets.bottom)
            drawBorder(border, fromPoint, toPoint)
        }
        
        // Top
        borderDrawBlock(topBorder) { (border) in
            let insets = border.insets
            let fromPoint = CGPoint(x: insets.left + minX, y: minY + insets.top + (border.width / 2))
            let toPoint = CGPoint(x: maxX - insets.right, y: fromPoint.y)
            drawBorder(border, fromPoint, toPoint)
        }
        
        // Bottom
        borderDrawBlock(bottomBorder) { (border) in
            let insets = border.insets
            let fromPoint = CGPoint(x: insets.left + minX, y: maxY - insets.bottom - (border.width / 2))
            let toPoint = CGPoint(x: maxX - insets.right, y: fromPoint.y)
            drawBorder(border, fromPoint, toPoint)
        }
    }
    
    private func drawBorder(_ border: URBNBorder, _ start: CGPoint, _ end: CGPoint) -> () {
        guard
            let renderingScale = renderingScaleFactor(),
            let downscale = downscaleTransform() else {
                return
        }
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = border.width / renderingScale
        path.apply(downscale)
        border.color.setStroke()
        path.stroke()
    }
    
    private func borderDrawBlock(_ border: URBNBorder, _ completion: (_ drawnBorder: URBNBorder) -> ()) -> () {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        if border.width > 0 {
            context.saveGState()
            completion(border)
        }
        context.restoreGState()
    }
    
    // MARK: deinit
    deinit {
        clearAllBorders()
    }
}

extension UIView {
    public var urbn_leftBorder: URBNBorder? {
        return self.urbn_leftBorder != nil ? self.urbn_leftBorder : nil
    }
    
    public var urbn_rightBorder: URBNBorder? {
        return self.urbn_rightBorder != nil ? self.urbn_rightBorder : nil
    }
    
    public var urbn_topBorder: URBNBorder? {
        return self.urbn_topBorder != nil ? self.urbn_topBorder : nil
    }
    
    public var urbn_bottomBorder: URBNBorder? {
        return self.urbn_bottomBorder != nil ? self.urbn_bottomBorder : nil
    }
    
}
