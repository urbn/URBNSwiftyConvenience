//
//  URBNBorders.swift
//  Pods
//
//  Created by Lloyd Sykes on 6/30/17.
//
//

import Foundation

extension UIView {
    public var urbn_leftBorder: URBNBorder? {
        return leftBorder()
    }
    
    public var urbn_rightBorder: URBNBorder? {
        return rightBorder()
    }
    
    public var urbn_topBorder: URBNBorder? {
        return topBorder()
    }
    
    public var urbn_bottomBorder: URBNBorder? {
        return bottomBorder()
    }
    
    public func urbn_setBorder(withColor color: UIColor, width: CGFloat) {
        urbn_leftBorder?.width = width
        urbn_rightBorder?.width = width
        urbn_topBorder?.width = width
        urbn_bottomBorder?.width = width
        urbn_leftBorder?.color = color
        urbn_rightBorder?.color = color
        urbn_topBorder?.color = color
        urbn_bottomBorder?.color = color
    }
    
    public func urbn_resetBorders() {
        urbn_borderView()?.resetBorders()
    }
    
    private func urbn_borderView() -> URBNBorderView? {
        if var borderView = objc_getAssociatedObject(self, &kURBNBorderViewKey) as? URBNBorderView {
            borderView = URBNBorderView(frame: self.bounds)
            borderView.isOpaque = false
            borderView.isUserInteractionEnabled = false
            borderView.clearsContextBeforeDrawing = true
            borderView.contentMode = .redraw
            borderView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(borderView)
            
            let views = ["borderView" : borderView]
            activateVFL(format: "V:|[borderView]|", options: .alignAllCenterX, metrics: nil, views: views)
            activateVFL(format: "H:|[borderView]|", options: .alignAllCenterY, metrics: nil, views: views)
            objc_setAssociatedObject(self, &kURBNBorderViewKey, borderView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return borderView
        }
        
        return nil
    }

    // MARK: Getters
    private func leftBorder() -> URBNBorder? {
        return self.urbn_borderView()?.urbn_LeftBorder()
    }
    
    private func rightBorder() -> URBNBorder? {
        return self.urbn_borderView()?.urbn_RightBorder()
    }
    
    private func topBorder() -> URBNBorder? {
        return self.urbn_borderView()?.urbn_TopBorder()
    }
    
    private func bottomBorder() -> URBNBorder? {
        return self.urbn_borderView()?.urbn_BottomBorder()
    }
}

public class URBNBorder: NSObject {
    public var color = UIColor()
    public var width = CGFloat()
    public let insets = UIEdgeInsets()
}

fileprivate final class URBNBorderView: UIView {
    fileprivate var bv_leftBorder: URBNBorder?
    fileprivate var bv_rightBorder: URBNBorder?
    fileprivate var bv_topBorder: URBNBorder?
    fileprivate var bv_bottomBorder: URBNBorder?
    
    private final let width = "width"
    private final let color = "color"
    private final let insets = "insets"
    
    convenience init() {
        self.init()
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame)
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
            let leftBorder = bv_leftBorder,
            let rightBorder = bv_rightBorder,
            let topBorder = bv_topBorder,
            let bottomBorder = bv_bottomBorder else {
                return
        }
        
        unregisterKVO(forBorder: leftBorder)
        unregisterKVO(forBorder: rightBorder)
        unregisterKVO(forBorder: topBorder)
        unregisterKVO(forBorder: bottomBorder)
        
        bv_leftBorder = nil
        bv_rightBorder = nil
        bv_topBorder = nil
        bv_bottomBorder = nil
    }
    
    fileprivate func resetBorders() {
        clearAllBorders()
        setNeedsDisplay()
    }
    
    // MARK: Border Check for Nil
    fileprivate func urbn_LeftBorder() -> URBNBorder? {
        guard var leftBorder = bv_leftBorder else { return nil }
        leftBorder = configuredBorder()
        
        return leftBorder
    }
    
    fileprivate func urbn_RightBorder() -> URBNBorder? {
        guard var rightBorder = bv_rightBorder else { return nil }
        rightBorder = configuredBorder()
        
        return rightBorder
    }
    
    fileprivate func urbn_TopBorder() -> URBNBorder? {
        guard var topBorder = bv_topBorder else { return nil }
        topBorder = configuredBorder()
        
        return topBorder
    }
    
    fileprivate func urbn_BottomBorder() -> URBNBorder? {
        guard var bottomBorder = bv_bottomBorder else { return nil }
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
            let leftBorder = bv_leftBorder,
            let rightBorder = bv_rightBorder,
            let topBorder = bv_topBorder,
            let bottomBorder = bv_bottomBorder else {
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

fileprivate var kURBNBorderViewKey = CChar()
