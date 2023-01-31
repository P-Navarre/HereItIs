//
//  Style.swift
//  HereItIs
//
//  Created by Pierre Navarre on 29/01/2023.
//

import UIKit

enum Style {
    
    enum Font {
        case regular, medium, demiBold, bold
        
        var name: String {
            switch self {
            case .regular: return "AvenirNext-Regular"
            case .medium: return "AvenirNext-Medium"
            case .demiBold: return "AvenirNext-DemiBold"
            case .bold: return "AvenirNext-Bold"
            }
        }
        
        func withSize(_ size: CGFloat) -> UIFont {
            UIFont(name: self.name, size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
    
    enum Color {
        case brand, adCellBackground
        
        var color: UIColor {
            switch self {
            case .brand: return UIColor(named: "BrandColor") ?? .black
            case .adCellBackground: return UIColor(named: "AdCellBackground") ?? .systemBackground
            }
        }
    }
    
    enum Image {
        case placeHolderSquare, placeHolderLandscape
        
        var image: UIImage? {
            switch self {
            case .placeHolderSquare: return UIImage(named: "PlaceholderSquare")
            case .placeHolderLandscape: return UIImage(named: "PlaceholderLandscape")
            }
        }
    }
    
}
