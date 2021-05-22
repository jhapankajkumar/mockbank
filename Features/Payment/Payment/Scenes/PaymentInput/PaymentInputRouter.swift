// 
//  PaymentInputRouter.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import UIKit

class PaymentInputRouter: PaymentInputPresenterToRouter {
    func navigateToDashboard(from view: PaymentInputPresenterToView?) {
        if let view = view as? UIViewController {
            view.navigationController?.popToRootViewController(animated: false)
        }
    }
    func navigateToPaymentLanding(from view: PaymentInputPresenterToView?) {
        if let view = view as? UIViewController {
            view.navigationController?.popViewController(animated: true)
        }
    }
}
