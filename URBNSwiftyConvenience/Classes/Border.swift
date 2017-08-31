//
//  Border.swift
//  Pods
//
//  Created by Matt Thomas on 7/20/17.
//
//

import UIKit

/// Reuseable value type border view model that can be used to initalize a new border instance
public struct BorderStyle {
    
    let color: UIColor
    let pixelWidth: CGFloat
    let insets: UIEdgeInsets
    
    init(color: UIColor, pixelWidth: CGFloat = 1, insets: UIEdgeInsets = .zero) {
        self.color = color
        self.pixelWidth = pixelWidth
        self.insets = insets
    }
}

/// Represents a border with a with a width, a color, and insets
public final class Border: UIView {
    
    /// The width of the border in pixels
    public var pixelWidth: CGFloat {
        didSet {
            widthConstraint?.constant = pixelWidth.pixelsToPoints(forContentScaleFactor: currentScale)
            setNeedsUpdateConstraints()
        }
    }
    
    /// Insets for the border, used where possible. For instance, on the top border the `insets.bottom` will be ignored
    public var insets: UIEdgeInsets {
        didSet {
            topConstraint?.constant = insets.top
            bottomConstraint?.constant = -insets.bottom
            leadingConstraint?.constant = insets.left
            trailingConstraint?.constant = -insets.right
            setNeedsUpdateConstraints()
        }
    }
    
    private var widthConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?

    private var currentScale: CGFloat {
        return window?.screen.nativeScale ?? contentScaleFactor
    }
    
    /// Creates a border with a color, width, and inset
    ///
    /// - Parameters:
    ///   - color: color for the border
    ///   - pixelWidth: the width of the border in pixels (not points)
    ///   - insets: insets for the border
    public init(color: UIColor, pixelWidth: CGFloat = 1, insets: UIEdgeInsets = .zero) {
        self.pixelWidth = pixelWidth
        self.insets = insets
        super.init(frame: .zero)
        
        isUserInteractionEnabled = false
        self.pixelWidth = pixelWidth
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = color
    }
    
    public convenience init(borderStyle: BorderStyle) {
        self.init(color: borderStyle.color, pixelWidth: borderStyle.pixelWidth, insets: borderStyle.insets)
    }
    
    public convenience init(border: Border) {
        let color = border.backgroundColor ?? .clear
        self.init(color: color, pixelWidth: border.pixelWidth, insets: border.insets)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Adds the current border to a view with a specific side
    ///
    /// - Parameters:
    ///   - superview: The view to add the border to
    ///   - side: The side of the view to add
    func add(to superview: UIView, side: Side) {
        superview.addSubview(self)
        
        if side != .top {
            bottomConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
            bottomConstraint?.isActive = true
        }
        
        if side != .bottom {
            topConstraint = topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top)
            topConstraint?.isActive = true
        }
        
        if side != .leading {
            trailingConstraint = trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
            trailingConstraint?.isActive = true
        }
        
        if side != .trailing {
            leadingConstraint = leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left)
            leadingConstraint?.isActive = true
        }
        
        if side == .leading || side == .trailing {
            widthConstraint = widthAnchor.constraint(equalToConstant: pixelWidth.pixelsToPoints(forContentScaleFactor: currentScale))
            widthConstraint?.isActive = true
            setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .vertical)
            setContentCompressionResistancePriority(UILayoutPriorityFittingSizeLevel, for: .vertical)
        }
        else if side == .top || side == .bottom {
            widthConstraint = heightAnchor.constraint(equalToConstant: pixelWidth.pixelsToPoints(forContentScaleFactor: currentScale))
            widthConstraint?.isActive = true
            setContentHuggingPriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)
            setContentCompressionResistancePriority(UILayoutPriorityFittingSizeLevel, for: .horizontal)
        }
        
        widthConstraint?.constant = pixelWidth.pixelsToPoints(forContentScaleFactor: currentScale)
        setNeedsUpdateConstraints()
    }
}

extension Border {
    /// The side the border appears on
    ///
    /// - leading: leading side border
    /// - trailing: trailing side border
    /// - top: top border
    /// - bottom: bottom border
    enum Side {
        case leading, trailing, top, bottom
    }
}
