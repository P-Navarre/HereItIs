//
//  DetailViewModel.swift
//  HereItIs
//
//  Created by Pierre Navarre on 30/01/2023.
//

import Foundation

struct DetailViewModel {
    let placeHolder: Style.Image
    let imageUrl: URL?
    let category: NSAttributedString
    let id: NSAttributedString
    let title: NSAttributedString
    let price: NSAttributedString
    let date: NSAttributedString
    let isUrgent: NSAttributedString
    let description: NSAttributedString
    let siret: NSAttributedString?
}
