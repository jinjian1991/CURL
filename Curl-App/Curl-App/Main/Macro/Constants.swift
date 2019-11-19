//
//  Constants.swift
//  Curl-App
//
//  Created by Mewtwo on 2019/11/4.
//  Copyright © 2019 Ding Feng. All rights reserved.
//

import Foundation
import UIKit

struct AppColor {
    static let navigationBarColor = UIColor.white
    static let navigationBarTitleColor = UIColor.black
    static let bgColor = UIColor(red: 0.94, green: 0.94, blue: 0.96, alpha: 1.00)
    static let logoutButtonBackgroundColor = UIColor.red
    static let logoutButtonSelectedBackgroundColor = UIColor.lightGray
    static let logoutButtonTitleColor = UIColor.white
}

struct AppTabColor {
    static let titleColorNormal = UIColor.gray
    static let titleColorSelected = UIColor.black

    static let backgroundColor = UIColor.white
}

struct AppVariable: Codable, DefaultStorable {
    let curl: String
}

extension UIColor {
    struct LightTheme {
        static var backgroundColor: UIColor  { return #colorLiteral(red: 0.9385555387, green: 0.9419745207, blue: 0.9597628713, alpha: 1)/*UIColor.white*/ }
        static var navigationBarTitleColor: UIColor { return UIColor.black }
    }
    
    struct DarkTheme {
        static var backgroundColor: UIColor  { return UIColor.black }
        static var navigationBarTitleColor: UIColor { return UIColor.white }
    }
}

