//
//  ObservableObjectSettable.swift
//  Cleset
//
//  Created by 엄태양 on 6/18/24.
//

import Foundation
import Combine

protocol ObservableObjectSettable: AnyObject {
    var objectWillChange: ObservableObjectPublisher? { get set }
    func setObjectWillChange(_ objectWillChange: ObservableObjectPublisher)
}

extension ObservableObjectSettable {
    func setObjectWillChange(_ objectWillChange: ObservableObjectPublisher) {
        self.objectWillChange = objectWillChange
    }
}
