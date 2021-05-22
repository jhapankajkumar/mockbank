// 
//  LoginScreenInteractor.swift
//  Authentication
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import Domains
import AuthenticationWorker
class LoginScreenInteractor: LoginScreenPresenterToInteractor {
    weak var presenter: LoginScreenInteractorToPresenter?
    var worker:AuthenticationWorkerProtocol?
    var user: Client?
    init(worker: AuthenticationWorkerProtocol?) {
        self.worker = worker
        self.worker?.loginDelegate = self
    }
    func login(with user: Client) {
        self.user = user
        self.worker?.doLogin(with: user)
    }
}

extension LoginScreenInteractor : UserLoginProtocol {
    func didSuccessLogin() {
        presenter?.didSuccessLogin()
    }
    func didFailLogin() {
        presenter?.didFailLogin()
    }
}
