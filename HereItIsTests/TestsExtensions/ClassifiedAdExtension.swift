//
//  ClassifiedAdExtension.swift
//  HereItIsTests
//
//  Created by Pierre Navarre on 01/02/2023.
//

import Foundation
@testable import HereItIs

extension ClassifiedAd {
    private enum Constants {
        static let listCount: Int = 50
        static let dateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    static var mockList: [ClassifiedAd] {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        
        let categories = AdCategory.mockList.map { $0.id }
        
        return (0..<Constants.listCount).map { index in
            ClassifiedAd(
                id: Int64(index),
                title: "title_\(index)",
                categoryId: categories.randomElement()!,
                creationDate: formatter.string(from: Date()),
                description: "description_\(index)",
                isUrgent: Bool.random(),
                imagesUrl: ImagesURL(
                    small: Bool.random(with: 0.75) ? "small_url_\(index)" : nil,
                    thumb: Bool.random(with: 0.75) ? "thumb_url_\(index)" : nil
                    ),
                price: Float(index),
                siret: Bool.random(with: 0.25) ? "siret_\(index)" : nil
            )
        }
        
    }
    
}
