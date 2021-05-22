// 
//  HomeScreenRouter.swift
//  Dashboard
//
//  Created by pankaj.k.jha on 21/5/21.
//

import UIKit
import Domains
class HomeScreenRouter: HomeScreenPresenterToRouter {
    func navigateToPayment(from view: HomeScreenPresenterToView?, currentUser: Client) {
        if let view = view as? UIViewController {
            DashboardConfigurator.shared.delegate?.navigateToPayment(from: view, currentUser: currentUser)
        }
    }
    
    func navigateToTopup(from view: HomeScreenPresenterToView?, currentUser: Client) {
        if let view = view as? UIViewController {
            DashboardConfigurator.shared.delegate?.navigateToTopup(from: view, currentUser: currentUser)
        }
    }
    
    func navigateToLogin(from view: HomeScreenPresenterToView?) {
        if let view = view as? UIViewController {
            DashboardConfigurator.shared.delegate?.navigateToLoginScreen(from: view)
        }
    }
}
