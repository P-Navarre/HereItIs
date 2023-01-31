//
//  ImageView.swift
//  HereItIs
//
//  Created by Pierre Navarre on 28/01/2023.
//

import UIKit

final class ImageView: UIImageView {
    var placeHolder: UIImage?
    
    private let imageLoader: ImageLoaderProtocol
    private var url: URL?
    
    init(frame: CGRect, imageLoader: ImageLoaderProtocol = ImageLoader.shared) {
        self.imageLoader = imageLoader
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(from url: URL?) {
        self.url = url
        self.image = self.placeHolder
        guard let url = url else { return }
        Task { [weak self] in
            let image = try await self?.imageLoader.image(from: url)
            guard url == self?.url, // Check that the url has not been modified
                  let image = image else { return }
            self?.image = image
        }
    }
}
