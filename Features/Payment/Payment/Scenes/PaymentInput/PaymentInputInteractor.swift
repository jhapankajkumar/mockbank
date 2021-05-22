// 
//  PaymentInputInteractor.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import AuthenticationWorker
import Domains
class PaymentInputInteractor: PaymentInputPresenterToInteractor {
    weak var presenter: PaymentInputInteractorToPresenter?
    var worker: AuthenticationWorkerProtocol?
    init(worker: AuthenticationWorkerProtocol?) {
        self.worker = worker
        self.worker?.paymentDelegate = self
    }
    
    func payAmount(amount: Double, fromUser: Client, toUser: Client) {
        self.worker?.payAmount(amount: amount, fromUser: fromUser, toUser: toUser)
    }
}

extension PaymentInputInteractor: PaymentProtocol {
    func didSuccessPayment() {
        presenter?.didSuccessPayment()
    }
    
    func didFailPayment() {
        presenter?.didFailPayment()
    }
}
