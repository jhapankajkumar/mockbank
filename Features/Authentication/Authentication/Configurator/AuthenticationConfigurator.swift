//
//  AuthenticationConfigurator.swift
//  Authentication
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import UIKit
import AuthenticationWorker
public class AuthenticationConfigurator {
    public static let shared = AuthenticationConfigurator()
    public weak var delegate:AuthenticationWireframe?
    public func createLoginScreenModule() -> UIViewController {
        let view: UIViewController & LoginScreenPresenterToView = LoginScreenView()
        let presenter: LoginScreenViewToPresenter & LoginScreenInteractorToPresenter = LoginScreenPresenter()
        let worker:AuthenticationWorkerProtocol? = AuthenticationWorker()
        let interactor: LoginScreenPresenterToInteractor = LoginScreenInteractor(worker: worker)
        let router: LoginScreenPresenterToRouter = LoginScreenRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}
