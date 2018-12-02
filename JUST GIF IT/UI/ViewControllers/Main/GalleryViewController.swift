//
//  GalleryViewController.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, SegueCustomPerform {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let imagesManager = ImageManager()
}

//MARK: - Lifecycle
extension GalleryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogic()
        setupUI()
    }
}

//MARK: - IBActions
private extension GalleryViewController {
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        UserManager.logout()
        performSegue(withIdentifier: .toLoginStoryboard, sender: nil)
    }
}

//MARK: - Private
private extension GalleryViewController {
    func setupLogic() {
        imagesManager.delegate = self
        imagesManager.downloadImages()
        collectionView.register(GalleryImageCell.classNib(), forCellWithReuseIdentifier: GalleryImageCell.className())
        hideKeyboardOnTap()
    }
    
    func setupUI() {
        navigationController?.navigationBar.setAppGradientBackground()
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesManager.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryImageCell.className(), for: indexPath) as? GalleryImageCell else {
            fatalError("GalleryImageCell unwrapping error")
        }
        cell.configure(with: imagesManager.images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width * 0.8) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 20.0, bottom: 25.0, right: 20.0)
    }
}

//MARK: - ImageManagerDelegate
extension GalleryViewController: ImageManagerDelegate {
    func imageManager(_ imageManager: ImageManager?, didUpdateImages images: [GetRequestImage]) {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func imageManager(_ imageManager: ImageManager?, failedUpdating error: Error?) {
        if let error = error {
            showAlert(error: error)
        }
    }
    
    
}
