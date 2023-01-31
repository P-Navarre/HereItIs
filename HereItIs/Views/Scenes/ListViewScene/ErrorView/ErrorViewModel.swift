//
//  ErrorViewModel.swift
//  HereItIs
//
//  Created by Pierre Navarre on 30/01/2023.
//

import UIKit

struct ErrorViewModel {
    let message: NSAttributedString
    let buttonBackground: UIColor
    let buttonTitle: NSAttributedString
    let retryHandler: ()->Void
}
