// 
//  TopupLandingInteractor.swift
//  Topup
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import AuthenticationWorker
class TopupLandingInteractor: TopupLandingPresenterToInteractor {
    weak var presenter: TopupLandingInteractorToPresenter?
    var worker: AuthenticationWorkerProtocol?
    init(worker: AuthenticationWorkerProtocol?) {
        self.worker = worker
        self.worker?.topupDelegate = self
    }
    
    func topupAmount(amount: Double, for user: String) {
        self.worker?.topupAmount(amount: amount, for: user)
    }
}

extension TopupLandingInteractor : TopupAmountProtocol {
    func didSuccessTopup() {
        presenter?.didSuccessTopup()
    }
    
    func didFailtTopup() {
        presenter?.didFailtTopup()
    }
}
