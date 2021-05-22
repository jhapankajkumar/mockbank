//
//  DashboardWireframe.swift
//  Dashboard
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import UIKit
import Domains
public protocol DashboardWireframe: AnyObject {
    func navigateToPayment(from view: UIViewController, currentUser: Client)
    func navigateToTopup(from view: UIViewController, currentUser: Client)
    func navigateToLoginScreen(from view: UIViewController)
}
