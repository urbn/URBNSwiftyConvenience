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
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.top).isActive = true
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
    public var urbn_topBorder: Border? {
        set(newBorder) {
            addBorder(newBorder, side: .top, key: &UIView.AssociatedKeys.topBorder)
        }
        get {
            return objc_getAssociatedObject(self, &UIView.AssociatedKeys.topBorder) as? Border
        }
    }
    
    /// The border at the bottom of the view
    public var urbn_bottomBorder: Border? {
        set(newBorder) {
            addBorder(newBorder, side: .bottom, key: &UIView.AssociatedKeys.bottomBorder)
        }
        get {
            return objc_getAssociatedObject(self, &UIView.AssociatedKeys.bottomBorder) as? Border
        }
    }
    
    /// The border at the leading edge of the view
    public var urbn_leadingBorder: Border? {
        set(newBorder) {
            addBorder(newBorder, side: .leading, key: &UIView.AssociatedKeys.leadingBorder)
        }
        get {
            return objc_getAssociatedObject(self, &UIView.AssociatedKeys.leadingBorder) as? Border
        }
    }
    
    /// The border at the trailing edge of the view
    public var urbn_trailingBorder: Border? {
        set(newBorder) {
            addBorder(newBorder, side: .trailing, key: &UIView.AssociatedKeys.trailingBorder)
        }
        get {
            return objc_getAssociatedObject(self, &UIView.AssociatedKeys.trailingBorder) as? Border
        }
    }
    
    /// Clears all existing borders
    public func resetBorders() {
        urbn_topBorder = nil
        urbn_bottomBorder = nil
        urbn_leadingBorder = nil
        urbn_trailingBorder = nil
    }
    
    /// Sets all the borders based on 1 border
    ///
    /// - Parameter border: border to set
    public func setBorder(_ border: Border) {
        urbn_topBorder = border
        urbn_bottomBorder = Border(border: border)
        urbn_leadingBorder = Border(border: border)
        urbn_trailingBorder = Border(border: border)
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
