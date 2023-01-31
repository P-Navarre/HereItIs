//
//  DefaultAPIWrapper.swift
//  HereItIs
//
//  Created by Pierre Navarre on 28/01/2023.
//

import Foundation

protocol APIProtocol {
    func getCategories() async throws -> Response<[Category]>
    func getListing() async throws -> Response<[ClassifiedAd]>
}

struct DefaultAPIWrapper: APIProtocol {
    static let shated: DefaultAPIWrapper = .init()
    
    private init() {}
    
    func getCategories() async throws -> Response<[Category]> {
        try await DefaultAPI.categoriesJsonGetWithRequestBuilder().asyncExecute()
    }
    
    func getListing() async throws -> Response<[ClassifiedAd]> {
        try await DefaultAPI.listingJsonGetWithRequestBuilder().asyncExecute()
    }
    
}

private extension RequestBuilder {
    func asyncExecute(_ apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue) async throws -> Response<T> {
        return try await withCheckedThrowingContinuation { continuation in
            self.execute { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
