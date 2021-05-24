// 
//  TopupLandingProtocols.swift
//  Topup
//
//  Created by pankaj.k.jha on 22/5/21.
//

import UIKit

// MARK: View -
protocol TopupLandingPresenterToView: AnyObject {
    var presenter: TopupLandingViewToPresenter? { get set }
    func initialSetup()
    func showLoading()
    func hideLoading()
    func showError()
}

// MARK: Interactor -
protocol TopupLandingPresenterToInteractor: AnyObject {
    var presenter: TopupLandingInteractorToPresenter? { get set }
    func topupAmount(amount: Double, for user: String)
}

// MARK: Router -
protocol TopupLandingPresenterToRouter: AnyObject {
    func navigateToDashboard(from view: TopupLandingPresenterToView?)
}

// MARK: Presenter -
protocol TopupLandingViewToPresenter: AnyObject {
    var view: TopupLandingPresenterToView? { get set }
    var interactor: TopupLandingPresenterToInteractor? { get set }
    var router: TopupLandingPresenterToRouter? { get set }
    func didLoad()
    func topupAmount(amount: Double)
}

protocol TopupLandingInteractorToPresenter: AnyObject {
    func didSuccessTopup()
    func didFailtTopup()
}
