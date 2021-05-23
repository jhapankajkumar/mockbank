// 
//  LoginScreenProtocols.swift
//  Authentication
//
//  Created by pankaj.k.jha on 21/5/21.
//

import UIKit
import Domains

// MARK: View -
protocol LoginScreenPresenterToView: AnyObject {
    var presenter: LoginScreenViewToPresenter? { get set }
    func initialSetup()
    func showError()
}

// MARK: Interactor -
protocol LoginScreenPresenterToInteractor: AnyObject {
    var presenter: LoginScreenInteractorToPresenter? { get set }
    func login(with user: Client)
}

// MARK: Router -
protocol LoginScreenPresenterToRouter: AnyObject {
    func navigateToDashboard(from view: LoginScreenPresenterToView?,
                             userName: String)
}

// MARK: Presenter -
protocol LoginScreenViewToPresenter: AnyObject {
    var view: LoginScreenPresenterToView? { get set }
    var interactor: LoginScreenPresenterToInteractor? { get set }
    var router: LoginScreenPresenterToRouter? { get set }
    func login(with userName: String)
    func didLoad()
}

protocol LoginScreenInteractorToPresenter: AnyObject {
    func didSuccessLogin()
    func didFailLogin()
}
