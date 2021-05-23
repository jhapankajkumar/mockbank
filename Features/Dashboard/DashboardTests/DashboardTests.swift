//
//  DashboardTests.swift
//  DashboardTests
//
//  Created by pankaj.k.jha on 21/5/21.
//


import Nimble
import Quick
import CoreData
@testable import Dashboard
@testable import AuthenticationWorker
@testable import DataService
@testable import Domains
@testable import Common
class HomeScreenViewMock: HomeScreenPresenterToView {
    
    var presenter: HomeScreenViewToPresenter?
    var initialSetupCalled = false
    func initialSetup() {
        initialSetupCalled = true
    }
    
    var setupViewCalled = false
    func setupView() {
        setupViewCalled = true
    }
    var updateViewCalled = false
    func updateView(viewModel: HomeScreenViewModel?) {
        updateViewCalled = true
    }
    
    var showLoadingCalled = false
    func showLoading() {
        showLoadingCalled = true
    }
    
    var hideLoadingCalled = false
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    var showBalanceAlertCalled = false
    func showLowBalanceAlert() {
        showBalanceAlertCalled = true
    }
    
    var isShowErrorCalled = false
    func showError() {
        isShowErrorCalled = true
    }
    
}

class HomeScreenPresenterMock: HomeScreenInteractorToPresenter {
    var getUserDataCalled = false
    func didGetUserData(user: Client) {
        getUserDataCalled = true
    }
    
    var getUserDataFailedCalled = true
    func didFailTogetUserData() {
        getUserDataCalled = false
    }
}

class HomeScreenInteractorMock: HomeScreenPresenterToInteractor {
    var presenter: HomeScreenInteractorToPresenter?
    
    var isGetUserDataCalled = false
    func getUserData(userName: String) {
        isGetUserDataCalled = true
    }
}

class HomeScreenRouterMock: HomeScreenPresenterToRouter {
    var isNavigateToLoginCalled = false
    func navigateToLogin(from view: HomeScreenPresenterToView?) {
        isNavigateToLoginCalled = true
    }
    
    var isNavigateToPaymentCalled = false
    func navigateToPayment(from view: HomeScreenPresenterToView?, currentUser: Client) {
        isNavigateToPaymentCalled = true
    }
    
    var isNavigateToTopupCalled = false
    func navigateToTopup(from view: HomeScreenPresenterToView?, currentUser: Client) {
        isNavigateToTopupCalled = true
    }
}

class AuthenticationWorkerMock: AuthenticationWorkerProtocol {
    var loginDelegate: UserLoginProtocol? = nil
    
    var userDataDelegate: UserDataProtocol?
    
    var topupDelegate: TopupAmountProtocol? = nil
    
    var userListDelegate: FetchUserListProtocol? = nil
    
    var paymentDelegate: PaymentProtocol? = nil
    
    var userStatusDelegate: UserBalanceStatusProtocol? = nil
    func doLogin(with user: Client) {}
    
    var getUserDataCalled = false
    func getUserData(from userName: String) {
        getUserDataCalled = true
    }
    
    func topupAmount(amount: Double, for user: String) {}
    
    func fetchUserList() {}
    
    func payAmount(amount: Double, fromUser: Client, toUser: Client) {}
}
class DashboardTests: QuickSpec {
    override func spec() {
        describe("HomeScreenPresenter") {
            var sut: HomeScreenPresenter!
            var viewMock: HomeScreenViewMock!
            var interactorMock: HomeScreenInteractorMock!
            var routerMock: HomeScreenRouterMock!
            var userName: String!
            beforeEach {
                userName = "Alice"
                sut = HomeScreenPresenter(userName: userName)
                viewMock = HomeScreenViewMock()
                interactorMock = HomeScreenInteractorMock()
                routerMock = HomeScreenRouterMock()
                sut.view = viewMock
                sut.router = routerMock
                sut.interactor = interactorMock
            }
            context("DidLoad called") {
                it("DidLoad, function must run successfully") {
                    sut.didLoad()
                    expect(viewMock.initialSetupCalled).to(beTrue())
                }
            }
            
            context("ViewWillAppear  called") {
                it("ViewWillAppear, function must run successfully") {
                    sut.viewWillAppear()
                    expect(viewMock.setupViewCalled).to(beTrue())
                    expect(viewMock.showLoadingCalled).to(beTrue())
                    expect(interactorMock.isGetUserDataCalled).to(beTrue())
                }
            }
            
            context("Logout success called") {
                it("logout success, function must run successfully") {
                    sut.logoutButtonTapped()
                    expect(routerMock.isNavigateToLoginCalled).to(beTrue())
                }
            }

            context("Topup called failed") {
                it("Topup failed, function must failed to navigate to topup") {
                    sut.topupButtonTapped()
                    expect(routerMock.isNavigateToTopupCalled).to(beFalse())
                }
            }
            
            context("Topup called success") {
                it("Topup Success, function must to navigate to topup") {
                    var client = Client()
                    client.userName = "Alice"
                    client.balance = 100
                    sut.userData = client
                    sut.topupButtonTapped()
                    expect(routerMock.isNavigateToTopupCalled).to(beTrue())
                }
            }
            
            context("Payment called failed") {
                it("Payment failed, function must failed to navigate to Payment") {
                    sut.paymentButtonTapped()
                    expect(routerMock.isNavigateToPaymentCalled).to(beFalse())
                    expect(viewMock.showBalanceAlertCalled).to(beTrue())
                }
            }
            
            context("Payment called success") {
                it("Payment Success, function must to navigate to Payment") {
                    var client = Client()
                    client.userName = "Alice"
                    client.balance = 100
                    sut.userData = client
                    sut.paymentButtonTapped()
                    expect(routerMock.isNavigateToPaymentCalled).to(beTrue())
                }
            }
            
            context("DidGetUserData success") {
                it("DidGetUserData Success, function must run successfully") {
                    var client = Client()
                    client.userName = "Alice"
                    client.balance = 100
                    var debtClients: [DebtClient] = []
                    var debtClient = DebtClient()
                    debtClient.dueAmount = 100
                    debtClient.status = .payee
                    debtClient.payerPayee = "Bob"
                    debtClients.append(debtClient)
                    client.debtClients = debtClients
                    
                    sut.didGetUserData(user: client)
                    expect(sut.userData != nil).to(beTrue())
                    expect(sut.userData?.userName == "Alice").to(beTrue())
                    expect(sut.userData?.balance == 100).to(beTrue())
                    expect(sut.userData?.debtClients?.count == 1).to(beTrue())
                    expect(viewMock.hideLoadingCalled).to(beTrue())
                    expect(viewMock.updateViewCalled).to(beTrue())
                }
            }
            
            context("DidGetUserData failed") {
                it("DidGetUserData Failed, function must run successfully") {
                    sut.didFailTogetUserData()
                    expect(viewMock.hideLoadingCalled).to(beTrue())
                    expect(viewMock.isShowErrorCalled).to(beTrue())
                }
            }
        }
        describe("HomeScreenInteractor") {
            var sut: HomeScreenInteractor!
            var presenterMock: HomeScreenPresenterMock!
            var workerMock: AuthenticationWorkerMock!
            var client: Client!
            beforeEach {
                workerMock = AuthenticationWorkerMock()
                sut = HomeScreenInteractor(worker: workerMock)
                presenterMock = HomeScreenPresenterMock()
                sut.presenter = presenterMock
                client = Client()
                client.balance = 100
                client.userName = "Alice"
            }

            context("GetUserData Called") {
                it("when GetUserData is called. function must run successfully") {
                    sut.getUserData(userName: "Alice")
                    expect(workerMock.getUserDataCalled).to(beTrue())
                }
            }

            context("DidGetUserData success") {
                it("when DidGetUserData is called. function must run successfully") {
                    sut.didFetchUserData(user: client)
                    expect(presenterMock.getUserDataCalled).to(beTrue())
                }
            }

            context("DidGetUserData failed") {
                it("when DidGetUserData is called failed. function must run successfully") {
                    sut.didFailtToFetchUserData()
                    expect(presenterMock.getUserDataFailedCalled).to(beTrue())
                }
            }
        }
    }
}


