//
//  File.swift
//  HereItIs
//
//  Created by Pierre Navarre on 28/01/2023.
//

import Foundation

extension String {
    
    var url: URL? {
        URL(string: self)
    }
    
}
