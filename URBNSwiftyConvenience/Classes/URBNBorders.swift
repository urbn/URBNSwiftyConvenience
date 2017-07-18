//
//  URBNBorders.swift
//  Pods
//
//  Created by Lloyd Sykes on 6/30/17.
//
//

import Foundation

extension UIView {
    public var leftBorder: URBNBorder? {
        return getLeftBorder()
    }
    
    public var rightBorder: URBNBorder? {
        return getRightBorder()
    }
    
    public var topBorder: URBNBorder? {
        return getTopBorder()
    }
    
    public var bottomBorder: URBNBorder? {
        return getBottomBorder()
    }
    
    public func setBorder(withColor color: UIColor, width: CGFloat) {
        leftBorder?.width = width
        rightBorder?.width = width
        topBorder?.width = width
        bottomBorder?.width = width
        leftBorder?.color = color
        rightBorder?.color = color
        topBorder?.color = color
        bottomBorder?.color = color
    }
    
    public func resetBorders() {
        urbn_borderView()?.urbn_resetBorders()
    }
    
    private func urbn_borderView() -> URBNBorderView? {
        if let existingBorderView = objc_getAssociatedObject(self, &kURBNBorderViewKey) as? URBNBorderView {
            
            return existingBorderView
        }
        else {
            let borderView = URBNBorderView(frame: self.bounds)
            borderView.isOpaque = false
            borderView.isUserInteractionEnabled = false
            borderView.clearsContextBeforeDrawing = true
            borderView.contentMode = .redraw
            borderView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(borderView)
            
            if #available(iOS 9.0, *) {
                borderView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                borderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                borderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
            else {
                let views = ["borderView" : borderView]
                activateVFL(format: "V:|[borderView]|", options: .alignAllCenterX, metrics: nil, views: views)
                activateVFL(format: "H:|[borderView]|", options: .alignAllCenterY, metrics: nil, views: views)
            }
            objc_setAssociatedObject(self, &kURBNBorderViewKey, borderView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return borderView
        }
    }
    
    // MARK: Getters
    private func getLeftBorder() -> URBNBorder? {
        return self.urbn_borderView()?.bv_leftBorder
    }
    
    private func getRightBorder() -> URBNBorder? {
        return self.urbn_borderView()?.bv_rightBorder
    }
    
    private func getTopBorder() -> URBNBorder? {
        return self.urbn_borderView()?.bv_topBorder
    }
    
    private func getBottomBorder() -> URBNBorder? {
        return self.urbn_borderView()?.bv_bottomBorder
    }
}

public class URBNBorder: NSObject {
    public var color = UIColor()
    public var width = CGFloat()
    public var insets = UIEdgeInsets()
}

fileprivate final class URBNBorderView: UIView {
    fileprivate var bv_leftBorder: URBNBorder? {
        didSet {
            setNeedsDisplay()
        }
    }
    fileprivate var bv_rightBorder: URBNBorder? {
        didSet {
            setNeedsDisplay()
        }
    }
    fileprivate var bv_topBorder: URBNBorder? {
        didSet {
            setNeedsDisplay()
        }
    }
    fileprivate var bv_bottomBorder: URBNBorder? {
        didSet {
            setNeedsDisplay()
        }
    }
    
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

    // MARK: Clear
    private func clearAllBorders() {
        objc_setAssociatedObject(bv_leftBorder, &kURBNBorderViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(bv_rightBorder, &kURBNBorderViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(bv_topBorder, &kURBNBorderViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(bv_bottomBorder, &kURBNBorderViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    fileprivate func urbn_resetBorders() {
        clearAllBorders()
        setNeedsDisplay()
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
