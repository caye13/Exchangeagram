//
//  StorageReference+Post.swift
//  Exchangeagram
//
//  Created by Ck2 Jedi on 8/7/20.
//  Copyright © 2020 caye. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    static let dateFormatter = ISO8601DateFormatter()

    static func newPostImageReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())

        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}
