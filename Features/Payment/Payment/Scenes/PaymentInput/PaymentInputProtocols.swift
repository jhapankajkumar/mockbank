// 
//  PaymentInputProtocols.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import UIKit
import Domains
// MARK: View -
protocol PaymentInputPresenterToView: AnyObject {
    var presenter: PaymentInputViewToPresenter? { get set }
    func showLoading()
    func hideLoading()
    func showError()
}

// MARK: Interactor -
protocol PaymentInputPresenterToInteractor: AnyObject {
    var presenter: PaymentInputInteractorToPresenter? { get set }
    func payAmount(amount: Double, fromUser: Client, toUser: Client)
}

// MARK: Router -
protocol PaymentInputPresenterToRouter: AnyObject {
    func navigateToDashboard(from view: PaymentInputPresenterToView?)
    func navigateToPaymentLanding(from view: PaymentInputPresenterToView?)
}

// MARK: Presenter -
protocol PaymentInputViewToPresenter: AnyObject {
    var view: PaymentInputPresenterToView? { get set }
    var interactor: PaymentInputPresenterToInteractor? { get set }
    var router: PaymentInputPresenterToRouter? { get set }
    func payAmount(amount: Double)
}

protocol PaymentInputInteractorToPresenter: AnyObject {
    func didSuccessPayment()
    func didFailPayment()
}
