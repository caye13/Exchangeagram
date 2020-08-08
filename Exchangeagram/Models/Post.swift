//
//  Post.swift
//  Exchangeagram
//
//  Created by Caye on 8/7/20.
//  Copyright © 2020 caye. All rights reserved.
//

import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Post {
        var key: String?
        let imageURL: String
        let imageHeight: CGFloat
        let creationDate: Date
        var likeCount: Int
        let poster: User
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        let userDict = ["uid" : poster.uid,
                        "username" : poster.username]

        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "created_at" : createdAgo,
                "like_count" : likeCount,
                "poster" : userDict]
    }
        
    init(imageURL: String, imageHeight: CGFloat) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
        self.likeCount = 0
        self.poster = User.current
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let imageURL = dict["image_url"] as? String,
            let imageHeight = dict["image_height"] as? CGFloat,
            let createdAgo = dict["created_at"] as? TimeInterval
            else { return nil }
           
            let likeCount = dict["like_count"] as? Int,
            let userDict = dict["poster"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String
            else { return nil }

        self.key = snapshot.key
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        self.likeCount = likeCount!
        self.poster = User(uid: uid, username: username)
    }

    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
  
        let currentUser = User.current
    
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
     
        let dict = post.dictValue
        
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        //5
        postRef.updateChildValues(dict)
    }
}
