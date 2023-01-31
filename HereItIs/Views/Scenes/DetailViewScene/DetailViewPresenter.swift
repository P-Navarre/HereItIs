//
//  DetailViewPresenter.swift
//  HereItIs
//
//  Created by Pierre Navarre on 30/01/2023.
//

import UIKit

protocol DetailViewPresenterInput {
    func willAppear(for ad: ClassifiedAd, category: String?)
}

@MainActor
final class DetailViewPresenter {
    private weak var viewController: DetailViewControllerInput?
    
    init(viewController: DetailViewControllerInput) {
        self.viewController = viewController
    }
}

// MARK: - DetailViewPresenterInput
extension DetailViewPresenter: DetailViewPresenterInput {
    func willAppear(for ad: ClassifiedAd, category: String?) {
        let model = self.cellModel(for: ad, category: category, style: DetailViewlStyle())
        self.viewController?.showContent(model)
    }
}

// MARK: - DetailViewlStyle
private extension DetailViewPresenter {
    enum Constants {
        static let LacaleIdentifier: String = "fr_FR"
        static let dateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    struct DetailViewlStyle {
        let priceFormatter: NumberFormatter
        let fromStringDateFormatter: DateFormatter
        let toStringDateFormatter: DateFormatter
        
        let categoryAttributes: [NSAttributedString.Key : Any]
        let idAttributes: [NSAttributedString.Key : Any]
        let titleAttributes: [NSAttributedString.Key : Any]
        let priceAttributes: [NSAttributedString.Key : Any]
        let dateAttributes: [NSAttributedString.Key : Any]
        let isUrgentAttributes: [NSAttributedString.Key : Any]
        let descripionAttributes: [NSAttributedString.Key : Any]
        let siretAttributes: [NSAttributedString.Key : Any]
        
        init() {
            let locale = Locale(identifier: Constants.LacaleIdentifier)
            
            self.priceFormatter = {
                let formatter = NumberFormatter()
                formatter.locale = locale
                formatter.numberStyle = .currency
                formatter.maximumFractionDigits = 0
                return formatter
            }()
            
            self.fromStringDateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = Constants.dateFormat
                return formatter
            }()
            
            self.toStringDateFormatter = {
                let formatter = DateFormatter()
                formatter.locale = locale
                formatter.dateStyle = .long
                formatter.timeStyle = .none
                return formatter
            }()
            
            self.categoryAttributes = [
                .font: Style.Font.regular.withSize(17),
                .foregroundColor : UIColor.systemGray
                
            ]
            self.idAttributes = [
                .font: Style.Font.regular.withSize(12),
                .foregroundColor : UIColor.systemGray
            ]
            self.titleAttributes = [.font: Style.Font.medium.withSize(18)]
            self.priceAttributes = [.font: Style.Font.medium.withSize(16)]
            self.dateAttributes = [.font: Style.Font.regular.withSize(15)]
            self.isUrgentAttributes = [.font: Style.Font.regular.withSize(16)]
            self.descripionAttributes = [.font: Style.Font.regular.withSize(16)]
            self.siretAttributes = [.font: Style.Font.regular.withSize(14)]
        }
    }
    
    func cellModel(for ad: ClassifiedAd, category: String?, style: DetailViewlStyle) -> DetailViewModel {
        let category = NSAttributedString(
            string: category ?? "",
            attributes: style.categoryAttributes
        )
        
        let id = NSAttributedString(
            string: Localized.detailId.stirng + String(ad.id),
            attributes: style.idAttributes
        )
        
        let title = NSAttributedString(
            string: ad.title,
            attributes: style.titleAttributes
        )
        
        let price = NSAttributedString(
            string: style.priceFormatter.string(from: NSNumber(value: ad.price)) ?? "",
            attributes: style.priceAttributes
        )
        
        let date: NSAttributedString
        if let creationDate = style.fromStringDateFormatter.date(from: ad.creationDate) {
            let string = style.toStringDateFormatter.string(from: creationDate)
            date = NSAttributedString(string: string, attributes: style.dateAttributes)
        } else {
            date = NSAttributedString()
        }
        
        let isUrgent = NSAttributedString(
            string: ad.isUrgent ? Localized.iSUrgentLong.stirng : "",
            attributes: style.isUrgentAttributes
        )
        
        let description = NSAttributedString(
            string: ad.description,
            attributes: style.descripionAttributes
        )
        
        var siret: NSAttributedString?
        if let string = ad.siret {
            siret = NSAttributedString(
                string: Localized.detailSiret.stirng + string,
                attributes: style.siretAttributes
            )
        }

        return DetailViewModel(
            placeHolder: Style.Image.placeHolderLandscape,
            imageUrl: ad.imagesUrl.thumb?.url,
            category: category,
            id: id,
            title: title,
            price: price,
            date: date,
            isUrgent: isUrgent,
            description: description,
            siret: siret
        )
    }
}
