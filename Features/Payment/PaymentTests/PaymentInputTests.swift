//
//  PaymentInput.swift
//  PaymentTests
//
//  Created by pankaj.k.jha on 24/5/21.
//

import XCTest
import Nimble
import Quick
@testable import Payment
@testable import AuthenticationWorker
@testable import Domains
class PaymentInputViewMock: PaymentInputPresenterToView {
    
    var presenter: PaymentInputViewToPresenter?
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

class PaymentInputPresenterMock: PaymentInputInteractorToPresenter {
    var didSuccessPaymentCalled = false
    func didSuccessPayment() {
        didSuccessPaymentCalled = true
    }
    
    var didFailPaymentCalled = false
    func didFailPayment() {
        didFailPaymentCalled = true
    }
}

class PaymentInputInteractorMock: PaymentInputPresenterToInteractor {
    var presenter: PaymentInputInteractorToPresenter?
    
    var isPayAmountCalled = false
    func payAmount(amount: Double, fromUser: Client, toUser: Client) {
        isPayAmountCalled = true
    }
}

class PaymentInputRouterMock: PaymentInputPresenterToRouter {
    func navigateToPaymentLanding(from view: PaymentInputPresenterToView?) {}
    
    var isNavigateToDashboardCalled = false
    func navigateToDashboard(from view: PaymentInputPresenterToView?) {
        isNavigateToDashboardCalled = true
    }
}

class PaymentInputTests: QuickSpec {
    override func spec() {
        describe("PaymentInputPresenter") {
            var sut: PaymentInputPresenter!
            var viewMock: PaymentInputViewMock!
            var interactorMock: PaymentInputInteractorMock!
            var routerMock: PaymentInputRouterMock!
            var currentUser:Client!
            var payToUser: Client!
            beforeEach {
                currentUser = Client()
                currentUser.userName = "Alice"
                currentUser.balance = 100
                
                payToUser = Client()
                payToUser.userName = "Bob"
                payToUser.balance = 100
                
                sut = PaymentInputPresenter(currentUser: currentUser, payTo: payToUser)
                viewMock = PaymentInputViewMock()
                interactorMock = PaymentInputInteractorMock()
                routerMock = PaymentInputRouterMock()
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
            
            context("PayAmount called") {
                it("When payAmount, function must run successfully") {
                    sut.payAmount(amount: 100)
                    expect(viewMock.showLoadingCalled).to(beTrue())
                    expect(interactorMock.isPayAmountCalled).to(beTrue())
                }
            }
            
            context("Payment Success") {
                it("When didSuccessPayment, function must run successfully") {
                    sut.didSuccessPayment()
                    expect(viewMock.hideLoadingCalled).to(beTrue())
                    expect(routerMock.isNavigateToDashboardCalled).to(beTrue())
                }
            }
            
            context("Payment  failed ") {
                it("When didFailPayment failed, function must run successfully") {
                    sut.didFailPayment()
                    expect(viewMock.hideLoadingCalled).to(beTrue())
                    expect(viewMock.showErrorCalled).to(beTrue())
                }
            }
        }
        
        describe("PaymentInputInteractor") {
            var sut: PaymentInputInteractor!
            var presenterMock: PaymentInputPresenterMock!
            var workerMock: AuthenticationWorkerMock!
            var currentUser:Client!
            var payToUser: Client!
            beforeEach {
                workerMock = AuthenticationWorkerMock()
                sut = PaymentInputInteractor(worker: workerMock)
                presenterMock = PaymentInputPresenterMock()
                sut.presenter = presenterMock
                currentUser = Client()
                currentUser.userName = "Alice"
                currentUser.balance = 100
                
                payToUser = Client()
                payToUser.userName = "Bob"
                payToUser.balance = 100
            }

            context("Pay Amount") {
                it("when payAmount is called. function must run successfully") {
                    sut.payAmount(amount: 50, fromUser: currentUser, toUser: payToUser)
                    expect(workerMock.isPayAmountCalled).to(beTrue())
                }
            }

            context("Payment success") {
                it("when didSuccessPayment is called. function must run successfully") {
                    sut.didSuccessPayment(acutalTransferredAmount: nil, transferredTo: nil)
                    expect(presenterMock.didSuccessPaymentCalled).to(beTrue())
                }
            }

            context("Payment failed") {
                it("when didFailPayment is called failed. function must run successfully") {
                    sut.didFailPayment()
                    expect(presenterMock.didFailPaymentCalled).to(beTrue())
                }
            }
        }
    }
}
