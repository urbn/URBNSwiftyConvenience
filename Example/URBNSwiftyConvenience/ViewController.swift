//
//  ViewController.swift
//  URBNSwiftyConvenience
//
//  Created by Lloyd on 06/28/2017.
//  Copyright (c) 2017 Lloyd. All rights reserved.
//

import UIKit
import URBNSwiftyConvenience

class ViewController: UIViewController {
    
    var animateBorder: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mondrian = UIView()
        mondrian.backgroundColor = UIColor(white: 0.9, alpha: 1)
        mondrian.translatesAutoresizingMaskIntoConstraints = false
        
        mondrian.urbn_topBorderStyle = BorderStyle(color: .green, pixelWidth: 3, insets: UIEdgeInsets(top: 2, left: 12, bottom: 0, right: 0))
        mondrian.urbn_bottomBorderStyle = BorderStyle(color: .purple, pixelWidth: 5, insets: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 12))
        mondrian.urbn_leadingBorderStyle = BorderStyle(color: .red, pixelWidth: 7, insets: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        mondrian.urbn_trailingBorderStyle = BorderStyle(color: .orange)
        
        view.addSubview(mondrian)
        mondrian.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mondrian.heightAnchor.constraint(equalToConstant: 100).isActive = true
        mondrian.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mondrian.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40).isActive = true
        
        
        
        let simpleBlue = UIView()
        simpleBlue.backgroundColor = UIColor(white: 0.9, alpha: 1)
        simpleBlue.translatesAutoresizingMaskIntoConstraints = false
        
        simpleBlue.setBorderStyle(BorderStyle(color: .blue))
        
        view.addSubview(simpleBlue)
        simpleBlue.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        simpleBlue.heightAnchor.constraint(equalToConstant: 60).isActive = true
        simpleBlue.widthAnchor.constraint(equalToConstant: 200).isActive = true
        simpleBlue.topAnchor.constraint(equalTo: mondrian.bottomAnchor, constant: 40).isActive = true

        
        
        let insetCyan = UIView()
        insetCyan.backgroundColor = UIColor(white: 0.9, alpha: 1)
        insetCyan.translatesAutoresizingMaskIntoConstraints = false
        
        insetCyan.setBorderStyle(BorderStyle(color: .cyan, pixelWidth: 3, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
        
        view.addSubview(insetCyan)
        insetCyan.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        insetCyan.heightAnchor.constraint(equalToConstant: 100).isActive = true
        insetCyan.widthAnchor.constraint(equalToConstant: 75).isActive = true
        insetCyan.topAnchor.constraint(equalTo: simpleBlue.bottomAnchor, constant: 40).isActive = true

        
        
        let clearBorder = UIView()
        clearBorder.backgroundColor = UIColor(white: 0.9, alpha: 1)
        clearBorder.translatesAutoresizingMaskIntoConstraints = false
        
        clearBorder.setBorderStyle(BorderStyle(color: .brown, pixelWidth: 30, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
        
        view.addSubview(clearBorder)
        clearBorder.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        clearBorder.heightAnchor.constraint(equalToConstant: 100).isActive = true
        clearBorder.widthAnchor.constraint(equalToConstant: 120).isActive = true
        clearBorder.topAnchor.constraint(equalTo: insetCyan.bottomAnchor, constant: 40).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            clearBorder.resetBorders()
        }
        
        animateBorder = UIView()
        
        if let animateBorder = animateBorder {
            animateBorder.backgroundColor = UIColor(white: 0.9, alpha: 1)
            animateBorder.translatesAutoresizingMaskIntoConstraints = false
            
            animateBorder.urbn_bottomBorderStyle = BorderStyle(color: .green, pixelWidth: 3, insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

            view.addSubview(animateBorder)
            animateBorder.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            animateBorder.heightAnchor.constraint(equalToConstant: 60).isActive = true
            animateBorder.widthAnchor.constraint(equalToConstant: 300).isActive = true
            animateBorder.topAnchor.constraint(equalTo: clearBorder.bottomAnchor, constant: 40).isActive = true
        }
        
        let constraintPriorityTestView = UIView()
        constraintPriorityTestView.backgroundColor = .blue
        view.addSubviewsWithNoConstraints(constraintPriorityTestView)
        
        constraintPriorityTestView.topAnchor.constraint(equalTo: view.topAnchor).activate(withPriority: .defaultLow)
        constraintPriorityTestView.leftAnchor.constraint(equalTo: view.leftAnchor).activate(withPriority: .defaultHigh + 1)
        constraintPriorityTestView.widthAnchor.constraint(equalToConstant: 42.0).activate(withPriority: .required)
        constraintPriorityTestView.heightAnchor.constraint(equalToConstant: 42.0).activate(withPriority: .defaultHigh - 1)
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 4.0) {
            self.view.layoutIfNeeded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

