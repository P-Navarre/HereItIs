//
//  ListViewInteractorTests.swift
//  HereItIsTests
//
//  Created by Pierre Navarre on 01/02/2023.
//

import XCTest
@testable import HereItIs

final class ListViewInteractorTests: XCTestCase {
    private var interactorUnderTesting: ListViewInteractor!
    
    private var listViewPresenterSpy: ListViewPresenterSpy!
    private var apiSpy: DefaultAPIWrapperSpy!
    private var imageLoaderSpy: ImageLoaderSpy!
    
    override func setUp() {
        super.setUp()
        self.listViewPresenterSpy = ListViewPresenterSpy()
        self.apiSpy = DefaultAPIWrapperSpy()
        self.imageLoaderSpy = ImageLoaderSpy()
        self.interactorUnderTesting = ListViewInteractor(
            presenter: self.listViewPresenterSpy, api: self.apiSpy, imageLoader: self.imageLoaderSpy
        )
    }
    
    func test_load_CategoriesSuccess_and_ListingSuccess() async {
        // Arrange
        let categories = AdCategory.mockList
        self.apiSpy.stubbedGetCategoriesResult = Result {
            Response(response: .init(), body: categories)
        }
        let ads = ClassifiedAd.mockList
        self.apiSpy.stubbedGetListingResult = Result {
            Response(response: .init(), body: ads)
        }
        
        // Act
        await self.interactorUnderTesting.loaadData()
        
        // Assert
        XCTAssert(self.listViewPresenterSpy.invokedWillStartLoading)
        XCTAssert(self.listViewPresenterSpy.invokedShowAds)
        
        let parameters = self.listViewPresenterSpy.invokedShowAdsParameters
        XCTAssertEqual(parameters?.ads, ads)
        let categoriesDict: [Int64: String] = Dictionary(
            uniqueKeysWithValues: categories.map { ($0.id, $0.name) }
        )
        XCTAssertEqual(parameters?.categories, categoriesDict)
    }
    
    func test_load_CategoriesError_and_ListingSuccess() async {
        // Arrange
        self.apiSpy.stubbedGetCategoriesResult = Result { throw NSError() }
        let ads = ClassifiedAd.mockList
        self.apiSpy.stubbedGetListingResult = Result {
            Response(response: .init(), body: ads)
        }
        
        // Act
        await self.interactorUnderTesting.loaadData()
        
        // Assert
        XCTAssert(self.listViewPresenterSpy.invokedWillStartLoading)
        XCTAssertFalse(self.listViewPresenterSpy.invokedShowAds)
        XCTAssert(self.listViewPresenterSpy.invokedShowError)
    }
    
    func test_load_CategoriesSuccess_and_ListingError() async {
        // Arrange
        let categories = AdCategory.mockList
        self.apiSpy.stubbedGetCategoriesResult = Result {
            Response(response: .init(), body: categories)
        }
        self.apiSpy.stubbedGetListingResult = Result { throw NSError() }
        
        // Act
        await self.interactorUnderTesting.loaadData()
        
        // Assert
        XCTAssert(self.listViewPresenterSpy.invokedWillStartLoading)
        XCTAssertFalse(self.listViewPresenterSpy.invokedShowAds)
        XCTAssert(self.listViewPresenterSpy.invokedShowError)
    }
    
    func test_prefetch() async {
        // Arrange
        let categories = AdCategory.mockList
        self.apiSpy.stubbedGetCategoriesResult = Result {
            Response(response: .init(), body: categories)
        }
        let ads = ClassifiedAd.mockList
        self.apiSpy.stubbedGetListingResult = Result {
            Response(response: .init(), body: ads)
        }
        await self.interactorUnderTesting.loaadData()
        
        let prefetchCount: Int = ads.isEmpty ? 0 : (0..<ads.count).randomElement()!
        let adIds = (0..<prefetchCount).map { index in
            ads[index].id
        }
        
        // Act
        await self.interactorUnderTesting.prefetchItems(withIds: adIds)
        
        // Assert
        let expectedUrls: [String] = adIds
            .compactMap { id in
                ads.first(where: { $0.id == id })?.imagesUrl.small?.url
            }.map { url in
                url.absoluteString
            }.sorted()
        
        let invokedCacheImageCount = await self.imageLoaderSpy.getInvokedCacheImageCount()
        XCTAssertEqual(invokedCacheImageCount, expectedUrls.count)
        
        let invokedCacheImageParametersList = await self.imageLoaderSpy.getInvokedCacheImageParametersList()
        let invokedUrls: [String] = invokedCacheImageParametersList.map { url in
            url.absoluteString
        }.sorted()

        XCTAssertEqual(invokedUrls, expectedUrls)
    }
    
    func test_didSelectItem() async {
        // Arrange
        let categories = AdCategory.mockList
        self.apiSpy.stubbedGetCategoriesResult = Result {
            Response(response: .init(), body: categories)
        }
        let ads = ClassifiedAd.mockList
        self.apiSpy.stubbedGetListingResult = Result {
            Response(response: .init(), body: ads)
        }
        await self.interactorUnderTesting.loaadData()
        
        guard let selected = (0..<ads.count).randomElement() else { return }
        
        // Act
        await self.interactorUnderTesting.didSelectItem(withId: ads[selected].id)
        
        // Assert
        XCTAssert(self.listViewPresenterSpy.invokedPresentDetail)
        let ad = ads[selected]
        XCTAssertEqual(self.listViewPresenterSpy.invokedPresentDetailParameters?.ad, ad)
        let categoriesDict: [Int64: String] = Dictionary(
            uniqueKeysWithValues: categories.map { ($0.id, $0.name) }
        )
        let category = categoriesDict[ad.categoryId]
        XCTAssertEqual(self.listViewPresenterSpy.invokedPresentDetailParameters?.category, category)
    }
}
