// 
//  PaymentLandingProtocols.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import UIKit
import Domains
// MARK: View -
protocol PaymentLandingPresenterToView: AnyObject {
    var presenter: PaymentLandingViewToPresenter? { get set }
    func showLoading()
    func hideLoading()
    func reloadTable()
    func showNoUser()
}

// MARK: Interactor -
protocol PaymentLandingPresenterToInteractor: AnyObject {
    var presenter: PaymentLandingInteractorToPresenter? { get set }
    func fetchUserList()
}

// MARK: Router -
protocol PaymentLandingPresenterToRouter: AnyObject {
    func navigateToPaymentInput(from view: PaymentLandingPresenterToView?, currentUser: Client, payTo: Client)
    func navigateToDashboard(from view: PaymentLandingPresenterToView?)
}

// MARK: Presenter -
protocol PaymentLandingViewToPresenter: AnyObject {
    var view: PaymentLandingPresenterToView? { get set }
    var interactor: PaymentLandingPresenterToInteractor? { get set }
    var router: PaymentLandingPresenterToRouter? { get set }
    
    func viewDidLoad()
    func numberOfRows() -> Int
    func dataForIndexPath(indexPath: IndexPath) -> Client?
    func didSelectRowAtIndexPath(indexPath: IndexPath)
}

protocol PaymentLandingInteractorToPresenter: AnyObject {
    func didSuccessFetchUserList(users: [Client])
    func didFailFetchUserList()
}
