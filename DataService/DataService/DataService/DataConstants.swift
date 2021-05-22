//
//  DataConstants.swift
//  DataService
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
public typealias DBC = DBConstants
public struct DBConstants {
    public static let databaseName: String = "MockBank"
    public static let userTable: String = "User"
    public static let debtTable:String = "Debt"
    
    public static let nameKey: String = "name"
    public static let balanceKey: String = "balance"
    
    public static let amountKey: String = "amount"
    public static let payerKey: String = "payer"
    public static let payeeKey: String = "payee"
}
