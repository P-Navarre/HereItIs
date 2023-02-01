//
//  ListViewPresenterSpy.swift
//  HereItIsTests
//
//  Created by Pierre Navarre on 01/02/2023.
//

import Foundation
@testable import HereItIs

final class ListViewPresenterSpy: ListViewPresenterInput {

    var invokedWillStartLoading = false
    var invokedWillStartLoadingCount = 0

    func willStartLoading() {
        invokedWillStartLoading = true
        invokedWillStartLoadingCount += 1
    }

    var invokedShowAds = false
    var invokedShowAdsCount = 0
    var invokedShowAdsParameters: (ads: [ClassifiedAd], categories: [Int64: String])?
    var invokedShowAdsParametersList = [(ads: [ClassifiedAd], categories: [Int64: String])]()

    func showAds(_ ads: [ClassifiedAd], categories: [Int64: String]) async {
        await MainActor.run {
            invokedShowAds = true
            invokedShowAdsCount += 1
            invokedShowAdsParameters = (ads, categories)
            invokedShowAdsParametersList.append((ads, categories))
        }
    }

    var invokedShowError = false
    var invokedShowErrorCount = 0
    var invokedShowErrorParameters: (error: Error, Void)?
    var invokedShowErrorParametersList = [(error: Error, Void)]()
    var shouldInvokeShowErrorRetryHandler = false

    func showError(_ error: Error, retryHandler: @escaping ()->Void) {
        invokedShowError = true
        invokedShowErrorCount += 1
        invokedShowErrorParameters = (error, ())
        invokedShowErrorParametersList.append((error, ()))
        if shouldInvokeShowErrorRetryHandler {
            retryHandler()
        }
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
