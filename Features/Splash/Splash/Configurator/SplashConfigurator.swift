//
//  SplashConfigurator.swift
//  Splash
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import UIKit
public class SplashConfigurator {
    public static let shared = SplashConfigurator()
    public weak var delegate: SplashWireframe?
    public func createSplashViewModule() -> UIViewController {
        let view: UIViewController & SplashViewPresenterToView = SplashViewView()
        let presenter: SplashViewViewToPresenter & SplashViewInteractorToPresenter = SplashViewPresenter()
        let interactor: SplashViewPresenterToInteractor = SplashViewInteractor()
        let router: SplashViewPresenterToRouter = SplashViewRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        return view
    }
}
