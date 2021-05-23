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

    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var transferLabel: UILabel!
    @IBOutlet weak var transferLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var debtTable: UITableView!
    var appContext: AppContextProtocol? = AppContext.shared
    var viewModel: HomeScreenViewModel?
    var loadingView: MKLoadingView?
    init() {
        super.init(nibName: String(describing: HomeScreenView.self), bundle: Bundle(for: HomeScreenView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didLoad()
    }
    func initialSetup() {
        self.title = "Home"
        debtTable.dataSource = self
        debtTable.backgroundColor = .clear
        debtTable.register(UINib(nibName: String(describing: DebtTableViewCell.self),
                                    bundle: Bundle(for: DebtTableViewCell.self)),
                                    forCellReuseIdentifier: DebtTableViewCell.reuseIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    func setupView() {
        if let amount = appContext?.transferedAmount , let transferTo = appContext?.transferedTo {
            print("Transfered \(amount) to \(transferTo)")
            self.transferLabel.isHidden = false
            self.transferLabel.text = "Transferred \(amount) to \(transferTo.capitalized)."
            self.transferLabelHeight.constant = MKUIConstant.transferLabelHeight
            appContext?.transferedAmount = nil
            appContext?.transferedTo = nil
        } else {
            self.transferLabel.isHidden = true
        }
        addLogoutButton()
        decorateBox()
    }
    func decorateBox() {
        buttonContainer.decorateView()
    }
    func addLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout(_:)))
    }
    func updateView(viewModel: HomeScreenViewModel?) {
        self.viewModel = viewModel
        self.balance.text = "\(viewModel?.balance ?? 0.0)"
        self.userName.text = "Hello, \(viewModel?.userName ?? "")!"
        
        print("Hello \(self.userName.text ?? "")\n")
        print("Your Balance is \(viewModel?.balance ?? 0.0)")
        if viewModel?.debtClients?.count ?? 0 > 0 {
            debtTable.isHidden = false
            debtTable.reloadData()
        } else {
            debtTable.isHidden = true
        }
        
    }
    func showLowBalanceAlert() {
        let alert = UIAlertController(title: "Alert", message: "You have insufficient balance, please topup first and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showError() {
        let alert = UIAlertController(title: "Alert", message: "Could not fetch user data, please login again", preferredStyle: .alert)
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

extension HomeScreenView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.debtClients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel?.debtClients?.count ?? 0 {
            if let debtClient = viewModel?.debtClients?[indexPath.row] {
                if let cell = tableView.dequeueReusableCell(withIdentifier: DebtTableViewCell.reuseIdentifier) as? DebtTableViewCell {
                    cell.updateData(user: debtClient)
                    return cell
                }
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
