//
//  AuthenticationTests.swift
//  AuthenticationTests
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Nimble
import Quick
import CoreData
@testable import Authentication
@testable import AuthenticationWorker
@testable import DataService
@testable import Domains
@testable import Common
class LoginScreenViewMock: LoginScreenPresenterToView {
    var initialSetupCalled = false
    func initialSetup() {
        initialSetupCalled = true
    }
    
    var presenter: LoginScreenViewToPresenter?
    var isShowError = false
    func showError() {
        isShowError = true
    }
}

class LoginScreenPresenterMock: LoginScreenInteractorToPresenter {
    var loginSuccess = false
    func didSuccessLogin() {
        loginSuccess = true
    }
    
    var loginFailed = false
    func didFailLogin() {
        loginFailed = true
    }
}

class LoginScreenInteractorMock: LoginScreenPresenterToInteractor {
    var presenter: LoginScreenInteractorToPresenter?
    var isLoginCalled = false
    func login(with user: Client) {
        isLoginCalled = true
    }
}

class LoginScreenRouterMock: LoginScreenPresenterToRouter {
    var isNavigateToDashBoardCalled = false
    func navigateToDashboard(from view: LoginScreenPresenterToView?, userName: String) {
        isNavigateToDashBoardCalled = true
    }
}

class AuthenticationWorkerMock: AuthenticationWorkerProtocol {
    var loginDelegate: UserLoginProtocol?
    
    var userDataDelegate: UserDataProtocol? = nil
    
    var topupDelegate: TopupAmountProtocol? = nil
    
    var userListDelegate: FetchUserListProtocol? = nil
    
    var paymentDelegate: PaymentProtocol? = nil
    
    var userStatusDelegate: UserBalanceStatusProtocol? = nil
    var loginCalled = false
    func doLogin(with user: Client) {
        loginCalled = true
    }
    
    func getUserData(from userName: String) {}
    
    func topupAmount(amount: Double, for user: String) {}
    
    func fetchUserList() {}
    
    func payAmount(amount: Double, fromUser: Client, toUser: Client) {}
}

class AuthenticationTests: QuickSpec {
    override func spec() {
        describe("LoginScreenPresenter") {
            var sut: LoginScreenPresenter!
            var viewMock: LoginScreenViewMock!
            var interactorMock: LoginScreenInteractorMock!
            var routerMock: LoginScreenRouterMock!
            
            beforeEach {
                sut = LoginScreenPresenter()
                viewMock = LoginScreenViewMock()
                interactorMock = LoginScreenInteractorMock()
                routerMock = LoginScreenRouterMock()
                sut.view = viewMock
                sut.router = routerMock
                sut.interactor = interactorMock
            }
            context("ViewDidLoad called") {
                it("ViewDidLoad, function must run successfully") {
                    sut.didLoad()
                    expect(viewMock.initialSetupCalled).to(beTrue())
                }
            }
            
            context("Login  called") {
                it("login, function must run successfully") {
                    sut.login(with: "Alice")
                    expect(interactorMock.isLoginCalled).to(beTrue())
                }
            }
            
            context("Login success called") {
                it("login success, function must run successfully") {
                    sut.didSuccessLogin()
                    expect(routerMock.isNavigateToDashBoardCalled).to(beTrue())
                }
            }
            
            context("Login Failure called") {
                it("login failed, function must run successfully") {
                    sut.didFailLogin()
                    expect(viewMock.isShowError).to(beTrue())
                }
            }
        }
        describe("LoginScreenInteractor") {
            var sut: LoginScreenInteractor!
            var presenterMock: LoginScreenPresenterMock!
            var workerMock: AuthenticationWorkerMock!
            var client: Client!
            beforeEach {
                workerMock = AuthenticationWorkerMock()
                sut = LoginScreenInteractor(worker: workerMock)
                presenterMock = LoginScreenPresenterMock()
                sut.presenter = presenterMock
                client = Client()
                client.balance = 100
                client.userName = "Alice"
            }

            context("Login Called") {
                it("when Login is called. function must run successfully") {
                    sut.login(with: client)
                    expect(workerMock.loginCalled).to(beTrue())
                }
            }
            
            context("Navigate To Dashboard on success login") {
                it("when Login is success user should navigate to Dashboard.") {
                    sut.didSuccessLogin()
                    expect(presenterMock.loginSuccess).to(beTrue())
                }
            }
            
            context("Login Failed") {
                it("when Login is success user should navigate to Dashboard.") {
                    sut.didFailLogin()
                    expect(presenterMock.loginFailed).to(beTrue())
                }
            }
        }
    }
}
