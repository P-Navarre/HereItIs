//
//  ImageLoader.swift
//  HereItIs
//
//  Created by Pierre Navarre on 28/01/2023.
//

import UIKit

// Protocol definition for the class responsible for loading and caching image data
protocol ImageLoaderProtocol: AnyActor {
    func cacheImage(from url: URL) async
    func image(from url: URL) async throws -> UIImage?
}

// Simplistic implementation
actor ImageLoader: ImageLoaderProtocol {
    static let shared: ImageLoader = ImageLoader()
    
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    func cacheImage(from url: URL) async {
        _ = try? await self.session.data(from: url)
    }
    
    func image(from url: URL) async throws -> UIImage? {
        try await UIImage(data: self.session.data(from: url).0)
    }
}

// Alternative implementation with the benefit of avoiding duplicate requests
// Lack of flush logic
//// https://developer.apple.com/forums/thread/682032
actor ImageLoaderImp2: ImageLoaderProtocol {
    static let shared: ImageLoaderImp2 = ImageLoaderImp2()

    private enum CacheEntry {
        case inProgress(Task<UIImage?, Error>)
        case ready(UIImage?)
    }

    private let session: URLSession
    private var cache: [URL: CacheEntry] = [:]

    private init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringCacheData
        self.session = URLSession(configuration: config)
    }
    
    func cacheImage(from url: URL) async {
        _ = try? await self.image(from: url)
    }

    func image(from url: URL) async throws -> UIImage? {
        if let cached = cache[url] {
            switch cached {
            case .ready(let image):
                return image
            case .inProgress(let handle):
                return try await handle.value
            }
        }

        let handle = Task {
            try await UIImage(data: self.session.data(from: url).0)
        }

        self.cache[url] = .inProgress(handle)

        do {
            let image = try await handle.value
            self.cache[url] = .ready(image)
            return image
        } catch {
            self.cache[url] = nil
            throw error
        }
    }
}
