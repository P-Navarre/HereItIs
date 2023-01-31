//
//  ListViewInteractor.swift
//  HereItIs
//
//  Created by Pierre Navarre on 28/01/2023.
//

import Foundation

protocol ListViewInteractorInput {
    func loaadData() async
    func prefetchItems(at indexPaths: [IndexPath]) async
    func didSelectItem(at indexPath: IndexPath) async
}

actor ListViewInteractor {
    
    // MARK: - Properties
    private let presenter: ListViewPresenterInput
    private let imageLoader: ImageLoaderProtocol
    private let api: APIProtocol
    
    private var ads: [ClassifiedAd]?
    private var categories: [Int64: String]?
    
    // MARK: - Initialization
    init(
        presenter: ListViewPresenterInput,
        // For unit testing purpose managers can be set at initialization time
        imageLoader: ImageLoaderProtocol = ImageLoader.shared,
        api: APIProtocol = DefaultAPIWrapper.shated
    ) {
        self.presenter = presenter
        self.imageLoader = imageLoader
        self.api = api
    }
    
}

// MARK: - ListViewInteractorInput
extension ListViewInteractor: ListViewInteractorInput {
    
    func loaadData() {
        self.presenter.willStartLoading()
        Task {
            do {
                async let categoriesResponse = self.api.getCategories()
                async let listingResponse = self.api.getListing()
                
                let categoriesList = try await categoriesResponse.body
                let categories: [Int64: String] = Dictionary(
                    uniqueKeysWithValues: categoriesList.map { ($0.id, $0.name) }
                )
                self.categories = categories
                
                let ads = try await listingResponse.body
                self.ads = ads
                
                self.presenter.showAds(ads, categories: categories)
            } catch let error {
                let retry: ()->Void = {
                    Task { [weak self] in
                        await self?.loaadData()
                    }
                }
                self.presenter.showError(error, retryHandler: retry)
            }
        }
    }
    
    func prefetchItems(at indexPaths: [IndexPath]) {
        let urls: [URL] = indexPaths.compactMap { indexPath in
            self.ads?[indexPath.row].imagesUrl.small?.url
        }
        
        Task {
            await withTaskGroup(of: Void.self, body: { group in
                urls.forEach { url in
                    group.addTask {
                        await self.imageLoader.cacheImage(from: url)
                    }
                }
            })
        }
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let ad = self.ads?[indexPath.row] else { return }
        let category = self.categories?[ad.categoryId]
        self.presenter.presentDetail(for: ad, category: category)
    }
}
