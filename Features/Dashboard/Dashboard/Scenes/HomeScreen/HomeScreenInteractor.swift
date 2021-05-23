// 
//  HomeScreenInteractor.swift
//  Dashboard
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import AuthenticationWorker
import Domains

class HomeScreenInteractor: HomeScreenPresenterToInteractor {
 
    weak var presenter: HomeScreenInteractorToPresenter?
    var worker:AuthenticationWorkerProtocol?
    init(worker: AuthenticationWorkerProtocol?) {
        self.worker = worker
        self.worker?.userDataDelegate = self
    }
    
    func getUserData(userName: String) {
        self.worker?.getUserData(from: userName)
    }
}

extension HomeScreenInteractor: UserDataProtocol {
    func didFetchUserData(user: Client) {
        presenter?.didGetUserData(user: user)
    }
    
    func didFailtToFetchUserData() {
        presenter?.didFailTogetUserData()
    }
}
