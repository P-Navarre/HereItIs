//
//  DefaultAPIWrapperSpy.swift
//  HereItIsTests
//
//  Created by Pierre Navarre on 01/02/2023.
//

import Foundation
@testable import HereItIs

final class DefaultAPIWrapperSpy: APIProtocol {

    var invokedGetCategories = false
    var invokedGetCategoriesCount = 0
    var stubbedGetCategoriesResult: Result<Response<[AdCategory]>, Error>!

    func getCategories() async throws -> Response<[AdCategory]> {
        invokedGetCategories = true
        invokedGetCategoriesCount += 1
        // Ensuring true asynchronicity
        return try await Task { try stubbedGetCategoriesResult.get() }.value
    }

    var invokedGetListing = false
    var invokedGetListingCount = 0
    var stubbedGetListingResult: Result<Response<[ClassifiedAd]>, Error>!
    
    func getListing() async throws -> Response<[ClassifiedAd]> {
        invokedGetListing = true
        invokedGetListingCount += 1
        // Ensuring true asynchronicity
        return try await Task { try stubbedGetListingResult.get() }.value
    }
}
