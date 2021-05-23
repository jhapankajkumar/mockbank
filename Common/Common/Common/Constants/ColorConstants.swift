//
//  ColorConstants.swift
//  Common
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import UIKit

public enum MKColor: String {
    case green = "#00aa05"
    case black = "#000000"
    case white = "#FFFFFF"
    case black80 = "#585858"
    case black100 = "#252525"
    case darkBlue = "#1856CE"
    case darkerBlue = "134BBA"
    case lightBlue = "#0059FF"
    case greyOverlay = "#04040F"
    case lightGray = "#d3d3d3"
    case darkerLightGray = "#D6D2D6"
    case darkGray = "#A9A9A9"
    case darkerGray = "#696969"
    case black60 = "#9F9F9F"
    case brightBlue = "#007dfe"
    case billOverlay = "#1B1B1B"
    case primaryBlue = "#007ACF"
    case babyBlue = "#B3D8FF"
    case navigationBarColor = "#1E80F0"
    case screenBackgroundColor = "#F9F9F9"
    public func get() -> UIColor {
        return UIColor.fromHex(hex: self.rawValue)
    }
}
