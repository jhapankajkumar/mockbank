//
//  PaymentInputView+Extension.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import Foundation
import UIKit

extension PaymentInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addDoneButtonOnKeyboard()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        amount = textField.text?.nameTrim
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let trimmedText = string.nameTrim
        if trimmedText.isEmpty && !string.isEmpty {
            return false
        } else if trimmedText == string {
            let maxLength = PaymentConstants.maxPaymentLimit
            guard let currentString: NSString = textField.text as NSString? else { return false }
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length >= PaymentConstants.minPaymentLimit {
                payButton.isActive = true
            } else {
                payButton.isActive = false
            }
            if newString.length == 0 {
                return true
            } else {
                return newString.length <= maxLength
            }
        } else {
            let maxLength = PaymentConstants.maxPaymentLimit
            if trimmedText.count <= maxLength {
                textField.text = trimmedText
            }
            return false
        }
    }
}
