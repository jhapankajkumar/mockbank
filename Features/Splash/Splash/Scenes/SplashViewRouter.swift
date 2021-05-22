// 
//  SplashViewRouter.swift
//  Splash
//
//  Created by pankaj.k.jha on 21/5/21.
//

import UIKit

class SplashViewRouter: SplashViewPresenterToRouter {

    func navigateToLogin(from view: SplashViewPresenterToView?) {
        if let view = view as? UIViewController {
            SplashConfigurator.shared.delegate?.navigateToLogin(from: view)
        }
    }
    func navigateToDashboard(from view: SplashViewPresenterToView?) {
        if let view = view as? UIViewController {
            SplashConfigurator.shared.delegate?.navigateToDashboard(from: view)
        }
    }
}
