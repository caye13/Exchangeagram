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
    let paginationHelper = MGPaginationHelper<Post>(serviceMethod: UserService.timeline)
    
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

    func reloadTimeline() {
        self.paginationHelper.reloadData(completion: { [unowned self] (posts) in
            self.posts = posts

            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }

            self.tableView.reloadData()
        })
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
                let cell: PostHeaderCell = tableView.dequeueReusableCell()
                cell.usernameLable.text = post.poster.username

                return cell

            case 1:
                let cell: PostImageCell = tableView.dequeueReusableCell()
                let imageURL = URL(string: post.imageURL)
                cell.postImageView.kf.setImage(with: imageURL)

                return cell

            case 2:
                let cell: PostActionCell = tableView.dequeueReusableCell()
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section >= posts.count - 1 {
            paginationHelper.paginate(completion: { [unowned self] (posts) in
                self.posts.append(contentsOf: posts)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
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
