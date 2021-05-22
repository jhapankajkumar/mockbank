//
//  Navigations+Dashboard.swift
//  AppNavigations
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import UIKit
import Dashboard
import Domains
import Topup
import Payment
import Authentication
extension Navigation: DashboardWireframe {
    public func navigateToLoginScreen(from view: UIViewController) {
        let loginScreen = AuthenticationConfigurator.shared.createLoginScreenModule()
        view.navigationController?.setViewControllers([loginScreen], animated: false)
    }
    public func navigateToPayment(from view: UIViewController, currentUser: Client) {
        
    }
    public func navigateToTopup(from view: UIViewController, currentUser: Client) {
        let topup = TopupConfigurator.shared.createTopupLandingModule(currentUser: currentUser)
        view.navigationController?.pushViewController(topup, animated: true)
    }
}
