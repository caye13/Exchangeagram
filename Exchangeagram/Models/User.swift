//
//  User.swift
//  Exchangeagram
//
//  Created by Caye on 8/7/20.
//  Copyright © 2020 caye. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: Codable {
    
    var isFollowed = false

    let uid: String
    let username: String

    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }

        self.uid = snapshot.key
        self.username = username
    
    }
    
    private static var _current: User?

    static var current: User {
        
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }

        return currentUser
    }

    static func setCurrent(_ user: User) {
        _current = user
    }
    
    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        // 2
        if writeToUserDefaults {
            // 3
            if let data = try? JSONEncoder().encode(user) {
                // 4
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
            }
        }

        _current = user
    }

}
