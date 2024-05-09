//
//  Comment.swift
//  Cleset
//
//  Created by 엄태양 on 5/2/24.
//

import Foundation

struct Comment: Decodable {
    let commentId: Int
    let commentBody: String
    let createdDate: String
    let updatedDate: String
    let postId: Int
    let id: Int
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case commentBody = "comment_body"
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case postId = "post_id"
        case id
        case nickname
    }
    
    static var stubList: [Comment] = [
        Comment(
            commentId: 1,
            commentBody: "좋은 정보 감사합니다!\n다른 내용도 많이 올려주세요!",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-07T00:00:00",
            postId: 1,
            id: 123,
            nickname: "Tester5"
        ),
        Comment(
            commentId: 2,
            commentBody: "너무 멋있어요!",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-07T00:00:00",
            postId: 1,
            id: 123,
            nickname: "Tester4"
        ),
        Comment(
            commentId: 3,
            commentBody: "저도 따라해보고 싶네요~",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-07T00:00:00",
            postId: 2,
            id: 123,
            nickname: "Tester3"
        ),
        Comment(
            commentId: 4,
            commentBody: "처음 보는 방법이에요",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-07T00:00:00",
            postId: 1,
            id: 123,
            nickname: "Tester1"
        ),Comment(
            commentId: 5,
            commentBody: "저도 이렇게 하고 있습니다",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-07T00:00:00",
            postId: 2,
            id: 123,
            nickname: "Tester2"
        )
    ]
}
