//
//  ClothGroupObject.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation

struct ClothGroupObject: Decodable, Identifiable {
    var id: String = UUID().uuidString
    var folderId: Int
    var folderName: String
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case folderId = "folder_id"
        case folderName = "folder_name"
        case userId = "id"
    }
    
    static let stubList: [ClothGroupObject] = [
    
        ClothGroupObject(
            folderId: 1,
            folderName: "제주도 여행",
            userId: 123
        ),
        ClothGroupObject(
            folderId: 2,
            folderName: "졸업식",
            userId: 123
        ),
        ClothGroupObject(
            folderId: 3,
            folderName: "강릉",
            userId: 123
        ),
    ]
}
