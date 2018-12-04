//
//  ImageManager.swift
//  JUST GIF IT
//
//  Created by Developer on 12/2/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import Kingfisher

protocol ImageManagerDelegate: AnyObject {
    func imageManager(_ imageManager: ImageManager?, didUpdateImages images: [LocalImageModel])
    func imageManager(_ imageManager: ImageManager?, didFailFetching error: Error?)
    func imageManager(_ imageManager: ImageManager?, model: LocalImageModel, didReceiveAddress address: String)
}

class ImageManager {
    static let shared = ImageManager()
    
    weak var delegate: ImageManagerDelegate?
    var images = [LocalImageModel]()
    
    private init(){}
}

//MARK: - Public
extension ImageManager {
    func downloadImages() {
        APIManager.getAllImages { [weak self] (downloadedImages, error) in
            guard let downloadedImages = downloadedImages else {
                self?.delegate?.imageManager(self, didFailFetching: error)
                return
            }
            self?.images = ImageManager.convert(images: downloadedImages)
            self?.delegate?.imageManager(self, didUpdateImages: self?.images ?? [])
        }
    }
    
    func uploadImage(_ image: UIImage?, description: String?, hashtag: String?, completion: @escaping ErrorCompletion) {
        
        guard let image = image, !image.isPlaceholder() else {
            completion(InternalError.blank(APIManager.imageKey.capitalized))
            return
        }
        
        guard LocationManager.locationServicesEnabledOrNotDetermined() else {
            completion(InternalError.custom("Please enable the location detecting"))
            return
        }
        
        LocationManager.shared.getCurrentLocation { (location) in
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            APIManager.uploadImage(image, description: description ?? "", hashtag: hashtag ?? "", latitude: latitude, longitude: longitude) { [weak self] (uploadImage, error) in
                if let uploadImage = uploadImage {
                    var localImage = ImageManager.convert(image: uploadImage)
                    localImage.description = description
                    localImage.hashtag = hashtag
                    localImage.latitude = latitude
                    localImage.longitude = longitude
                    localImage.address = LocationManager.coordinatesString(latitude: localImage.latitude, longitude: localImage.longitude)
                    self?.updateAddressForModel(localImage)
                    if let url = localImage.smallImagePath {
                        ImageCache.default.store(image, forKey: url)
                    }
                    self?.addImage(localImage)
                }
                completion(error)
            }
        }
    }
    
    func clear() {
        images = []
    }
}

//MARK: - Private
private extension ImageManager {
    func addImage(_ image: LocalImageModel) {
        images.append(image)
        delegate?.imageManager(self, didUpdateImages: images)
    }
    
    func updateAddressForModel(_ model: LocalImageModel) {
        LocationManager.getPlaceName(latitude: model.latitude, longitude: model.longitude) {[weak self] (address, error) in
            if let address = address {
                var model = model
                if let index = self?.images.firstIndex(where: { $0 == model}) {
                    model.address = address
                    self?.images[index] = model
                }
                self?.delegate?.imageManager(self, model: model, didReceiveAddress: address)
            }
        }
    }
    
}

//MARK: - Private Converting
private extension ImageManager {
    final class func convert(images: [GetRequestImage]) -> [LocalImageModel] {
        var localImages = [LocalImageModel]()
        for image in images {
            let localImage = ImageManager.convert(image: image)
            ImageManager.shared.updateAddressForModel(localImage)
            localImages.append(localImage)
        }
        return localImages
    }
    
    final class func convert(image: GetRequestImage) -> LocalImageModel {
        var localImage = LocalImageModel()
        localImage.description = image.description
        localImage.hashtag = image.hashtag
        localImage.smallImagePath = image.smallImagePath
        localImage.bigImagePath = image.bigImagePath
        
        localImage.latitude = image.parameters?.latitude
        localImage.longitude = image.parameters?.longitude
        localImage.weather = image.parameters?.weather
        
        localImage.address = LocationManager.coordinatesString(latitude: localImage.latitude, longitude: localImage.longitude)
        return localImage
    }
    
    final class func convert(images: [UploadRequestImage]) -> [LocalImageModel] {
        var localImages = [LocalImageModel]()
        for image in images {
            localImages.append(ImageManager.convert(image: image))
        }
        return localImages
    }
    
    final class func convert(image: UploadRequestImage) -> LocalImageModel {
        var localImage = LocalImageModel()
        localImage.smallImagePath = image.smallImage
        localImage.bigImagePath = image.bigImage
        localImage.weather = image.parameters?.weather

        return localImage
    }
    
}
