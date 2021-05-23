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
        //Perform initial operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {[weak self] in
            self?.presenter?.navigateToLogin()
        }
    }
}
