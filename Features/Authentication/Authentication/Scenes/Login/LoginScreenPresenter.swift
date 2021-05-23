//
//  LoginScreenPresenter.swift
//  Authentication
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import Domains

class LoginScreenPresenter: LoginScreenViewToPresenter {
    weak var view: LoginScreenPresenterToView?
    var interactor: LoginScreenPresenterToInteractor?
    var router: LoginScreenPresenterToRouter?
    var currentUser: String = ""
    func login(with userName: String) {
        currentUser = userName
        var user = Client()
        user.userName = userName
        user.balance = 0
        interactor?.login(with: user)
    }
    
    func didLoad() {
        view?.initialSetup()
    }
}

extension LoginScreenPresenter: LoginScreenInteractorToPresenter {
    func didSuccessLogin() {
        router?.navigateToDashboard(from: view, userName: currentUser)
    }
    
    func didFailLogin() {
        view?.showError()
    }
}
