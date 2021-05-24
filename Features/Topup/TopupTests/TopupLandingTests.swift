//
//  TopupLandingTests.swift
//  TopupTests
//
//  Created by pankaj.k.jha on 24/5/21.
//

import XCTest
import Nimble
import Quick
@testable import Topup
@testable import AuthenticationWorker
@testable import Domains
class TopupLandingViewMock: TopupLandingPresenterToView {
    var presenter: TopupLandingViewToPresenter?
    var initialSetupCalled = false
    func initialSetup() {
        initialSetupCalled = true
    }
    
    var showLoadingCalled = false
    func showLoading() {
        showLoadingCalled = true
    }
    
    var hideLoadingCalled = false
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    var showErrorCalled = false
    func showError() {
        showErrorCalled = true
    }
}

class TopupLandingPresenterMock: TopupLandingInteractorToPresenter {
    var isDidSuccessTopupCalled = false
    func didSuccessTopup() {
        isDidSuccessTopupCalled = true
    }
    var isDidFailTopupCalled = false
    func didFailtTopup() {
        isDidFailTopupCalled = true
    }
}

class TopupLandingInteractorMock: TopupLandingPresenterToInteractor {
    var presenter: TopupLandingInteractorToPresenter?
    var isToupAmountCalled = false
    func topupAmount(amount: Double, for user: String) {
        isToupAmountCalled = true
    }
}

class TopupLandingRouterMock: TopupLandingPresenterToRouter {
    var isNavigateToDashboardCalled = false
    func navigateToDashboard(from view: TopupLandingPresenterToView?) {
        isNavigateToDashboardCalled = true
    }
}

class AuthenticationWorkerMock: AuthenticationWorkerProtocol {
    var loginDelegate: UserLoginProtocol? = nil
    
    var userDataDelegate: UserDataProtocol? = nil
    
    var topupDelegate: TopupAmountProtocol?
    
    var userListDelegate: FetchUserListProtocol? = nil
    
    var paymentDelegate: PaymentProtocol? = nil
    
    func doLogin(with user: Client) {}
    func getUserData(from userName: String) {}
    
    var isTopupAmountCalled = false
    func topupAmount(amount: Double, for user: String) {
        isTopupAmountCalled = true
    }
    func fetchUserList() {}

    func payAmount(amount: Double, fromUser: Client, toUser: Client) {}
}

class TopupLandingTests: QuickSpec {
    override func spec() {
        describe("TopupLandingPresenter") {
            var sut: TopupLandingPresenter!
            var viewMock: TopupLandingViewMock!
            var interactorMock: TopupLandingInteractorMock!
            var routerMock: TopupLandingRouterMock!
            var currentUser:Client!
            beforeEach {
                currentUser = Client()
                currentUser.userName = "Alice"
                currentUser.balance = 100

                sut = TopupLandingPresenter(currentUser: currentUser)
                viewMock = TopupLandingViewMock()
                interactorMock = TopupLandingInteractorMock()
                routerMock = TopupLandingRouterMock()
                sut.view = viewMock
                sut.router = routerMock
                sut.interactor = interactorMock
            }
            context("DidLoad called") {
                it("When didLoad, function must run successfully") {
                    sut.didLoad()
                    expect(viewMock.initialSetupCalled).to(beTrue())
                }
            }
            
            context("TopupAmount") {
                it("When topupAmount, function must run successfully") {
                    sut.topupAmount(amount: 100)
                    expect(viewMock.showLoadingCalled).to(beTrue())
                    expect(interactorMock.isToupAmountCalled).to(beTrue())
                }
            }
            
            context("Topup Success") {
                it("When didSuccessTopup, function must run successfully") {
                    sut.didSuccessTopup()
                    expect(viewMock.hideLoadingCalled).to(beTrue())
                    expect(routerMock.isNavigateToDashboardCalled).to(beTrue())
                }
            }
            
            context("Topup  failed ") {
                it("When didFailPayment failed, function must run successfully") {
                    sut.didFailtTopup()
                    expect(viewMock.hideLoadingCalled).to(beTrue())
                    expect(viewMock.showErrorCalled).to(beTrue())
                }
            }
        }
        
        describe("TopupLandingInteractor") {
            var sut: TopupLandingInteractor!
            var presenterMock: TopupLandingPresenterMock!
            var workerMock: AuthenticationWorkerMock!
            var currentUser:Client!
            var payToUser: Client!
            beforeEach {
                workerMock = AuthenticationWorkerMock()
                sut = TopupLandingInteractor(worker: workerMock)
                presenterMock = TopupLandingPresenterMock()
                sut.presenter = presenterMock
                currentUser = Client()
                currentUser.userName = "Alice"
                currentUser.balance = 100
                
                payToUser = Client()
                payToUser.userName = "Bob"
                payToUser.balance = 100
            }

            context("Topup Amount") {
                it("when payAmount is called. function must run successfully") {
                    sut.topupAmount(amount: 50, for: "Alice")
                    expect(workerMock.isTopupAmountCalled).to(beTrue())
                }
            }

            context("Topup success") {
                it("when didSuccessTopup is called. function must run successfully") {
                    sut.didSuccessTopup(amount: 0, transferedToUser: nil)
                    expect(presenterMock.isDidSuccessTopupCalled).to(beTrue())
                }
            }

            context("Topup failed") {
                it("when didFailtTopup is called failed. function must run successfully") {
                    sut.didFailtTopup()
                    expect(presenterMock.isDidFailTopupCalled).to(beTrue())
                }
            }
        }
    }
}
