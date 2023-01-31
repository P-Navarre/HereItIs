//
//  Localized.swift
//  HereItIs
//
//  Created by Pierre Navarre on 30/01/2023.
//

import Foundation

enum Localized: String {
    case errorMessage = "Load_Error_Message"
    case loadRetryButton = "Load_Retry_Button"
    
    case isUrgent = "Ad_Cell_Is_Urgent"
    
    case detailId = "Detail_ID"
    case iSUrgentLong = "Detail_Is_Urgent"
    case detailSiret = "Detail_SIRET"
    
    var stirng: String {
        Bundle.main.localizedString(forKey: self.rawValue, value: self.rawValue, table: "Localizable")
    }
}
