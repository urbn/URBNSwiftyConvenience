//
//  UIColorConvenience.swift
//  Pods
//
//  Created by Lloyd Sykes on 6/29/17.
//
//

import Foundation

extension UIColor {
    public static func randomColor() -> UIColor {
        let hue: CGFloat = CGFloat(arc4random() % 256) / 256
        let saturation: CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness: CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
