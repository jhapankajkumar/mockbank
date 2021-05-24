// 
//  PaymentInputInteractor.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import AuthenticationWorker
import Domains
import Common
class PaymentInputInteractor: PaymentInputPresenterToInteractor {
    weak var presenter: PaymentInputInteractorToPresenter?
    var worker: AuthenticationWorkerProtocol?
    var appContext:AppContextProtocol? = AppContext.shared
    init(worker: AuthenticationWorkerProtocol?) {
        self.worker = worker
        self.worker?.paymentDelegate = self
    }
    
    func payAmount(amount: Double, fromUser: Client, toUser: Client) {
        self.worker?.payAmount(amount: amount, fromUser: fromUser, toUser: toUser)
    }
}

extension PaymentInputInteractor: PaymentProtocol {
    func didSuccessPayment(acutalTransferredAmount: Double?, transferredTo: String?) {
        if let amount = acutalTransferredAmount, let user = transferredTo {
            appContext?.transferedAmount = amount
            appContext?.transferedTo = user
        }
        presenter?.didSuccessPayment()
    }
    
    func didFailPayment() {
        presenter?.didFailPayment()
    }
}
