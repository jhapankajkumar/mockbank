//
//  LoginScreenView.swift
//  Authentication
//
//  Created by pankaj.k.jha on 21/5/21.
//

import UIKit
import Common
class LoginScreenView: UIViewController, LoginScreenPresenterToView {
    var presenter: LoginScreenViewToPresenter?
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var loginButton: MKUIButton!
    @IBOutlet weak var textFieldContainer: UIView!
    var userName:String?
    init() {
        super.init(nibName: String(describing: LoginScreenView.self), bundle: Bundle(for: LoginScreenView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        loginButton.isActive = false
        userNameTextField.delegate = self
        super.viewDidLoad()
        
        self.view.backgroundColor = MKColor.screenBackgroundColor.get()
        
        decorateBox()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Login"
    }
    func decorateBox() {
        container.decorateView()
        textFieldContainer.decorateView()
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        userNameTextField.resignFirstResponder()
        if let userName = self.userName {
            print("> Login \(userName.capitalized)\n")
            presenter?.login(with: userName)
        }
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
        self.userNameTextField.inputAccessoryView = doneToolbar
    }
@objc
    func doneButtonTapped() {
        userName = userNameTextField.text
        userNameTextField.resignFirstResponder()
    }
    
    func showError()  {
        let alert = UIAlertController(title: "Alert", message: "Login failed please try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


