//
//  ListViewControllerSpy.swift
//  HereItIsTests
//
//  Created by Pierre Navarre on 01/02/2023.
//

import Foundation
@testable import HereItIs

final class ListViewControllerSpy: ListViewControllerInput {
    
    nonisolated init() {}

    var invokedShowLoader = false
    var invokedShowLoaderCount = 0
    var invokedShowLoaderParameters: (isRunning: Bool, Void)?
    var invokedShowLoaderParametersList = [(isRunning: Bool, Void)]()

    func showLoader(_ isRunning: Bool) {
        invokedShowLoader = true
        invokedShowLoaderCount += 1
        invokedShowLoaderParameters = (isRunning, ())
        invokedShowLoaderParametersList.append((isRunning, ()))
    }

    var invokedShowContent = false
    var invokedShowContentCount = 0
    var invokedShowContentParameters: (model: [AdCellModel], Void)?
    var invokedShowContentParametersList = [(model: [AdCellModel], Void)]()

    func showContent(_ model: [AdCellModel]) {
        invokedShowContent = true
        invokedShowContentCount += 1
        invokedShowContentParameters = (model, ())
        invokedShowContentParametersList.append((model, ()))
    }

    var invokedShowError = false
    var invokedShowErrorCount = 0
    var invokedShowErrorParameters: (model: ErrorViewModel?, Void)?
    var invokedShowErrorParametersList = [(model: ErrorViewModel?, Void)]()

    func showError(_ model: ErrorViewModel?) {
        invokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorParameters = (model, ())
        invokedShowErrorParametersList.append((model, ()))
    }

    var invokedPresentDetail = false
    var invokedPresentDetailCount = 0
    var invokedPresentDetailParameters: (ad: ClassifiedAd, category: String?)?
    var invokedPresentDetailParametersList = [(ad: ClassifiedAd, category: String?)]()

    func presentDetail(for ad: ClassifiedAd, category: String?) {
        invokedPresentDetail = true
        invokedPresentDetailCount += 1
        invokedPresentDetailParameters = (ad, category)
        invokedPresentDetailParametersList.append((ad, category))
    }
}
