//
//  Navigation+Authentication.swift
//  AppNavigations
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import Authentication
import UIKit
extension Navigation: AuthenticationWireframe {
    public func navigateToDashboard(from view: UIViewController, currentUser: String) {
        view.navigationController?.setViewControllers([buildHomeScreenScreen(userName: currentUser)], animated: false)
    }
}
