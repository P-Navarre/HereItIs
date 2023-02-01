//
//  DetailViewController.swift
//  HereItIs
//
//  Created by Pierre Navarre on 30/01/2023.
//

import UIKit

@MainActor
protocol DetailViewControllerInput: AnyObject {
    func showContent(_ model: DetailViewModel)
}

final class DetailViewController: UIViewController {
    private enum Constants {
        static let horizontalMargin: CGFloat = 16
        static let verticalMargin: CGFloat = 12 // Between image and stackView
        static let stackViewVerticaleSpace : CGFloat = 8
        static let lineHorizontalSpace: CGFloat = 4
    }
    
    // MARK: - Properties
    private let content: (ad: ClassifiedAd, category: String?)
    private var presenter: DetailViewPresenterInput!
    
    private let scrollView: UIScrollView = UIScrollView()
    private let imageView: ImageView! = ImageView(frame: .zero)
    private let categoryLabel: UILabel = UILabel()
    private let idLabel: UILabel = UILabel()
    private let titleLabel: UILabel = UILabel()
    private let priceLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
    private let urgentLabel: UILabel = UILabel()
    private let descriptiontLabel: UILabel = UILabel()
    private let sirettLabel: UILabel = UILabel()
    
    init(ad: ClassifiedAd, category: String?) {
        self.content = (ad, category)
        super.init(nibName: nil, bundle: nil)
        self.presenter = DetailViewPresenter(viewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter.willAppear(for: self.content.ad, category: self.content.category)
    }
    
}

// MARK: - UI configuration
private extension DetailViewController {
    func configureUI() {
        self.scrollView.frame = self.view.bounds
        self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.backgroundColor = .systemBackground
        self.view.addSubview(self.scrollView)
        
        self.layoutImageView()
        self.layoutStackView()
    }
    
    func layoutImageView() {
        let background = UIView() // A background view for image, with backgroundColor
        background.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(background)
        background.backgroundColor = .systemGray6
        
        self.imageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            background.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            background.topAnchor.constraint(equalTo: self.imageView.topAnchor),
            background.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            
            // scrollView contentSize width
            background.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            background.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
            
            self.imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.imageView.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor)
        ])
    }
    
    func layoutStackView() {
        var rows: [UIView] {[
            self.newLine(arrangedSubviews: [self.categoryLabel, self.idLabel]),
            self.titleLabel,
            self.priceLabel,
            self.newLine(arrangedSubviews: [self.dateLabel, self.urgentLabel]),
            self.descriptiontLabel,
            self.sirettLabel
        ]}
        
        let stack = UIStackView(arrangedSubviews: rows)
        stack.axis = .vertical
        stack.spacing = Constants.stackViewVerticaleSpace
        
        self.scrollView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: Constants.verticalMargin),
            stack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.horizontalMargin),
            stack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.horizontalMargin),
            stack.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
        ])
        
        self.idLabel.textAlignment = .right
        self.idLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.idLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.titleLabel.numberOfLines = 0
        self.urgentLabel.textAlignment = .right
        self.urgentLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.urgentLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.descriptiontLabel.numberOfLines = 0
    }
    
    func newLine(arrangedSubviews: [UIView]) -> UIStackView {
        let line = UIStackView(arrangedSubviews: arrangedSubviews)
        line.spacing = Constants.lineHorizontalSpace
        line.alignment = .center
        return line
    }
}

// MARK: - DetailViewControllerInput
extension DetailViewController: DetailViewControllerInput {
    func showContent(_ model: DetailViewModel) {
        self.imageView.placeHolder = model.placeHolder.image
        Task { await self.imageView.loadImage(from: model.imageUrl) }
        self.categoryLabel.attributedText = model.category
        self.idLabel.attributedText = model.id
        self.titleLabel.attributedText = model.title
        self.priceLabel.attributedText = model.price
        self.dateLabel.attributedText = model.date
        self.urgentLabel.attributedText = model.isUrgent
        self.descriptiontLabel.attributedText = model.description
        self.sirettLabel.attributedText = model.siret
    }
}
