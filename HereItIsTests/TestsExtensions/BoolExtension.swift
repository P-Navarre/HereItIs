//
//  BoolExtension.swift
//  HereItIsTests
//
//  Created by Piere Navarre on 01/02/2023.
//

import Foundation

extension Bool {
    
    static func random(with probability: Double) -> Bool {
        let value = Double.random(in: 0..<1)
        return value < probability
    }
    
}
