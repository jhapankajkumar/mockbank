// 
//  SplashViewProtocols.swift
//  Splash
//
//  Created by pankaj.k.jha on 21/5/21.
//

import UIKit

// MARK: View -
protocol SplashViewPresenterToView: AnyObject {
    var presenter: SplashViewViewToPresenter? { get set }
}

// MARK: Interactor -
protocol SplashViewPresenterToInteractor: AnyObject {
    var presenter: SplashViewInteractorToPresenter? { get set }
}

// MARK: Router -
protocol SplashViewPresenterToRouter: AnyObject {
    func navigateToLogin(from view: SplashViewPresenterToView?)
    func navigateToDashboard(from view: SplashViewPresenterToView?)
    
}

// MARK: Presenter -
protocol SplashViewViewToPresenter: AnyObject {
    var view: SplashViewPresenterToView? { get set }
    var interactor: SplashViewPresenterToInteractor? { get set }
    var router: SplashViewPresenterToRouter? { get set }
    func navigateToLogin()
    func navigateToDashboard()
}

protocol SplashViewInteractorToPresenter: AnyObject {
}
