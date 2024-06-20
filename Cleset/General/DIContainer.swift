//
//  DIContainer.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import Foundation

final class DIContainer: ObservableObject {
    let services: ServiceType
    var appearanceController: AppearanceController & ObservableObjectSettable
    
    init(
        services: ServiceType,
        appearanceController: AppearanceController & ObservableObjectSettable = AppearanceController()
    ) {
        self.services = services
        self.appearanceController = appearanceController
        
        self.appearanceController.setObjectWillChange(self.objectWillChange)
    }
}

extension DIContainer {
    static var stub: DIContainer {
        .init(services: StubService())
    }
}
