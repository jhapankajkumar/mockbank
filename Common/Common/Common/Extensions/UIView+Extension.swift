//
//  UIView+Extension.swift
//  Common
//
//  Created by pankaj.k.jha on 23/5/21.
//

import Foundation
import UIKit
public extension UIView {
     func decorateView() {
        self.backgroundColor = MKColor.white.get()
        self.layer.cornerRadius = 8.0
        self.layer.shadowColor = MKColor.greyOverlay.get().cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }
}
