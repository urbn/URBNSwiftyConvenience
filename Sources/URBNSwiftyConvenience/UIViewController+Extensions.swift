//
//  UIViewController+Extensions.swift
//  Pods-URBNSwiftyConvenience_Example
//
//  Created by Bao Tran on 9/26/18.
//

import UIKit

public extension UIViewController {
    func embedChildViewController(_ childViewController: UIViewController, insets: UIEdgeInsets = .zero,  safeAreaEdges: SafeAreaEdges = .none) {
        addChild(childViewController)
        view.embed(subview: childViewController.view, insets: insets, safeAreaEdges: safeAreaEdges)
        childViewController.didMove(toParent: self)
    }

    func removeViewAndViewControllerFromParent() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
