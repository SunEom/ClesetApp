//
//  AppearanceStyle.swift
//  Cleset
//
//  Created by 엄태양 on 6/18/24.
//

import Foundation
import SwiftUI

enum AppearanceStyle: Int, CaseIterable {
    case automatic
    case light
    case dark
    
    var label: String {
        switch self {
            case .automatic:
                "시스템모드"
            case .light:
                "라이트모드"
            case .dark:
                "다크모드"
        }
    }
    
    var colorSchme: ColorScheme? {
        switch self {
            case .automatic:
                return nil
            case .light:
                return .light
            case .dark:
                return .dark
        }
    }
    
}
