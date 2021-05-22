//
//  SplashViewPresenter.swift
//  Splash
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation

class SplashViewPresenter: SplashViewViewToPresenter {
    weak var view: SplashViewPresenterToView?
    var interactor: SplashViewPresenterToInteractor?
    var router: SplashViewPresenterToRouter?
    func navigateToLogin() {
        router?.navigateToLogin(from: view)
    }
    func navigateToDashboard() {
        router?.navigateToDashboard(from: view)
    }
}

extension SplashViewPresenter: SplashViewInteractorToPresenter {
    
}
