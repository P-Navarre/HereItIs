//
//  ListViewInteractor.swift
//  HereItIs
//
//  Created by Pierre Navarre on 28/01/2023.
//

import Foundation

protocol ListViewInteractorInput {
    func loaadData() async
    func prefetchItems(withIds adIds: [Int64]) async
    func didSelectItem(withId adId: Int64) async
}

actor ListViewInteractor {
    
    // MARK: - Properties
    private let presenter: ListViewPresenterInput
    private let api: APIProtocol
    private let imageLoader: ImageLoaderProtocol

    private var ads: [ClassifiedAd]?
    private var categories: [Int64: String]?
    
    // MARK: - Initialization
    init(
        presenter: ListViewPresenterInput,
        // For unit testing purpose managers can be set at initialization time
        api: APIProtocol = DefaultAPIWrapper.shated,
        imageLoader: ImageLoaderProtocol = ImageLoader.shared
    ) {
        self.presenter = presenter
        self.imageLoader = imageLoader
        self.api = api
    }
    
}

// MARK: - ListViewInteractorInput
extension ListViewInteractor: ListViewInteractorInput {
    
    func loaadData() async {
        await self.presenter.willStartLoading()
        
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
            
            await self.presenter.showAds(ads, categories: categories)
        } catch let error {
            let retry: ()->Void = {
                Task { [weak self] in
                    await self?.loaadData()
                }
            }
            await self.presenter.showError(error, retryHandler: retry)
        }
        
    }
    
    func prefetchItems(withIds adIds: [Int64]) async {
        let ads = adIds.compactMap { id in
            self.ads?.first { $0.id == id }
        }
        
        let urls: [URL] = ads.compactMap { ad in
            ad.imagesUrl.small?.url
        }
    
        await withTaskGroup(of: Void.self, body: { group in
            urls.forEach { url in
                group.addTask {
                    await self.imageLoader.cacheImage(from: url)
                }
            }
        })
    }
    
    func didSelectItem(withId adId: Int64) async {
        guard let ad = self.ads?.first(where: { $0.id == adId }) else { return }
        let category = self.categories?[ad.categoryId]
        await self.presenter.presentDetail(for: ad, category: category)
    }
}
