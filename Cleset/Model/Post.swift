//
//  Post.swift
//  Cleset
//
//  Created by 엄태양 on 5/1/24.
//

import Foundation

struct Post: Decodable, Identifiable {
    let id: String = UUID().uuidString
    let postId: Int
    let title: String
    let genre: String
    let postBody: String
    let fileName: String?
    let createdDate: String
    let updatedDate: String
    let userId: Int
    let nickname: String
    let commentCount: Int?
    var boardType: BoardType {
        return BoardType(rawValue: genre)!
    }
    var imageURL: URL? {
        get {
            if fileName == nil {
                return nil
            } else {
                return URL(string: "\(K.serverURL)/img/\(fileName!)")
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case title
        case genre
        case postBody = "post_body"
        case fileName = "file_name"
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case userId = "id"
        case nickname
        case commentCount = "comment_count"
    }
    
    static var stubList: [Post] = [
        Post(
            postId: 2,
            title: "Test Post2",
            genre: "tip",
            postBody: "테스트 포스팅입니다.",
            fileName: "clothImage5.jpeg",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-11T17:50:24",
            userId: 1,
            nickname: "SunEom",
            commentCount: Optional(1)
        ),
        Post(
            postId: 1,
            title: "Test Post",
            genre: "fashion",
            postBody: "테스트 포스팅입니다.",
            fileName: nil,
            createdDate: "2022-06-06T00:00:00",
            updatedDate: "2022-06-06T00:00:00",
            userId: 1,
            nickname: "SunEom",
            commentCount: Optional(5)
        )
    ]
    
}

struct PostDetail: Decodable {
    let post: Post
    let favorite: Int
    let favoriteCount: Int
    var favoriteBool: Bool {
        return favorite == 1
    }
    
    enum CodingKeys: String, CodingKey {
        case post = "postDto"
        case favorite
        case favoriteCount = "favorite_count"
    }
}

