//
//  DebtTableViewCell.swift
//  Dashboard
//
//  Created by pankaj.k.jha on 23/5/21.
//

import UIKit
import Common
class DebtTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    static let reuseIdentifier = String(describing: DebtTableViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(user: DebtUser) {
        if user.dueAmount ?? 0 > 0 {
            switch user.status {
            case .payer:
                print("You owe \(user.dueAmount ?? 0) to \(user.payerPayee ?? "")")
                self.descriptionLabel.text = "You owe \(user.dueAmount ?? 0) to \(user.payerPayee ?? "")."
                self.indicatorView.backgroundColor = MKColor.payerColor.get()
            case .payee:
                print("You owe \(user.dueAmount ?? 0) from \(user.payerPayee ?? "")")
                self.descriptionLabel.text = "You owe \(user.dueAmount ?? 0) from \(user.payerPayee ?? "")."
                self.indicatorView.backgroundColor = MKColor.payeeColor.get()
            default:
                break
            }
        }
    }
}
