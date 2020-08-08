//
//  PostActionCell.swift
//  Exchangeagram
//
//  Created by Caye on 8/8/20.
//  Copyright © 2020 caye. All rights reserved.
//

import UIKit

class PostActionCell: UITableViewCell {
  
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func likeButtonTapper(_ sender: UIButton) {
    }
    
}
