//
//  PostActionCell.swift
//  Exchangeagram
//
//  Created by Caye on 8/8/20.
//  Copyright © 2020 caye. All rights reserved.
//

import UIKit

protocol PostActionCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell)
}

class PostActionCell: UITableViewCell {
    
    weak var delegate: PostActionCellDelegate?
  
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func likeButtonTapper(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self)
    }
    
}
