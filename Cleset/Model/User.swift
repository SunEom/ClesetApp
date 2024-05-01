//
//  UserObject.swift
//  Cleset
//
//  Created by 엄태양 on 4/24/24.
//

import Foundation

enum Gender: String, CaseIterable {
    case male = "남자"
    case female = "여자"
    case genderless = "비공개"
}

struct UserObject: Decodable {
    let id: Int
    let nickname: String
    let gender: String
    let age: Int
    let uid: String
    
    func toModel() -> UserModel {
        return UserModel(
            id: self.id,
            nickname: self.nickname,
            gender: Gender(rawValue: gender) ?? .male,
            age: self.age, uid: self.uid
        )
    }
    
    var genderImageName: String {
        get {
            switch gender {
                case "남자":
                    return "male"
                    
                case "여자":
                    return "female"
                    
                case "비공개":
                    return "genderless"
                    
                default :
                    return  ""
            }
        }
    }
    
    static var stub: UserObject = UserObject(id: -1, nickname: "홍길동", gender: "남자", age: 0, uid: "")
}

struct UserModel {
    let id: Int
    let nickname: String
    let gender: Gender
    let age: Int
    let uid: String
    
    var genderImageName: String {
        get {
            switch gender {
                case .male:
                    return "male"
                    
                case .female:
                    return "female"
                    
                case .genderless:
                    return "genderless"
            }
        }
    }
    
    static var stub = UserObject.stub.toModel()
}
