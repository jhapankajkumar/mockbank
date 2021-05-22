//
//  String+Extension.swift
//  Common
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
class Formatter {
    public static var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 0
        formatter.numberStyle = .decimal
        return formatter
    }()
}

public extension String {
    var amountFormat: String {
        let amountFormatter = Formatter.amountFormatter
        amountFormatter.minimumFractionDigits = 2
        amountFormatter.maximumFractionDigits = 2
        if let value = amountFormatter.number(from: self) {
            return amountFormatter.string(from: value) ?? ""
        }
        return ""
    }
    var nameTrim: String {
        let validChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {validChars.contains($0) }
    }
}
