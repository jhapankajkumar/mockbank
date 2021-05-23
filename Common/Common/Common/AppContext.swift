//
//  RemoteConfig.swift
//  Common
//
//  Created by pankaj.k.jha on 23/5/21.
//

import Foundation
public protocol AppContextProtocol {
    var transferedAmount: Double? {get set}
    var transferedTo: String? {get set}
}

public class AppContext: AppContextProtocol {
    public static var shared = AppContext()
    let userDefault = UserDefaults.standard
    public var transferedAmount: Double? {
        get {
            return self.userDefault.double(forKey: "transferedAmount")
        }
        set {
            self.userDefault.set(newValue, forKey: "transferedAmount")
        }
    }

    public var transferedTo: String? {
        get {
            return self.userDefault.string(forKey: "transferedTo")
        }
        set {
            self.userDefault.set(newValue, forKey: "transferedTo")
        }
    }
}
