//
//  FindFriendsViewController.swift
//  Exchangeagram
//
//  Created by Caye on 8/7/20.
//  Copyright © 2020 caye. All rights reserved.
//

import UIKit

class FindFriendsViewController: UIViewController {
    
    var users = [User]()
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 71
    }
}

extension FindFriendsViewController: FindFriendsCellDelegate {
    func didTapFollowButton(_ followButton: UIButton, on cell: FindFriendsCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }

        followButton.isUserInteractionEnabled = false
        let followee = users[indexPath.row]

        FollowService.setIsFollowing(!followee.isFollowed, fromCurrentUserTo: followee) { (success) in
            defer {
                followButton.isUserInteractionEnabled = true
            }

            guard success else { return }

            followee.isFollowed = !followee.isFollowed
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension FindFriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindFriendsCell") as! FindFriendsCell
        cell.delegate = self
        configure(cell: cell, atIndexPath: indexPath)

        return cell
    }

    func configure(cell: FindFriendsCell, atIndexPath indexPath: IndexPath) {
        let user = users[indexPath.row]

        cell.usernameLabel.text = user.username
        cell.followButton.isSelected = user.isFollowed
    }
    
}
