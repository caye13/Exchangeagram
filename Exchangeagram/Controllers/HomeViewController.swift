//
//  HomeViewController.swift
//  Exchangeagram
//
//  Created by Caye on 8/7/20.
//  Copyright © 2020 caye. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
   
    var posts = [Post]()
    let refreshControl = UIRefreshControl()

    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short

        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        reloadTimeline()
    }

    @objc func reloadTimeline() {
        UserService.timeline { (posts) in
            self.posts = posts

            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }

            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as! PostHeaderCell
            cell.usernameLabel.text = post.poster.username

            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell") as! PostImageCell
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)

            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            cell.delegate = self
            configureCell(cell, with: post)
            
            return cell
            

        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    func configureCell(_ cell: PostActionCell, with post: Post) {
        cell.timeAgoLabel.text = timestampFormatter.string(from: post.creationDate)
        cell.likeButton.isSelected = post.isLiked
        cell.likeCountLabel.text = "\(post.likeCount) likes"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height

        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight

        case 2:
            return PostHeaderCell.height

        default:
            fatalError()
        }
    }
}

extension HomeViewController: PostActionCellDelegate {
        
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }

        likeButton.isUserInteractionEnabled = false

        let post = posts[indexPath.section]

        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
   
            defer {
                likeButton.isUserInteractionEnabled = true
            }

            guard success else { return }

            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked

            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell
                else { return }
            
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }
}
