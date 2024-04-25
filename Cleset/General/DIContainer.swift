//
//  DIContainer.swift
//  Cleset
//
//  Created by 엄태양 on 4/23/24.
//

import Foundation

final class DIContainer: ObservableObject {
    let services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}

extension DIContainer {
    static var stub: DIContainer {
        .init(services: StubService())
    }
    
}
