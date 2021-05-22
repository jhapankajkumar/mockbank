//
//  PaymentConfigurator.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import UIKit
import Domains
import AuthenticationWorker
public class PaymentConfigurator {
    public static let shared = PaymentConfigurator()
    public weak var delegate:PaymentWireframe?
    public func createPaymentLandingModule(currentUser: Client) -> UIViewController {
        let view: UIViewController & PaymentLandingPresenterToView = PaymentLandingView()
        let presenter: PaymentLandingViewToPresenter & PaymentLandingInteractorToPresenter = PaymentLandingPresenter(currentUser: currentUser)
        let worker: AuthenticationWorkerProtocol? = AuthenticationWorker()
        let interactor: PaymentLandingPresenterToInteractor = PaymentLandingInteractor(worker: worker)
        let router: PaymentLandingPresenterToRouter = PaymentLandingRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    public func createPaymentInputModule(currentUser: Client, payToUser: Client) -> UIViewController {
        let view: UIViewController & PaymentInputPresenterToView = PaymentInputView()
        let presenter: PaymentInputViewToPresenter & PaymentInputInteractorToPresenter = PaymentInputPresenter(currentUser: currentUser, payTo: payToUser)
        let worker: AuthenticationWorkerProtocol? = AuthenticationWorker()
        let interactor: PaymentInputPresenterToInteractor = PaymentInputInteractor(worker: worker)
        let router: PaymentInputPresenterToRouter = PaymentInputRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
