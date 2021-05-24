//
//  PaymentLandingTests.swift
//  PaymentTests
//
//  Created by pankaj.k.jha on 24/5/21.
//

import Nimble
import Quick
@testable import Payment
@testable import AuthenticationWorker
@testable import Domains

class PaymentLandingViewMock: PaymentLandingPresenterToView {
    
    var presenter: PaymentLandingViewToPresenter?
    var initialSetupCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var reloadTableCalled = false
    var showNoUserCalled = false
    func initialSetup() {
        initialSetupCalled = true
    }
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func reloadTable() {
        reloadTableCalled = true
    }
    
    func showNoUser() {
        showNoUserCalled = true
    }
}

class PaymentLandingPresenterMock: PaymentLandingInteractorToPresenter {
    var fetchUserListCalled = false
    func didSuccessFetchUserList(users: [Client]) {
        fetchUserListCalled = true
    }
    
    var didFailFetchUserListCalled = false
    func didFailFetchUserList() {
        didFailFetchUserListCalled = true
    }
}

class PaymentLandingInteractorMock: PaymentLandingPresenterToInteractor {
    var presenter: PaymentLandingInteractorToPresenter?
    var fetchUserListCalled = false
    func fetchUserList() {
        fetchUserListCalled = true
    }
}

class PaymentLandingRouterMock: PaymentLandingPresenterToRouter {
    var isNavigateToPaymentInputCalled = false
    func navigateToPaymentInput(from view: PaymentLandingPresenterToView?, currentUser: Client, payTo: Client) {
        isNavigateToPaymentInputCalled = true
    }
    var isNavigateToDashbordCalled = false
    func navigateToDashboard(from view: PaymentLandingPresenterToView?) {
        isNavigateToPaymentInputCalled = true
    }
}

class AuthenticationWorkerMock: AuthenticationWorkerProtocol {
    var loginDelegate: UserLoginProtocol? = nil
    
    var userDataDelegate: UserDataProtocol? = nil
    
    var topupDelegate: TopupAmountProtocol? = nil
    
    var userListDelegate: FetchUserListProtocol?
    
    var paymentDelegate: PaymentProtocol? = nil
    
    func doLogin(with user: Client) {}
    func getUserData(from userName: String) {}
    
    func topupAmount(amount: Double, for user: String) {}
    var isFetchUserListCalled = false
    func fetchUserList() {
        isFetchUserListCalled = true
    }
    
    var isPayAmountCalled = false
    func payAmount(amount: Double, fromUser: Client, toUser: Client) {
        isPayAmountCalled = true
    }
}

class PaymentLandingTests: QuickSpec {

    override func spec() {
        describe("PaymentLandingPresenter") {
            var sut: PaymentLandingPresenter!
            var viewMock: PaymentLandingViewMock!
            var interactorMock: PaymentLandingInteractorMock!
            var routerMock: PaymentLandingRouterMock!
            var currentUser:Client!
            var userList:[Client]!
            beforeEach {
                currentUser = Client()
                currentUser.userName = "Alice"
                currentUser.balance = 100
                
                userList = []
                userList.append(currentUser)
                var user1 = Client()
                user1.userName = "Bob"
                user1.balance = 100
                
                var user2 = Client()
                user2.userName = "Jack"
                user2.balance = 50
                userList.append(user1)
                userList.append(user2)
                
                sut = PaymentLandingPresenter(currentUser: currentUser)
                viewMock = PaymentLandingViewMock()
                interactorMock = PaymentLandingInteractorMock()
                routerMock = PaymentLandingRouterMock()
                sut.view = viewMock
                sut.router = routerMock
                sut.interactor = interactorMock
            }
            context("DidLoad") {
                it("When viewDidLoad, function must run successfully") {
                    sut.viewDidLoad()
                    expect(viewMock.showLoadingCalled).to(beTrue())
                    expect(viewMock.initialSetupCalled).to(beTrue())
                    expect(interactorMock.fetchUserListCalled).to(beTrue())
                }
            }
            
            context("DidFetchUserLilst Success") {
                it("When didSuccessFetchUserList, function must run successfully") {
                    sut.didSuccessFetchUserList(users: userList)
                    expect(viewMock.hideLoadingCalled).to(beTrue())
                    expect(viewMock.reloadTableCalled).to(beTrue())
                    expect(sut.numberOfRows() == 2).to(beTrue())
                    let user1 = sut.userList?[0]
                    expect(user1?.userName == "Bob").to(beTrue())
                }
            }
            
            context("DidFetchUserLilst  Success no user ") {
                it("When didSuccessFetchUserList, function must run successfully") {
                    sut.didSuccessFetchUserList(users: [])
                    expect(viewMock.hideLoadingCalled).to(beTrue())
                    expect(viewMock.showNoUserCalled).to(beTrue())
                }
            }
            
            context("DidFetchUserLilst failed ") {
                it("When didFailFetchUserList failed, function must run successfully") {
                    sut.didFailFetchUserList()
                    expect(viewMock.hideLoadingCalled).to(beTrue())
                    expect(viewMock.showNoUserCalled).to(beTrue())
                }
            }
            
            context("DidSelectRow") {
                it("When didSelectRowAtIndexPath, function must run successfully") {
                    sut.didSuccessFetchUserList(users: userList)
                    expect(viewMock.hideLoadingCalled).to(beTrue())
                    expect(viewMock.reloadTableCalled).to(beTrue())
                    expect(sut.numberOfRows() == 2).to(beTrue())
                    let user1 = sut.userList?[0]
                    expect(user1?.userName == "Bob").to(beTrue())
                    
                    sut.didSelectRowAtIndexPath(indexPath: IndexPath(row: 0, section: 0))
                    expect(routerMock.isNavigateToPaymentInputCalled).to(beTrue())
                }
            }
        }
        
        describe("PaymentLandingInteractor") {
            var sut: PaymentLandingInteractor!
            var presenterMock: PaymentLandingPresenterMock!
            var workerMock: AuthenticationWorkerMock!
            var client: Client!
            beforeEach {
                workerMock = AuthenticationWorkerMock()
                sut = PaymentLandingInteractor(worker: workerMock)
                presenterMock = PaymentLandingPresenterMock()
                sut.presenter = presenterMock
                client = Client()
                client.balance = 100
                client.userName = "Alice"
            }

            context("FetchUserList Called") {
                it("when fetchUserList is called. function must run successfully") {
                    sut.fetchUserList()
                    expect(workerMock.isFetchUserListCalled).to(beTrue())
                }
            }

            context("DidFetchUserList success") {
                it("when didSuccessFetchUserList is called. function must run successfully") {
                    sut.didSuccessFetchUserList(users: [])
                    expect(presenterMock.fetchUserListCalled).to(beTrue())
                }
            }

            context("DidFetchUserList failed") {
                it("when didFailToFetchUserList is called failed. function must run successfully") {
                    sut.didFailToFetchUserList()
                    expect(presenterMock.didFailFetchUserListCalled).to(beTrue())
                }
            }
        }
    }
}
