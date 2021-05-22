//
//  AuthenticationWireframe.swift
//  Authentication
//
//  Created by pankaj.k.jha on 21/5/21.
//

import Foundation
import UIKit
public protocol AuthenticationWireframe: AnyObject {
    func navigateToDashboard(from view: UIViewController, currentUser: String)
}
