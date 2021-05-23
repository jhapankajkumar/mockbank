//
//  HomeScreenPresenter.swift
//  Dashboard
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import Domains
class HomeScreenPresenter: HomeScreenViewToPresenter {
    weak var view: HomeScreenPresenterToView?
    var interactor: HomeScreenPresenterToInteractor?
    var router: HomeScreenPresenterToRouter?
    var userName:String
    var userData: Client?
    init(userName: String) {
        self.userName = userName
    }
    func didLoad() {
        view?.initialSetup()
    }
    func viewWillAppear() {
        view?.setupView()
        view?.showLoading()
        interactor?.getUserData(userName: self.userName)
    }
    
    func topupButtonTapped() {
        if let userData = self.userData {
            router?.navigateToTopup(from: view, currentUser: userData)
        }
    }
    func paymentButtonTapped() {
        if let userData = self.userData, userData.balance ?? 0 > 0 {
            router?.navigateToPayment(from: view, currentUser: userData)
        } else {
            view?.showLowBalanceAlert()
        }
    }
    func logoutButtonTapped() {
        router?.navigateToLogin(from: view)
    }
}

extension HomeScreenPresenter: HomeScreenInteractorToPresenter {
    func didGetUserData(user: Client) {
        self.userData = user
        view?.hideLoading()
        let viewModel = HomeScreenViewModel.createFrom(client: user)
        view?.updateView(viewModel: viewModel)
    }
    
    func didFailTogetUserData() {
        view?.hideLoading()
        view?.showError()
    }
}
