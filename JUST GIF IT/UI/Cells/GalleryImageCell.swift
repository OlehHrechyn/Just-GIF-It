//
//  GalleryImageCell.swift
//  JUST GIF IT
//
//  Created by Developer on 12/2/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import Kingfisher

class GalleryImageCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var weatherLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
}

//MARK: - Lifecycle
extension GalleryImageCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

//MARK: - Public
extension GalleryImageCell {
    
    final class func className() -> String {
        return String(describing: self)
    }
    
    final class func classNib() -> UINib {
        return UINib.init(nibName: GalleryImageCell.className(), bundle: nil)
    }
    
    func configure(with image: GetRequestImage) {
        DispatchQueue.main.async { [weak self] in
            if let stringUrl = image.smallImagePath, let url = URL(string: stringUrl) {
                let resource = ImageResource(downloadURL: url, cacheKey: image.smallImagePath)
                self?.imageView.kf.indicatorType = .activity
                self?.imageView.kf.setImage(with: resource, placeholder: UIImage.picturePlaceholder())
            }
            self?.weatherLabel.text = image.parameters?.weather
            self?.addressLabel.text = LocationManager.getPlaceName(latitude: image.parameters?.latitude, longitude: image.parameters?.longitude)
        }
    }
    
}
