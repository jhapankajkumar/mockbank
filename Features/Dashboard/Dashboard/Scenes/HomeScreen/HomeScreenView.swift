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
    var loadingView: MKLoadingView?
    init() {
        super.init(nibName: String(describing: HomeScreenView.self), bundle: Bundle(for: HomeScreenView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    func updateView(viewModel: HomeScreenViewModel?) {
        self.balance.text = "\(viewModel?.balance ?? 0.0)".amountFormat
        self.userName.text = viewModel?.userName?.capitalized
        print("Hello \(self.userName.text ?? "")\n")
        print("Your Balance is \(viewModel?.balance ?? 0.0)")
        
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
