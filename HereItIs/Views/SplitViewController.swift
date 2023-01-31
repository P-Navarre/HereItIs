//
//  SplitViewController.swift
//  HereItIs
//
//  Created by Pierre Navarre on 31/01/2023.
//

import UIKit

final class SplitViewController: UISplitViewController {
    
    private enum Constants {
        static let minimumPrimaryColumnWidth: CGFloat = 400
        static let minimumDetailColumnWidth: CGFloat = 375
        static let preferredPrimaryColumnWidthFraction: CGFloat = 2/3
    }
    
    init(width: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.preferredDisplayMode = .oneBesideSecondary
        self.minimumPrimaryColumnWidth = Constants.minimumPrimaryColumnWidth
        self.maximumPrimaryColumnWidth = width - Constants.minimumDetailColumnWidth
        self.preferredPrimaryColumnWidthFraction = Constants.preferredPrimaryColumnWidthFraction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
