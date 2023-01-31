//
//  UINavigationBarExtension.swift
//  HereItIs
//
//  Created by Pierre Navarre on 30/01/2023.
//

import UIKit


extension UINavigationBar {
    
    static private var customScrollEdgeAppearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Style.Color.brand.color
        appearance.titleTextAttributes = [
            .font : Style.Font.bold.withSize(22),
            .foregroundColor : UIColor.white
        ]
        
        let backIndicator = appearance.backIndicatorImage
            .withTintColor(.white)
            .withRenderingMode(.alwaysOriginal)
        
        appearance.setBackIndicatorImage(backIndicator, transitionMaskImage: backIndicator)
        
        return appearance
    }
    
    static private var customStandardAppearance: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font : Style.Font.bold.withSize(22),
            .foregroundColor : Style.Color.brand.color
        ]
                
        let backIndicator = appearance.backIndicatorImage
            .withTintColor(Style.Color.brand.color)
            .withRenderingMode(.alwaysOriginal)
        
        appearance.setBackIndicatorImage(backIndicator, transitionMaskImage: backIndicator)
        
        return appearance
    }
    
    func configureAppearance() {
        self.standardAppearance = Self.customStandardAppearance
        self.scrollEdgeAppearance = Self.customScrollEdgeAppearance
    }
    
}
