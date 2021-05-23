//
//  TopupLandingView.swift
//  Topup
//
//  Created by pankaj.k.jha on 22/5/21.
//

import UIKit
import Common
class TopupLandingView: UIViewController, TopupLandingPresenterToView {
    
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var topupButton: MKUIButton!
    var presenter: TopupLandingViewToPresenter?
    var loadingView: MKLoadingView?
    var amount: String? = ""
    @IBOutlet var container: UIView!
    init() {
        super.init(nibName: String(describing: TopupLandingView.self), bundle: Bundle(for: TopupLandingView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topupButton.isActive = false
        amountTextField.delegate = self
        amountTextField.keyboardType = .decimalPad
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonTapped))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.amountTextField.inputAccessoryView = doneToolbar
    }
    
    func showLoading() {
        if loadingView?.superview == nil {
            loadingView = MKLoadingView(attachTo: self.view)
        }
    }
    func hideLoading() {
        loadingView?.dismiss()
    }
    
    func showError() {
        
    }
    @IBAction func didTapTopupButton(_ sender: Any) {
        amountTextField.resignFirstResponder()
        if let amount = Double(amount ?? "") {
            presenter?.topupAmount(amount: amount)
        }
    }
    
    @objc
    func doneButtonTapped() {
        amount = amountTextField.text
        amountTextField.resignFirstResponder()
    }
}
