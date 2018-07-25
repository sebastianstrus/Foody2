//
//  User.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-07-24.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    var name: String!
    var email: String!
    var photoURL: String!
    var uid: String!
    var ref: DatabaseReference!
    
    init?(snapshot: DataSnapshot?) {
        guard let value = snapshot?.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let email = value["email"] as? String,
            let uid = value["uid"] as? String,
            let photoURL = value["photoURL"] as? String else { return nil }
        
        self.ref = snapshot?.ref
        self.name = name
        self.email = email
        self.uid = uid
        self.photoURL = photoURL
        self.name = name
    }
}
