//
//  ChildViewController.swift
//  URBNSwiftyConvenience_Example
//
//  Created by Bao Tran on 9/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import URBNSwiftyConvenience

final class ChildViewController: UIViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)

        let removeButton = UIButton()
        removeButton.setTitle("Remove from parent VC", for: .normal)
        removeButton.addTarget(self, action: #selector(removeChildAction), for: .touchUpInside)

        view.backgroundColor = .gray

        view.addSubviewsWithNoConstraints(removeButton)
        removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        removeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc private func removeChildAction() {
        removeChildViewController()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
