//
//  UIColorConvenience.swift
//  Pods
//
//  Created by Lloyd Sykes on 6/29/17.
//
//

import Foundation

extension UIColor {
    
    public convenience init(redInt: UInt8, greenInt: UInt8, blueInt: UInt8, alphaInt: UInt8 = 0xFF) {
        let r = (CGFloat(redInt) / 255.0)
        let g = (CGFloat(greenInt) / 255.0)
        let b = (CGFloat(blueInt) / 255.0)
        let a = (CGFloat(alphaInt) / 255.0)
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    public convenience init(rgb: Int) {
        if rgb > 0xFFFFFF { // outside RGB
            self.init(white: 0.0, alpha: 1.0)
        }
        else {
            let r = UInt8((rgb & 0xFF0000) >> 16)
            let g = UInt8((rgb & 0x00FF00) >> 8)
            let b = UInt8(rgb & 0x0000FF)
            self.init(redInt: r, greenInt: g, blueInt: b)
        }
    }
    
    public convenience init(rgba: Int) {
        if rgba > 0xFFFFFFFF { // outside RGBA
            self.init(white: 0.0, alpha: 1.0)
        }
        else {
            let r = UInt8((rgba & 0xFF000000) >> 24)
            let g = UInt8((rgba & 0x00FF0000) >> 16)
            let b = UInt8((rgba & 0x0000FF00) >> 8)
            let a = UInt8(rgba & 0x000000FF)
            self.init(redInt: r, greenInt: g, blueInt: b, alphaInt: a)
        }
    }
    
    public static func randomColor() -> UIColor {
        let hue: CGFloat = CGFloat(arc4random() % 256) / 256
        let saturation: CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness: CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
