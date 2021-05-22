//
//  SplashWireframe.swift
//  Splash
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import UIKit
public protocol SplashWireframe: AnyObject {
    func navigateToLogin(from view: UIViewController)
    func navigateToDashboard(from view: UIViewController)
}
