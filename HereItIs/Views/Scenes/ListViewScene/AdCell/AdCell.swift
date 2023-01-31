//
//  AdCell.swift
//  HereItIs
//
//  Created by Pierre Navarre on 27/01/2023.
//

import UIKit


class AdCell: UICollectionViewCell {
    static let ReuseIdentifier: String = "AdCell"
    
    static var cellHeight: CGFloat {
        Constants.imageY + Constants.imageSize + Constants.margin
    }
    
    private enum Constants {
        static let cornerRadius: CGFloat = 10
        static let topMargin: CGFloat = 4
        static let margin: CGFloat = 8 // other margins for contentView
        static let imageY: CGFloat = 28
        static let imageSize: CGFloat = 140
        static let horizontalSpace: CGFloat = 16 // between image and title
    }
    
    private weak var imageView: ImageView!
    private weak var categoryLabel: UILabel!
    private weak var titleLabel: UILabel!
    private weak var priceLabel: UILabel!
    private weak var urgentLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        let category = UILabel()
        category.textAlignment = .right
        self.contentView.addSubview(category)
        category.translatesAutoresizingMaskIntoConstraints = false
        self.categoryLabel = category
        
        let imageView = ImageView(
            frame: CGRect(
                origin: CGPoint(x: Constants.margin, y: Constants.imageY),
                size: CGSize(width: Constants.imageSize, height: Constants.imageSize)
            )
        )
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(imageView)
        self.imageView = imageView
        
        let title = UILabel()
        title.numberOfLines = 0
        self.contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel = title
        
        let price = UILabel()
        self.contentView.addSubview(price)
        price.translatesAutoresizingMaskIntoConstraints = false
        self.priceLabel = price
        
        let urgent = UILabel()
        urgent.textAlignment = .right
        self.contentView.addSubview(urgent)
        urgent.translatesAutoresizingMaskIntoConstraints = false
        self.urgentLabel = urgent
        
        NSLayoutConstraint.activate([
            category.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Constants.margin),
            category.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            category.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constants.topMargin),
            
            title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.horizontalSpace),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Constants.margin),
            title.topAnchor.constraint(equalTo: imageView.topAnchor),
            
            urgent.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Constants.margin),
            urgent.centerYAnchor.constraint(equalTo: category.centerYAnchor),

            price.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            price.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8)
        ])
        
        self.contentView.backgroundColor = Style.Color.adCellBackground.color
        self.contentView.layer.cornerRadius = Constants.cornerRadius
    }
    
    func update(with model: AdCellModel) {
        self.imageView.placeHolder = model.placeHolder.image
        self.imageView.loadImage(from: model.imageUrl)
        self.categoryLabel.attributedText = model.category
        self.titleLabel.attributedText = model.title
        self.priceLabel.attributedText = model.price
        self.urgentLabel.attributedText = model.isUrgent
    }
    
}
