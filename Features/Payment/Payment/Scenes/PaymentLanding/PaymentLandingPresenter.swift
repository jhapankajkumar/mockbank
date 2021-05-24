//
//  PaymentLandingPresenter.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import Domains
class PaymentLandingPresenter: PaymentLandingViewToPresenter {
    
    weak var view: PaymentLandingPresenterToView?
    var interactor: PaymentLandingPresenterToInteractor?
    var router: PaymentLandingPresenterToRouter?
    var userList: [Client]?
    var currentUser: Client
    init(currentUser: Client) {
        self.currentUser = currentUser
    }
    func viewDidLoad() {
        view?.initialSetup()
        view?.showLoading()
        interactor?.fetchUserList()
    }
    
    func numberOfRows() -> Int {
        return userList?.count ?? 0
    }
    func dataForIndexPath(indexPath: IndexPath) -> Client? {
        if indexPath.row < userList?.count ?? 0 {
            return userList?[indexPath.row]
        }
        return nil
    }
    func didSelectRowAtIndexPath(indexPath: IndexPath) {
        if indexPath.row < userList?.count ?? 0 {
            let selectedClient = userList?[indexPath.row]
            if let payTo = selectedClient {
                router?.navigateToPaymentInput(from: view, currentUser: currentUser, payTo: payTo)
            }
        }
    }
}

extension PaymentLandingPresenter: PaymentLandingInteractorToPresenter {
    func didSuccessFetchUserList(users: [Client]) {
        view?.hideLoading()
        let users = users.filter({$0.userName?.lowercased() != currentUser.userName?.lowercased()})
        self.userList = users
        if users.count == 0 {
            view?.showNoUser()
        } else {
            view?.reloadTable()
        }
    }
    
    func didFailFetchUserList() {
        view?.hideLoading()
        view?.showNoUser()
    }
}
