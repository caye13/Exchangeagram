//
//  PostHeaderCell.swift
//  Exchangeagram
//
//  Created by Caye on 8/8/20.
//  Copyright © 2020 caye. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell {
    
    static let height: CGFloat = 54

    @IBOutlet var usernameLable: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
    }
    
}
