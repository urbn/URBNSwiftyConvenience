//
//  UIView+Additions.swift
//  WhiteLabel
//
//  Created by Matt Thomas on 7/18/17.
//
//

import UIKit

extension UIView {
    
    /// Uses autolayout to embed a subview inside a view with inset constraints
    ///
    /// - Parameters:
    ///   - subview: subview to embed
    ///   - insets: padding between view and superview
    public func embed(subview: UIView, insets: UIEdgeInsets = .zero) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
    }
}

extension Array where Element == UIView {
    
    /// Returns the largest intrinsic height for all the UIViews in an array. If one of the heights is UIViewNoIntrinsicMetric, then that will be returned
    public var maxIntrinsicHeight: CGFloat {
        // Check to see if any are UIViewNoIntrinsicMetric
        for view in self {
            if view.intrinsicContentSize.height == UIViewNoIntrinsicMetric { return UIViewNoIntrinsicMetric }
        }
        
        return map{ $0.intrinsicContentSize.height }.max() ?? UIViewNoIntrinsicMetric
    }
}

extension UIView {
    
    /// The border at the top of the view
    public var urbn_topBorderStyle: BorderStyle? {
        set(newBorderStyle) {
            let newBorder = Border(borderStyle: newBorderStyle)
            addBorder(newBorder, side: .top, key: &UIView.AssociatedKeys.topBorder)
        }
        get {
            return (objc_getAssociatedObject(self, &UIView.AssociatedKeys.topBorder) as? Border)?.borderStyle
        }
    }
    
    /// The border at the bottom of the view
    public var urbn_bottomBorderStyle: BorderStyle? {
        set(newBorderStyle) {
            let newBorder = Border(borderStyle: newBorderStyle)
            addBorder(newBorder, side: .bottom, key: &UIView.AssociatedKeys.bottomBorder)
        }
        get {
            return (objc_getAssociatedObject(self, &UIView.AssociatedKeys.bottomBorder) as? Border)?.borderStyle
        }
    }
    
    /// The border at the leading edge of the view
    public var urbn_leadingBorderStyle: BorderStyle? {
        set(newBorderStyle) {
            let newBorder = Border(borderStyle: newBorderStyle)
            addBorder(newBorder, side: .leading, key: &UIView.AssociatedKeys.leadingBorder)
        }
        get {
            return (objc_getAssociatedObject(self, &UIView.AssociatedKeys.leadingBorder) as? Border)?.borderStyle
        }
    }
    
    /// The border at the trailing edge of the view
    public var urbn_trailingBorderStyle: BorderStyle? {
        set(newBorderStyle) {
            let newBorder = Border(borderStyle: newBorderStyle)
            addBorder(newBorder, side: .trailing, key: &UIView.AssociatedKeys.trailingBorder)
        }
        get {
            return (objc_getAssociatedObject(self, &UIView.AssociatedKeys.trailingBorder) as? Border)?.borderStyle
        }
    }
    
    /// Clears all existing borders
    public func resetBorders() {
        urbn_topBorderStyle = nil
        urbn_bottomBorderStyle = nil
        urbn_leadingBorderStyle = nil
        urbn_trailingBorderStyle = nil
    }
    
    /// Sets all the borders based on 1 border
    ///
    /// - Parameter border: border to set
    public func setBorderStyle(_ borderStyle: BorderStyle) {
        urbn_topBorderStyle = borderStyle
        urbn_bottomBorderStyle = borderStyle
        urbn_leadingBorderStyle = borderStyle
        urbn_trailingBorderStyle = borderStyle
    }
    
    // MARK:- Private
    private struct AssociatedKeys {
        static var topBorder = AssociatedKey("UIView.wl_topBorder")
        static var bottomBorder = AssociatedKey("UIView.wl_bottomBorder")
        static var leadingBorder = AssociatedKey("UIView.wl_leadingBorder")
        static var trailingBorder = AssociatedKey("UIView.wl_trailingBorder")
    }
    
    private func addBorder(_ border: Border?, side: Border.Side, key: UnsafeRawPointer) {
        // Remove Old Border
        if let oldBorder = objc_getAssociatedObject(self, key) as? Border {
            oldBorder.removeFromSuperview()
        }
        
        // Set associated object. If nil, then the current associated object will be removed
        objc_setAssociatedObject(self, key, border, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Add the border to the current view
        border?.add(to: self, side: side)
        
        // Alert the layout needs updating
        setNeedsLayout()
    }
}
