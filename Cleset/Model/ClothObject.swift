//
//  ClothObject.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation

struct ClothObject: Decodable {
    var clothId: Int
    var name: String
    var season: String
    var category: String
    var brand: String
    var place: String
    var size: String
    var clothBody: String
    var fileName: String
    var createdDate: String
    var updatedDate: String
    var favorite: Int
    var id: Int
    
    var favBool: Bool {
        get { return favorite == 1 }
    }
    
    var imageUrl: URL? {
        get { return URL(string: "\(K.serverURL)/img/\(fileName)") }
    }
    
    enum CodingKeys: String, CodingKey {
        case clothId = "cloth_id"
        case name
        case season
        case category
        case brand
        case place
        case size
        case clothBody = "cloth_body"
        case fileName = "file_name"
        case createdDate = "created_date"
        case updatedDate = "updated_date"
        case favorite
        case id
    }
    
    
    static let stub: ClothObject = ClothObject(
        clothId: 1,
        name: "바지",
        season: "여름",
        category: "청바지",
        brand: "무신사 스탠다드",
        place: "장롱",
        size: "30",
        clothBody: "즐겨입는 청바지",
        fileName: "clothImage20.jpeg",
        createdDate: "2022-06-07T00:00:00",
        updatedDate: "2022-06-07T00:00:00",
        favorite: 0,
        id: 1
    )
    
    mutating func favToggle() {
        self.favorite = (self.favorite + 1) % 2
    }
}
