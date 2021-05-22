// 
//  LoginScreenRouter.swift
//  Authentication
//
//  Created by pankaj.k.jha on 21/5/21.
//

import UIKit

class LoginScreenRouter: LoginScreenPresenterToRouter {
    func navigateToDashboard(from view: LoginScreenPresenterToView?,
                             userName: String) {
        if let view = view as? UIViewController {
            AuthenticationConfigurator.shared.delegate?.navigateToDashboard(from: view, currentUser: userName)
        }
    }
}
