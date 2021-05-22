// 
//  TopupLandingRouter.swift
//  Topup
//
//  Created by pankaj.k.jha on 22/5/21.
//

import UIKit

class TopupLandingRouter: TopupLandingPresenterToRouter {
    func navigateToDashboard(from view: TopupLandingPresenterToView?) {
        if let view = view as? UIViewController {
            view.navigationController?.popViewController(animated: true)
        }
    }
}
