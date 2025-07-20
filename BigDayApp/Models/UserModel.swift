//
//  UserModel.swift
//  BigDayApp
//
//  Created by Davy Sousa on 27/06/25.
//
// UserModel.swift
import Foundation

struct UserModel {
    let uid: String
    let nickname: String
    let email: String
    let photoURL: String?
    
    init?(document: [String: Any], uid: String) {
        guard let nickname = document["nickname"] as? String,
              let email = document["email"] as? String else {
            return nil
        }
        self.uid = uid
        self.nickname = nickname
        self.email = email
        self.photoURL = document["photoURL"] as? String
    }
}

