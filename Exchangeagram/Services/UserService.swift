//
//  UserService.swift
//  Exchangeagram
//
//  Created by Caye on 8/7/20.
//  Copyright © 2020 caye. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }

            completion(user)
        })
    }
    
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }

            let dispatchGroup = DispatchGroup()

            let posts: [Post] = snapshot.reversed().compactMap {
                guard let post = Post(snapshot: $0)
                    else { return nil }

                dispatchGroup.enter()

                Post.isPostLiked(post) { (isLiked) in
                    post.isLiked = isLiked

                    dispatchGroup.leave()
                }

                return post
            }

            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        })
    }
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
  
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }

            let users = snapshot.compactMap(User.init).filter { $0.uid != currentUser.uid }

            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()

                FollowService.isUserFollowed(user) { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
}


