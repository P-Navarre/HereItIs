//
//  ErrorView.swift
//  HereItIs
//
//  Created by Pierre Navarre on 30/01/2023.
//

import UIKit

class ErrorView: UIView {
    
    private enum Constants {
        static let messageRelativeTop: CGFloat = 1/3
        static let messageMaxRelativeWidth: CGFloat = 0.75
        static let messageMaxWidth: CGFloat = 600
    }
    
    private weak var messageLabel: UILabel!
    private weak var retryButton: UIButton!
    private var retryHandler: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapRetry(_ sender: UIButton) {
        self.retryHandler?()
    }
    
    private func configureUI() {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        self.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel = messageLabel
        
        let retryButton = UIButton()
        retryButton.layer.cornerRadius = 8
        retryButton.clipsToBounds = true
        self.addSubview(retryButton)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.addTarget(self, action: #selector(self.didTapRetry), for: .touchUpInside)
        self.retryButton = retryButton
        
        let messageGuide = UILayoutGuide() // Vertical guide for messageLabel
        self.addLayoutGuide(messageGuide)
        let buttonGuide = UILayoutGuide() // Vertical guide for retryButton
        self.addLayoutGuide(buttonGuide)
        
        NSLayoutConstraint.activate([
            messageGuide.topAnchor.constraint(equalTo: self.topAnchor),
            messageGuide.heightAnchor.constraint(
                equalTo: self.heightAnchor, multiplier: Constants.messageRelativeTop
            ),
            
            messageLabel.widthAnchor.constraint(
                lessThanOrEqualTo: self.widthAnchor, multiplier: Constants.messageMaxRelativeWidth
            ),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.messageMaxWidth),
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: messageGuide.bottomAnchor),
            
            buttonGuide.topAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            buttonGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            retryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            retryButton.centerYAnchor.constraint(equalTo: buttonGuide.centerYAnchor),
            retryButton.widthAnchor.constraint(equalTo: messageLabel.widthAnchor)
        ])
    }
    
    func update(with model: ErrorViewModel) {
        self.messageLabel.attributedText = model.message
        self.retryButton.backgroundColor = model.buttonBackground
        self.retryButton.setAttributedTitle(model.buttonTitle, for: .normal)
        self.retryHandler = model.retryHandler
    }
    
}

