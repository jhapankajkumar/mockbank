// 
//  HomeScreenProtocols.swift
//  Dashboard
//
//  Created by pankaj.k.jha on 21/5/21.
//

import UIKit
import Domains
// MARK: View -
protocol HomeScreenPresenterToView: AnyObject {
    var presenter: HomeScreenViewToPresenter? { get set }
    func updateView(viewModel: HomeScreenViewModel?)
    func showLoading()
    func hideLoading()
    func showLowBalanceAlert()
    func initialSetup()
    func setupView()
    func showError()
}

// MARK: Interactor -
protocol HomeScreenPresenterToInteractor: AnyObject {
    var presenter: HomeScreenInteractorToPresenter? { get set }
    func getUserData(userName: String)
}

// MARK: Router -
protocol HomeScreenPresenterToRouter: AnyObject {
    func navigateToLogin(from view: HomeScreenPresenterToView?)
    func navigateToPayment(from view: HomeScreenPresenterToView?, currentUser: Client)
    func navigateToTopup(from view: HomeScreenPresenterToView?, currentUser: Client)
}

// MARK: Presenter -
protocol HomeScreenViewToPresenter: AnyObject {
    var view: HomeScreenPresenterToView? { get set }
    var interactor: HomeScreenPresenterToInteractor? { get set }
    var router: HomeScreenPresenterToRouter? { get set }
    func didLoad()
    func viewWillAppear()
    func topupButtonTapped()
    func paymentButtonTapped()
    func logoutButtonTapped()
}

protocol HomeScreenInteractorToPresenter: AnyObject {
    func didGetUserData(user: Client)
    func didFailTogetUserData()
}
