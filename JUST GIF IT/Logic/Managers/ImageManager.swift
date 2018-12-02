//
//  ImageManager.swift
//  JUST GIF IT
//
//  Created by Developer on 12/2/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

protocol ImageManagerDelegate: AnyObject {
    func imageManager(_ imageManager: ImageManager?, didUpdateImages images: [GetRequestImage])
    func imageManager(_ imageManager: ImageManager?, failedUpdating error: Error?)
}

class ImageManager {
    static let kStoredImagesURLs = "storedImagesURLs"

    weak var delegate: ImageManagerDelegate?
    var images = [GetRequestImage]()
}

//MARK: - Public
extension ImageManager {
    func downloadImages() {
        APIManager.getAllImages { [weak self] (downloadedImages, error) in
            guard let downloadedImages = downloadedImages else {
                self?.delegate?.imageManager(self, failedUpdating: error)
                return
            }
            self?.images = downloadedImages
            self?.delegate?.imageManager(self, didUpdateImages: downloadedImages)
        }
    }
    
}

//MARK: - Private
extension ImageManager {

    var storedImagesURLs: [String] {
        if let storedImages = UserDefaults.standard.array(forKey: ImageManager.kStoredImagesURLs) as? [String] {
            return storedImages
        } else {
            return []
        }
    }
    
}
