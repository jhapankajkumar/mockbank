//
//  UserListTableViewCell.swift
//  Payment
//
//  Created by pankaj.k.jha on 22/5/21.
//

import UIKit
import Domains
class UserListTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: UserListTableViewCell.self)
    @IBOutlet weak var userName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateData(user: Client) {
        userName.text = user.userName?.capitalized
    }
}
