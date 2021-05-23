//
//  SplashViewView.swift
//  Splash
//
//  Created by pankaj.k.jha on 21/5/21.
//

import UIKit
import Common

class SplashViewView: UIViewController, SplashViewPresenterToView {
    var presenter: SplashViewViewToPresenter?
    init() {
        super.init(nibName: String(describing: SplashViewView.self), bundle: Bundle(for: SplashViewView.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MKColor.screenBackgroundColor.get()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Perform initial operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            self?.navigationController?.isNavigationBarHidden = false
            self?.presenter?.navigateToLogin()
        }
    }
}
