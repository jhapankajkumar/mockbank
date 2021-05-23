// 
//  TopupLandingInteractor.swift
//  Topup
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import AuthenticationWorker
import Common
class TopupLandingInteractor: TopupLandingPresenterToInteractor {
    weak var presenter: TopupLandingInteractorToPresenter?
    var worker: AuthenticationWorkerProtocol?
    var appContext: AppContextProtocol? = AppContext.shared
    init(worker: AuthenticationWorkerProtocol?) {
        self.worker = worker
        self.worker?.topupDelegate = self
    }
    
    func topupAmount(amount: Double, for user: String) {
        self.worker?.topupAmount(amount: amount, for: user)
    }
}

extension TopupLandingInteractor : TopupAmountProtocol {
    func didSuccessTopup(amount: Double?, transferedToUser: String?) {
        if let amount = amount, let user = transferedToUser {
            appContext?.transferedAmount = amount
            appContext?.transferedTo = user
        }
        presenter?.didSuccessTopup()
    }
    
    func didFailtTopup() {
        presenter?.didFailtTopup()
    }
}
