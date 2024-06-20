//
//  AppearanceController.swift
//  Cleset
//
//  Created by 엄태양 on 6/18/24.
//

import Foundation
import Combine

protocol AppearanceControllable {
    var appearance: AppearanceStyle { get set  }
    
    func changeAppearance(_ willBeAppearance: AppearanceStyle?)
}

class AppearanceController: AppearanceControllable, ObservableObjectSettable {
    var objectWillChange: ObservableObjectPublisher?
    
    var appearance: AppearanceStyle = .light {
        didSet {
            objectWillChange?.send()
        }
    }
    
    func changeAppearance(_ willBeAppearance: AppearanceStyle?) {
        self.appearance = willBeAppearance ?? .automatic
    }
    
}
