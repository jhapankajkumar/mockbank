//
//  AuthenticationWorkerTests.swift
//  AuthenticationWorkerTests
//
//  Created by pankaj.k.jha on 22/5/21.
//


import Nimble
import Quick
import CoreData
@testable import AuthenticationWorker
@testable import Domains
@testable import DataService

class AuthenticationWorkerImplementation: UserLoginProtocol, PaymentProtocol , FetchUserListProtocol, TopupAmountProtocol, UserDataProtocol {
  
    var userList:[Client] = []
    var userData:Client?
    var topupAmount: Double?
    var transferredToUser: String?
    var isSuccessPayment = false
    func didSuccessPayment(acutalTransferredAmount: Double?, transferredTo: String?) {
        isSuccessPayment = true
    }
    var isFailedPayment = false
    func didFailPayment() {
        isFailedPayment = true
    }
    var isUserListCalled = false
    func didSuccessFetchUserList(users: [Client]) {
        isUserListCalled = true
        self.userList = users
    }
    
    var isFailedToFetchUserCalled = false
    func didFailToFetchUserList() {
        isFailedToFetchUserCalled = true
    }
    var isTopupSuccess = false
    func didSuccessTopup(amount: Double?, transferedToUser: String?) {
        isTopupSuccess = true
    }
    
    var isFailedTopupCalled = false
    func didFailtTopup() {
        isFailedTopupCalled = true
    }
    var didFetchUserDataCalled = false
    func didFetchUserData(user: Client) {
        didFetchUserDataCalled = true
        userData = user
    }
    
    var didFailedToFetchUserCalled = false
    func didFailtToFetchUserData() {
        didFailedToFetchUserCalled = true
    }
    
    var isDidSuccessLoginCalled = false
    func didSuccessLogin() {
        isDidSuccessLoginCalled = true
    }
    
    func didFailLogin() {
        print("didFailLogin")
    }
}

class AuthenticationWorkerTests: QuickSpec {
    override func spec() {
        describe("AuthenticationWorker") {
            var sut: AuthenticationWorker!
            var client: Client!
            var mock:AuthenticationWorkerImplementation!
            beforeEach {
                sut = AuthenticationWorker()
                mock = AuthenticationWorkerImplementation()
                sut.loginDelegate = mock
                sut.paymentDelegate = mock
                sut.userListDelegate = mock
                sut.topupDelegate = mock
                sut.userDataDelegate = mock
                client = Client()
                client.userName = "Alice"
                client.balance = 100
                sut.doLogin(with: client)
            }
            context("Login Success") {
                it("When didLoad, function must run successfully") {
                    sut.doLogin(with: client)
                    expect(mock.isDidSuccessLoginCalled).to(beTrue())
                }
            }
            
            context("UserData Success") {
                it("When getUserData, function must run successfully") {
                    sut.getUserData(from: "Alice")
                    expect(mock.didFetchUserDataCalled).to(beTrue())
                    expect(mock.userData != nil).to(beTrue())
                    expect(mock.userData?.userName == "Alice").to(beTrue())
                }
            }
            
            context("UserData Faileed") {
                it("When getUserData, function must run successfully") {
                    //Fetching Data for wrong user
                    sut.getUserData(from: "Jacob")
                    expect(mock.didFailedToFetchUserCalled).to(beTrue())
                }
            }
            
            context("Topup Success") {
                it("When topupAmount, function must run successfully") {
                    //inserting wrong user
                    sut.topupAmount(amount: 250, for: "Alice")
                    expect(mock.isTopupSuccess).to(beTrue())
                }
            }
            
            context("Topup Failed") {
                it("When topupAmount, function must run successfully") {
                    //inserting wrong user
                    sut.topupAmount(amount: 250, for: "Jacob")
                    expect(mock.isFailedTopupCalled).to(beTrue())
                }
            }
            
            context("Payment Failed") {
                it("When topupAmount, function must run successfully") {
                    //Paying user which is not present in data base
                    var user = Client()
                    user.userName = "Paul"
                    sut.payAmount(amount: 100, fromUser: client, toUser: user)
                    expect(mock.isFailedPayment).to(beTrue())
                }
            }
            
            context("Payment Success") {
                it("When topupAmount, function must run successfully") {
                    //inserting wrong user
                    var user = Client()
                    user.userName = "Amanda"
                    sut.doLogin(with: user)
                    sut.payAmount(amount: 100, fromUser: client, toUser: user)
                    expect(mock.isSuccessPayment).to(beTrue())
                }
            }
        }
    }
}
