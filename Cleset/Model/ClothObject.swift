//
//  ClothObject.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation

enum Category: String, CaseIterable {
    case shirt = "상의"
    case pants = "하의"
    case onepiece = "한벌옷"
    case outer = "아우터"
    case cap = "모자"
    case shoes = "신발"
    case bag = "가방"
    case etc = "기타"
    
    var imageName: String {
        switch self {
            case .shirt:
                "shirt"
            case .pants:
                "pants"
            case .onepiece:
                "onepiece"
            case .outer:
                "outer"
            case .cap:
                "cap"
            case .shoes:
                "shoes"
            case .bag:
                "bag"
            case .etc:
                "etc"
        }
    }
}

enum Season {
    case spring
    case summer
    case fall
    case winter
    
    var imageName: String {
        switch self {
            case .spring:
                "spring"
            case .summer:
                "summer"
            case .fall:
                "fall"
            case .winter:
                "winter"
        }
    }
    
    var displayName: String {
        switch self {
            case .spring:
                "봄"
            case .summer:
                "여름"
            case .fall:
                "가을"
            case .winter:
                "겨울"
        }
    }
}

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
    
    var seasonList: [Season] {
        get {
            var list: [Season] = []
            
            if season.contains("봄") {
                list.append(.spring)
            }
            
            if season.contains("여름") {
                list.append(.summer)
            }
            
            if season.contains("가을") {
                list.append(.fall)
            }
            
            if season.contains("겨울") {
                list.append(.winter)
            }
                
            return list
        }
    }
    
    var displayDate: String {
        get {
            createdDate == updatedDate ? createdDate.getFormattedData() : updatedDate.getFormattedData() + "(수정됨)"
        }
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
        clothId: 20,
        name: "가드닝 셔츠원피스 우먼 IVORY",
        season: "봄, 여름",
        category: "한벌옷",
        brand: "KODAK",
        place: "옷장",
        size: "M",
        clothBody: "가드닝 활동에서 모티브를 받아 밝고 유쾌하게 풀어낸 KODAK GRADENING 컬렉션",
        fileName: "clothImage20.jpeg",
        createdDate: "2022-06-07T00:00:00",
        updatedDate: "2022-06-22T15:47:25",
        favorite: 1,
        id: 1
    )
    
    mutating func favToggle() {
        self.favorite = (self.favorite + 1) % 2
    }
    
    static let stubList = [
        ClothObject(
            clothId: 20,
            name: "가드닝 셔츠원피스 우먼 IVORY", 
            season: "봄, 여름",
            category: "한벌옷",
            brand: "KODAK",
            place: "옷장",
            size: "M",
            clothBody: "가드닝 활동에서 모티브를 받아 밝고 유쾌하게 풀어낸 KODAK GRADENING 컬렉션",
            fileName: "clothImage20.jpeg",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-22T15:47:25",
            favorite: 1,
            id: 1
        ),
        ClothObject(
            clothId: 17,
            name: "아미 - 화이트 / BZ0579", 
            season: "여름, 가을, 겨울",
            category: "신발",
            brand: "ADIDAS", 
            place: "신발장",
            size: "280",
            clothBody: "걷다보면 100번은 마주치게 되는 신발\n 요즘은 잘 안 신는듯...",
            fileName: "clothImage17.jpeg",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-11T16:54:21",
            favorite: 0,
            id: 1
        ),
        ClothObject(
            clothId: 3,
            name: "아르더 토트백_블랙",
            season: "겨울",
            category: "가방",
            brand: "매드고트",
            place: "옷장 가방 전용 수납 공간",
            size: "FREE",
            clothBody: "내가 가진 제일 비싼 가방 ",
            fileName: "clothImage3.jpeg",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-10T22:25:52",
            favorite: 0,
            id: 1
        ),
        ClothObject(
            clothId: 8,
            name: "10주년 T-SHIRTS", 
            season: "여름",
            category: "상의",
            brand: "그루브라임",
            place: "여름옷 상자",
            size: "L",
            clothBody: "그루브라임 10주년 기념 반팔티셔츠 에디션",
            fileName: "clothImage8.jpeg",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-10T22:24:34",
            favorite: 1,
            id: 1
        ),
        ClothObject(
            clothId: 5,
            name: "릴렉스드 베이식 블레이저 [블랙] ", 
            season: "봄, 가을",
            category: "아우터",
            brand: "무신사 스탠다드",
            place: "메인 옷장",
            size: "100",
            clothBody: "기본 아이템은 무탠다드!",
            fileName: "clothImage5.jpeg",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-10T22:22:32",
            favorite: 1,
            id: 1
        ),
        ClothObject(
            clothId: 4,
            name: "루키 언스트럭쳐 볼캡 NY (Black)", 
            season: "여름",
            category: "모자",
            brand: "MLB",
            place: "모자 걸이",
            size: "FREE",
            clothBody: "제일 자주 사용하는 모자",
            fileName: "clothImage4.jpeg",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-07T00:00:00",
            favorite: 0,
            id: 1
        ),
        ClothObject(
            clothId: 6,
            name: "어센틱 - 레드 / VN000EE3RED1", 
            season: "봄, 여름, 가을, 겨울",
            category: "신발",
            brand: "반스",
            place: "신발장",
            size: "270",
            clothBody: "빨간색이 매력적인 신발",
            fileName: "clothImage6.jpeg",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-07T00:00:00",
            favorite: 0,
            id: 1
        ),
        ClothObject(
            clothId: 7,
            name: "OORIGINAL BLACK - 조리 블랙",
            season: "여름",
            category: "신발",
            brand: "우포스",
            place: "신발장",
            size: "270",
            clothBody: "여름에는 슬리퍼!",
            fileName: "clothImage7.jpeg",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-07T00:00:00",
            favorite: 1,
            id: 1
        ),
        ClothObject(
            clothId: 9,
            name: " HUNTING HOOD JACKET_BLACK", 
            season: "겨울",
            category: "아우터",
            brand: "OUTSTANDING",
            place: "겨울옷 상자",
            size: "100",
            clothBody: "빈티지 아웃도어 자켓의 제품을 아웃스탠딩의 감성으로 재해석해낸 제품",
            fileName: "clothImage9.png",
            createdDate: "2022-06-07T00:00:00",
            updatedDate: "2022-06-07T00:00:00",
            favorite: 0,
            id: 1
        )
    ]
}
