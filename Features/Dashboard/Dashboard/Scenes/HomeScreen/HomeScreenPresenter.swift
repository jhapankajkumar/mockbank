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
    
    func viewWillAppear() {
        view?.showLoading()
        interactor?.getUserData(userName: self.userName)
    }
    
    func topupButtonTapped() {
        if let userData = self.userData {
            router?.navigateToTopup(from: view, currentUser: userData)
        }
    }
    func paymentButtonTapped() {
        if let userData = self.userData {
            router?.navigateToPayment(from: view, currentUser: userData)
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
        var viewModel = HomeScreenViewModel()
        viewModel.balance = user.balance
        viewModel.userName = user.userName
        view?.updateView(viewModel: viewModel)
    }
    
    func didFailTogetUserData() {
        view?.hideLoading()
    }
}
