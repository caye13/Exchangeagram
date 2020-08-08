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
    
    init(imageURL: String, imageHeight: CGFloat) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
  
        let currentUser = User.current
    
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
     
        let dict = post.dictValue
        
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        //5
        postRef.updateChildValues(dict)
    }
    
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970

        return ["image_url" : imageURL,
                "image_height" : imageHeight,
                "created_at" : createdAgo]
    }
}
