//
//  File.swift
//  HereItIsTests
//
//  Created by Pierre Navarre on 01/02/2023.
//

import UIKit
@testable import HereItIs

actor ImageLoaderSpy: ImageLoaderProtocol {

    var invokedCacheImage = false
    var invokedCacheImageCount = 0
    var invokedCacheImageParameters: (url: URL, Void)?
    var invokedCacheImageParametersList = [(url: URL, Void)]()
    
    func getInvokedCacheImageCount() -> Int {
        self.invokedCacheImageCount
    }
    
    func getInvokedCacheImageParametersList() -> [URL] {
        self.invokedCacheImageParametersList.map { $0.url }
    }

    func cacheImage(from url: URL) {
        invokedCacheImage = true
        invokedCacheImageCount += 1
        invokedCacheImageParameters = (url, ())
        invokedCacheImageParametersList.append((url, ()))
    }

    var invokedImage = false
    var invokedImageCount = 0
    var invokedImageParameters: (url: URL, Void)?
    var invokedImageParametersList = [(url: URL, Void)]()
    var stubbedImageResult: Result<UIImage?, Error>!
    
    func getInvokedImage() -> Bool {
        self.invokedImage
    }
    
    func setStubbedImageResult(_ reuslt: Result<UIImage?, Error>) {
        self.stubbedImageResult = reuslt
    }

    func image(from url: URL) async throws -> UIImage? {
        invokedImage = true
        invokedImageCount += 1
        invokedImageParameters = (url, ())
        invokedImageParametersList.append((url, ()))
        // Ensuring true asynchronicity
        return try await Task { try stubbedImageResult.get() }.value
    }
}
