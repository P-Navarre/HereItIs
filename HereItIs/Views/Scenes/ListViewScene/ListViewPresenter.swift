//
//  ListViewPresenter.swift
//  HereItIs
//
//  Created by Pierre Navarre on 28/01/2023.
//

import UIKit

protocol ListViewPresenterInput {
    func willStartLoading()
    func showAds(_ ads: [ClassifiedAd], categories: [Int64: String])
    func showError(_ error: Error, retryHandler: @escaping ()->Void)
    func presentDetail(for ad: ClassifiedAd, category: String?)
}

final class ListViewPresenter {
    private weak var viewController: ListViewControllerInput?
    
    init(viewController: ListViewControllerInput) {
        self.viewController = viewController
    }
}

// MARK: - ListViewPresenterInput
extension ListViewPresenter: ListViewPresenterInput {
    func willStartLoading() {
        Task { @MainActor in
            self.viewController?.showError(nil)
            self.viewController?.showLoader(true)
        }
    }
    
    func showAds(_ ads: [ClassifiedAd], categories: [Int64: String]) {
        let style = AdCellStyle()
    
        let model = ads.map({ ad in
            self.cellModel(for: ad, categories: categories, style: style)
        })
        
        Task { @MainActor in
            self.viewController?.showError(nil)
            self.viewController?.showLoader(false)
            self.viewController?.showContent(model)
        }
    }
    
    func showError(_ error: Error, retryHandler: @escaping ()->Void) {
        let style = ErrorViewStyle()
        
        let model = ErrorViewModel(
            message: NSAttributedString(string: Localized.errorMessage.stirng, attributes: style.messageAttributes),
            buttonBackground: style.buttonBackgroundColor,
            buttonTitle: NSAttributedString(
                string: Localized.loadRetryButton.stirng, attributes: style.buttonTitleAttributes
            ),
            retryHandler: retryHandler
        )
        
        Task { @MainActor in
            self.viewController?.showError(nil)
            self.viewController?.showLoader(false)
            self.viewController?.showError(model)
        }
    }
    
    func presentDetail(for ad: ClassifiedAd, category: String?) {
        Task {  @MainActor in self.viewController?.presentDetail(for: ad, category: category) }
    }
}

// MARK: - AdCellStyle
private extension ListViewPresenter {
    
    struct AdCellStyle {
        let priceFormatter: NumberFormatter
        let categoryAttributes: [NSAttributedString.Key : Any]
        let titleAttributes: [NSAttributedString.Key : Any]
        let priceAttributes: [NSAttributedString.Key : Any]
        let isUrgentAttributes: [NSAttributedString.Key : Any]
        
        init() {
            let priceFormatter = NumberFormatter()
            priceFormatter.locale = Locale(identifier: "fr_FR")
            priceFormatter.numberStyle = .currency
            priceFormatter.maximumFractionDigits = 0
            self.priceFormatter = priceFormatter
            
            self.categoryAttributes = [
                .font: Style.Font.regular.withSize(17),
                .foregroundColor : UIColor.systemGray
                
            ]
            self.titleAttributes = [.font: Style.Font.medium.withSize(17)]
            self.priceAttributes = [.font: Style.Font.medium.withSize(15)]
            self.isUrgentAttributes = [.font: Style.Font.medium.withSize(17)]
        }
    }
    
    func cellModel(for ad: ClassifiedAd, categories: [Int64: String], style: AdCellStyle) -> AdCellModel {
        let category = NSAttributedString(
            string: String(categories[ad.categoryId] ?? ""),
            attributes: style.categoryAttributes
        )
        
        let title = NSAttributedString(
            string: ad.title,
            attributes: style.titleAttributes
        )
        
        let price = NSAttributedString(
            string: style.priceFormatter.string(from: NSNumber(value: ad.price)) ?? "",
            attributes: style.titleAttributes
        )
        
        let isUrgent = NSAttributedString(
            string: ad.isUrgent ? Localized.isUrgent.stirng : "",
            attributes: style.isUrgentAttributes
        )
        
        return AdCellModel(
            id: ad.id, placeHolder: Style.Image.placeHolderSquare, imageUrl: ad.imagesUrl.small?.url,
            category: category, title: title, price: price, isUrgent: isUrgent
        )
    }
}

// MARK: - ErrorViewStyle
private extension ListViewPresenter {
    struct ErrorViewStyle {
        let messageAttributes: [NSAttributedString.Key : Any]
        let buttonBackgroundColor: UIColor = Style.Color.brand.color
        let buttonTitleAttributes: [NSAttributedString.Key : Any]
        
        init() {
            let messageStyle = NSMutableParagraphStyle()
            messageStyle.alignment = .center
            self.messageAttributes = [
                .font: Style.Font.medium.withSize(20),
                .paragraphStyle: messageStyle
            ]
            
            self.buttonTitleAttributes = [
                .font: Style.Font.medium.withSize(20),
                .foregroundColor: UIColor.white
            ]
        }
    }
}
