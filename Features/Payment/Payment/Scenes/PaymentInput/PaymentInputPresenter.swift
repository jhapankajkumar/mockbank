//
//  PaymentInputPresenter.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import Domains

class PaymentInputPresenter: PaymentInputViewToPresenter {
    weak var view: PaymentInputPresenterToView?
    var interactor: PaymentInputPresenterToInteractor?
    var router: PaymentInputPresenterToRouter?
    var currentUser: Client
    var payTo:Client
    init(currentUser: Client, payTo:Client) {
        self.currentUser = currentUser
        self.payTo = payTo
    }
    func payAmount(amount: Double) {
        interactor?.payAmount(amount: amount, fromUser: currentUser, toUser: payTo)
    }
}

extension PaymentInputPresenter: PaymentInputInteractorToPresenter {
    func didSuccessPayment() {
        view?.hideLoading()
        router?.navigateToDashboard(from: view)
    }
    func didFailPayment() {
        view?.hideLoading()
        view?.showError()
    }
}
