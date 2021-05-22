//
//  Navigations+Splash.swift
//  AppNavigations
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import Splash
import Dashboard
import Authentication
import UIKit
extension Navigation: SplashWireframe {
    public func navigateToLogin(from view: UIViewController) {
        let loginScreen = AuthenticationConfigurator.shared.createLoginScreenModule()
        view.navigationController?.setViewControllers([loginScreen],
                                                          animated: true)
    }
    public func navigateToDashboard(from view: UIViewController) {
        let homeScreen = DashboardConfigurator.shared.createHomeScreenModule(userName: "")
        view.navigationController?.setViewControllers([homeScreen],
                                                          animated: true)
    }
}
