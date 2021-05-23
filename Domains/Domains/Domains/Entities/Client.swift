//
//  User.swift
//  Domains
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
public struct Client {
    public var userName: String?
    public var balance: Double?
    public var status: ClientStatus?
    public var debtClients: [DebtClient]?
    public init () {}
}

public struct DebtClient {
    public var status: ClientStatus?
    public var dueAmount: Double?
    public var payerPayee: String?
    public init () {}
}

public enum ClientStatus {
    case payer
    case payee
    case noDue
}
