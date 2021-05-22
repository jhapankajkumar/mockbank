// 
//  PaymentLandingRouter.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import UIKit
import Domains

class PaymentLandingRouter: PaymentLandingPresenterToRouter {
    func navigateToPaymentInput(from view: PaymentLandingPresenterToView?, currentUser: Client, payTo: Client) {
        if let view = view as? UIViewController {
            let paymentInputController = PaymentConfigurator.shared.createPaymentInputModule(currentUser: currentUser, payToUser: payTo)
            view.navigationController?.pushViewController(paymentInputController, animated: true)
        }
    }
    
    func navigateToDashboard(from view: PaymentLandingPresenterToView?) {
        if let view = view as? UIViewController {
            view.navigationController?.popViewController(animated: true)
        }
    }
}
