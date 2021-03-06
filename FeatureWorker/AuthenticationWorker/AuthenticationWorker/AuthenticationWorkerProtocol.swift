//
//  AuthenticationWorkerProtocol.swift
//  AuthenticationWorker
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import Domains
import DataService

public protocol UserLoginProtocol: AnyObject {
    func didSuccessLogin()
    func didFailLogin()
}

public protocol UserDataProtocol: AnyObject {
    func didFetchUserData(user: Client)
    func didFailtToFetchUserData()
}

public protocol TopupAmountProtocol: AnyObject {
    func didSuccessTopup(amount: Double?, transferedToUser: String?)
    func didFailtTopup()
}

public protocol FetchUserListProtocol: AnyObject {
    func didSuccessFetchUserList(users:[Client])
    func didFailToFetchUserList()
}

public protocol PaymentProtocol: AnyObject {
    func didSuccessPayment(acutalTransferredAmount: Double?, transferredTo: String?)
    func didFailPayment()
}

public protocol AuthenticationWorkerProtocol: AnyObject {
    var loginDelegate: UserLoginProtocol? {get set}
    var userDataDelegate: UserDataProtocol? {get set}
    var topupDelegate: TopupAmountProtocol? {get set}
    var userListDelegate: FetchUserListProtocol? {get set}
    var paymentDelegate: PaymentProtocol? {get set}
    
    func doLogin(with user: Client)
    func getUserData(from userName: String)
    func topupAmount(amount: Double, for user: String)
    func fetchUserList()
    func payAmount(amount: Double, fromUser: Client, toUser: Client)
}
