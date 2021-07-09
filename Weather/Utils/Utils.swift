//
//  Utils.swift
//  Weather
//
//  Created by Mihail on 25.06.2021.
//

import UIKit
import Foundation

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}

extension UIView {
    public var viewWidth: CGFloat {
        return self.frame.size.width
    }

    public var viewHeight: CGFloat {
        return self.frame.size.height
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

func properDesc(desc: String) -> String {
    var result = ""
    
    switch desc {
    case let str where str.contains("clear"):
        result = "Ясно"
    case let str where str.contains("clouds"):
        result = "Облачно"
    case let str where str.contains("rain"):
        result = "Дождь"
    case let str where str.contains("thunderstorm"):
        result = "Гроза"
    case let str where str.contains("snow"):
        result = "Снег"
    case let str where str.contains("mist"):
        result = "Туман"
    case let str where str.contains("drizzle"):
        result = "Морось"
    default:
        result = ""
    }
    
    return result
}
