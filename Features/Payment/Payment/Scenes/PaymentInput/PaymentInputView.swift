//
//  PaymentInputView.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import UIKit
import Common

class PaymentInputView: UIViewController, PaymentInputPresenterToView {
    var presenter: PaymentInputViewToPresenter?
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var payButton: MKUIButton!
    var loadingView: MKLoadingView?
    var amount: String? = ""
    @IBOutlet var container: UIView!
    init() {
        super.init(nibName: String(describing: PaymentInputView.self), bundle: Bundle(for: PaymentInputView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Input Amount"
        amountTextField.delegate = self
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
    
    @IBAction func didTapPayButton(_ sender: Any) {
        if let amount = Double(amount ?? "") {
            presenter?.payAmount(amount: amount)
        }
    }
    
    @objc
    func doneButtonTapped() {
        amount = amountTextField.text
        amountTextField.resignFirstResponder()
    }
}
