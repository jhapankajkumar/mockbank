//
//  TopupConfigurator.swift
//  Topup
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import UIKit
import AuthenticationWorker
import Domains
public class TopupConfigurator {
    public static let shared = TopupConfigurator()
    public weak var delegate: TopupWireframe?
    
    public func createTopupLandingModule(currentUser: Client) -> UIViewController {
        let view: UIViewController & TopupLandingPresenterToView = TopupLandingView()
        let presenter: TopupLandingViewToPresenter & TopupLandingInteractorToPresenter = TopupLandingPresenter(currentUser: currentUser)
        let authenticationWorker: AuthenticationWorkerProtocol? = AuthenticationWorker()
        let interactor: TopupLandingPresenterToInteractor = TopupLandingInteractor(worker: authenticationWorker)
        let router: TopupLandingPresenterToRouter = TopupLandingRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
