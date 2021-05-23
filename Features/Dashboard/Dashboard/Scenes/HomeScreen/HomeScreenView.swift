//
//  HomeScreenView.swift
//  Dashboard
//
//  Created by pankaj.k.jha on 21/5/21.
//

import UIKit
import Common
class HomeScreenView: UIViewController, HomeScreenPresenterToView {
    @IBOutlet weak var container: UIView!
    var presenter: HomeScreenViewToPresenter?
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var topupButton: MKUIButton!
    @IBOutlet weak var paymentButton: MKUIButton!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var debtStackView: UIStackView!
    var loadingView: MKLoadingView?
    init() {
        super.init(nibName: String(describing: HomeScreenView.self), bundle: Bundle(for: HomeScreenView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        addLogoutButton()
    }
    
    func addLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout(_:)))
    }
    func updateView(viewModel: HomeScreenViewModel?) {
        self.balance.text = "\(viewModel?.balance ?? 0.0)"
        self.userName.text = viewModel?.userName
        
        print("Hello \(self.userName.text ?? "")\n")
        print("Your Balance is \(viewModel?.balance ?? 0.0)")
        self.userStatus.isHidden = true
        viewModel?.debtClients?.forEach({ user in
            if user.dueAmount ?? 0 > 0 {
                switch user.status {
                case .payer:
                    self.userStatus.isHidden = false
                    print("You owe \(user.dueAmount ?? 0) to \(user.payerPayee ?? "")")
                    self.userStatus.text = "You owe \(user.dueAmount ?? 0) to \(user.payerPayee ?? "")"
                case .payee:
                    self.userStatus.isHidden = false
                    print("You owe \(user.dueAmount ?? 0) from \(user.payerPayee ?? "")")
                    self.userStatus.text = "You owe \(user.dueAmount ?? 0) from \(user.payerPayee ?? "")"
                default:
                    break
                }
            }
        })
    }
    func showLowBalanceAlert() {
        let alert = UIAlertController(title: "Alert", message: "You have insufficient balance, please topup first and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showLoading() {
        if loadingView?.superview == nil {
            loadingView = MKLoadingView(attachTo: self.view)
        }
    }
    func hideLoading() {
        loadingView?.dismiss()
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        print("See You soon \(self.userName.text ?? "")\n\n")
        presenter?.logoutButtonTapped()
    }
    @IBAction func didTapTopupButton(_ sender: Any) {
        presenter?.topupButtonTapped()
    }
    
    @IBAction func didTapPaymentButton(_ sender: Any) {
        presenter?.paymentButtonTapped()
    }
    
}
