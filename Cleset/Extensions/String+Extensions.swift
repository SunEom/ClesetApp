//
//  String+Extensions.swift
//  Cleset
//
//  Created by 엄태양 on 4/26/24.
//

import Foundation

extension String {
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = dateFormatter.date(from: self) {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "yyyy.MM.dd. HH:mm:ss"
            let newDateString = newDateFormatter.string(from: date)
            return newDateString
        } else {
            return ""
        }
    }    
}
