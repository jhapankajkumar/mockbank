// 
//  PaymentLandingInteractor.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import AuthenticationWorker
import Domains
class PaymentLandingInteractor: PaymentLandingPresenterToInteractor {
    
    weak var presenter: PaymentLandingInteractorToPresenter?
    var worker: AuthenticationWorkerProtocol?
    init(worker: AuthenticationWorkerProtocol?) {
        self.worker = worker
        self.worker?.userListDelegate = self
    }
    func fetchUserList() {
        self.worker?.fetchUserList()
    }
}

extension PaymentLandingInteractor: FetchUserListProtocol {
    func didSuccessFetchUserList(users: [Client]) {
        presenter?.didSuccessFetchUserList(users: users)
    }
    
    func didFailToFetchUserList() {
        presenter?.didFailFetchUserList()
    }
}
