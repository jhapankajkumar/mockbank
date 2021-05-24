//
//  TopupLandingPresenter.swift
//  Topup
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import Domains
class TopupLandingPresenter: TopupLandingViewToPresenter {
    weak var view: TopupLandingPresenterToView?
    var interactor: TopupLandingPresenterToInteractor?
    var router: TopupLandingPresenterToRouter?
    var currentUser: Client
    init(currentUser: Client) {
        self.currentUser = currentUser
    }
    func didLoad() {
        view?.initialSetup()
    }
    func topupAmount(amount: Double) {
        if let userName = currentUser.userName {
            view?.showLoading()
            interactor?.topupAmount(amount: amount, for: userName)
        }
    }
}

extension TopupLandingPresenter: TopupLandingInteractorToPresenter {
    func didSuccessTopup() {
        view?.hideLoading()
        router?.navigateToDashboard(from: view)
    }
    func didFailtTopup() {
        view?.hideLoading()
        view?.showError()
    }
}
