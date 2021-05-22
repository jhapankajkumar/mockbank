//
//  Navigation.swift
//  AppNavigations
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import Payment
import Topup
import Authentication
import Dashboard
import Splash
import UIKit

public class Navigation {
    public static let shared = Navigation()
    init() {
        SplashConfigurator.shared.delegate = self
        DashboardConfigurator.shared.delegate = self
        AuthenticationConfigurator.shared.delegate = self
    }
    
    func initialSetup(window: UIWindow) {
        //setup all initial things like
        // Firebase
        // Google Analytics
    }

    public func buildSplashScreen() -> UIViewController {
        return SplashConfigurator.shared.createSplashViewModule()
    }
    
    public func buildHomeScreenScreen(userName: String) -> UIViewController {
        return DashboardConfigurator.shared.createHomeScreenModule(userName: userName)
    }
}
