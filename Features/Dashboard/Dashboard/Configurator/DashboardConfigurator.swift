//
//  DashboardConfigurator.swift
//  Dashboard
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import UIKit
import AuthenticationWorker

public class DashboardConfigurator {
    public static let shared = DashboardConfigurator()
    public weak var delegate: DashboardWireframe?
    
    public func createHomeScreenModule(userName: String) -> UIViewController {
        let view: UIViewController & HomeScreenPresenterToView = HomeScreenView()
        let presenter: HomeScreenViewToPresenter & HomeScreenInteractorToPresenter = HomeScreenPresenter(userName: userName)
        let worker:AuthenticationWorkerProtocol? = AuthenticationWorker()
        let interactor: HomeScreenPresenterToInteractor = HomeScreenInteractor(worker: worker)
        let router: HomeScreenPresenterToRouter = HomeScreenRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        return view
    }
}

