//
//  PaymentLandingView.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import UIKit
import Common
class PaymentLandingView: UIViewController, PaymentLandingPresenterToView {

    var presenter: PaymentLandingViewToPresenter?
    var loadingView: MKLoadingView?
    @IBOutlet var noUserFound: UILabel!
    @IBOutlet var userTable: UITableView!
    init() {
        super.init(nibName: String(describing: PaymentLandingView.self), bundle: Bundle(for: PaymentLandingView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    func initialSetup() {
        userTable.isHidden = true
        noUserFound.isHidden = true
        self.title = "Payment"
        userTable.delegate = self
        userTable.dataSource = self
        userTable.register(UINib(nibName: String(describing: UserListTableViewCell.self),
                                    bundle: Bundle(for: UserListTableViewCell.self)),
                                    forCellReuseIdentifier: UserListTableViewCell.reuseIdentifier)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.isNavigationBarHidden = false
    }
    func showLoading() {
        if loadingView?.superview == nil {
            loadingView = MKLoadingView(attachTo: self.view)
        }
    }
    func hideLoading() {
        loadingView?.dismiss()
    }
    
    func reloadTable() {
        userTable.isHidden = false
        userTable.reloadData()
    }
    
    func showNoUser() {
        userTable.isHidden = true
        noUserFound.isHidden = false
    }
    
}

extension PaymentLandingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = presenter?.dataForIndexPath(indexPath: indexPath) else {
            return UITableViewCell()
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.reuseIdentifier) as? UserListTableViewCell {
            cell.updateData(user: data)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension PaymentLandingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAtIndexPath(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
