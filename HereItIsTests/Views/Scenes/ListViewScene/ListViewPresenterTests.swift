//
//  ListViewPresenterTests.swift
//  HereItIsTests
//
//  Created by Pierre Navarre on 01/02/2023.
//

import XCTest
@testable import HereItIs

final class ListViewPresenterTests: XCTestCase {
    private var presenterUnderTesting: ListViewPresenter!
    
    private var listViewControllerSpy: ListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        self.listViewControllerSpy = ListViewControllerSpy()
        self.presenterUnderTesting = ListViewPresenter(viewController: self.listViewControllerSpy)
    }
    
    func test_willStartLoading() async {
        // Arrange
        
        // Act
        await self.presenterUnderTesting.willStartLoading()
        
        // Assert
        await MainActor.run {
            XCTAssert(self.listViewControllerSpy.invokedShowError)
            XCTAssert(self.listViewControllerSpy.invokedShowErrorParameters?.model == nil)
            XCTAssert(self.listViewControllerSpy.invokedShowLoader)
            XCTAssert(self.listViewControllerSpy.invokedShowLoaderParameters?.isRunning == true)
        }
    }
    
    func test_showAds() async {
        // Arrange
        let categories: [Int64: String] = Dictionary(
            uniqueKeysWithValues: AdCategory.mockList.map { ($0.id, $0.name) }
        )
        let ads = ClassifiedAd.mockList
        
        // Act
        await self.presenterUnderTesting.showAds(ads, categories: categories)
        
        // Assert
        await MainActor.run {
            XCTAssert(self.listViewControllerSpy.invokedShowError)
            XCTAssert(self.listViewControllerSpy.invokedShowErrorParameters?.model == nil)
            XCTAssert(self.listViewControllerSpy.invokedShowLoader)
            XCTAssert(self.listViewControllerSpy.invokedShowLoaderParameters?.isRunning == false)
            
            XCTAssert(self.listViewControllerSpy.invokedShowContent)
            let model = self.listViewControllerSpy.invokedShowContentParameters?.model
            XCTAssertEqual(model?.count, ads.count)
            
            guard ads.count > 0 else { return }
            let index = (0..<ads.count).randomElement()!
            let cellModel = model?[index]
            let ad = ads[index]
            let style = ListViewPresenter.AdCellStyle()
            XCTAssertEqual(cellModel?.id, ad.id)
            XCTAssertEqual(cellModel?.placeHolder, Style.Image.placeHolderSquare)
            XCTAssertEqual(cellModel?.imageUrl, ad.imagesUrl.small?.url)
            XCTAssertEqual(cellModel?.category.string, categories[ad.categoryId])
            XCTAssert(cellModel?.category.hasAttributes(style.categoryAttributes) == true)
            XCTAssertEqual(cellModel?.title.string, ad.title)
            XCTAssert(cellModel?.title.hasAttributes(style.titleAttributes) == true)
            XCTAssertEqual(cellModel?.price.string, style.priceFormatter.string(from: NSNumber(value: ad.price)) ?? "")
            XCTAssert(cellModel?.price.hasAttributes(style.priceAttributes) == true)
            XCTAssertEqual(cellModel?.isUrgent.string, ad.isUrgent ? Localized.isUrgent.stirng : "")
            XCTAssert(cellModel?.isUrgent.hasAttributes(style.isUrgentAttributes) == true)
        }
    }
    
    func test_showError() async {
        // Arrange
        let error = NSError()
        
        let exp = expectation(description: "retry")
        let retry: ()->Void = {
            exp.fulfill()
        }
        
        // Act
        await self.presenterUnderTesting.showError(error, retryHandler: retry)
        
        // Assert
        await MainActor.run {
            XCTAssert(self.listViewControllerSpy.invokedShowLoader)
            XCTAssert(self.listViewControllerSpy.invokedShowLoaderParameters?.isRunning == false)
            
            XCTAssertEqual(self.listViewControllerSpy.invokedShowErrorCount, 2)
            XCTAssert(self.listViewControllerSpy.invokedShowErrorParametersList[0].model == nil)
            
            let model = self.listViewControllerSpy.invokedShowErrorParametersList[1].model
            let style = ListViewPresenter.ErrorViewStyle()
            XCTAssertEqual(model?.message.string, Localized.errorMessage.stirng)
            XCTAssert(model?.message.hasAttributes(style.messageAttributes) == true)
            XCTAssertEqual(model?.buttonBackground, style.buttonBackgroundColor)
            XCTAssertEqual(model?.buttonTitle.string, Localized.loadRetryButton.stirng)
            XCTAssert(model?.buttonTitle.hasAttributes(style.buttonTitleAttributes) == true)
            model?.retryHandler()
            waitForExpectations(timeout: 0)
        }
        
    }
    
    func test_presentDetail() async {
        // Arrange
        let ad = ClassifiedAd.mockList.randomElement()!
        let category = "category_name"
        
        // Act
        await self.presenterUnderTesting.presentDetail(for: ad, category: category)
        
        // Assert
        await MainActor.run {
            XCTAssert(self.listViewControllerSpy.invokedPresentDetail)
            XCTAssertEqual(self.listViewControllerSpy.invokedPresentDetailParameters?.ad, ad)
            XCTAssertEqual(self.listViewControllerSpy.invokedPresentDetailParameters?.category, category)
        }
    }
}
