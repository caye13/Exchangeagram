//
//  FindFriendsCell.swift
//  Exchangeagram
//
//  Created by Caye on 8/8/20.
//  Copyright © 2020 caye. All rights reserved.
//

import UIKit

protocol FindFriendsCellDelegate: class {
    func didTapFollowButton(_ followButton: UIButton, on cell: FindFriendsCell)
}

class FindFriendsCell: UITableViewCell {
    
    weak var delegate: FindFriendsCellDelegate?

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    
   override func awakeFromNib() {
        super.awakeFromNib()

        followButton.layer.borderColor = UIColor.lightGray.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 6
        followButton.clipsToBounds = true

        followButton.setTitle("Follow", for: .normal)
        followButton.setTitle("Following", for: .selected)
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        delegate?.didTapFollowButton(sender, on: self)
    }
}
