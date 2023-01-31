//
//  AdCellModel.swift
//  HereItIs
//
//  Created by Pierre Navarre on 28/01/2023.
//

import Foundation

struct AdCellModel: Hashable {
    let id: Int64
    let placeHolder: Style.Image
    let imageUrl: URL?
    let category: NSAttributedString
    let title: NSAttributedString
    let price: NSAttributedString
    let isUrgent: NSAttributedString
}
