//
//  UserObject.swift
//  Cleset
//
//  Created by 엄태양 on 4/24/24.
//

import Foundation

struct UserObject: Decodable {
    let id: Int
    let nickname: String
    let gender: String
    let age: Int
    let uid: String
}
