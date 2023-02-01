//
//  AdCategoryExtension.swift
//  HereItIsTests
//
//  Created by Pierre Navarre on 01/02/2023.
//

import Foundation
@testable import HereItIs

extension AdCategory {
    private enum Constants {
        static let categoryCount: Int = 10
    }
    
    static var mockList: [AdCategory] {
        (0..<Constants.categoryCount).map { index in
            AdCategory(id: Int64(index), name: "name_\(index)")
        }
    }
    
}
