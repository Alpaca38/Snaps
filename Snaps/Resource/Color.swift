//
//  Color.swift
//  Snaps
//
//  Created by 조규연 on 7/22/24.
//

import UIKit

enum Color {
    static let main = UIColor(hexCode: "186FF2")
    static let black = UIColor(hexCode: "000000")
    static let gray = UIColor(hexCode: "828282")
    static let darkGray = UIColor(hexCode: "4D5652")
    static let lightGray = UIColor(hexCode: "F2F2F2")
    static let white = UIColor(hexCode: "FFFFFF")
    static let inValidState = UIColor(hexCode: "F04452")
}

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
