//
//  GalleryViewController.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class GalleryViewController: UIViewController, SegueCustomPerform {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var playGifButton: UIBarButtonItem!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
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
        ImageManager.shared.delegate = self
        ImageManager.shared.downloadImages()
        activityView.start()
        
        collectionView.register(GalleryImageCell.classNib(), forCellWithReuseIdentifier: GalleryImageCell.className())
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        hideKeyboardOnTap()
    }
    
    func setupUI() {
        setupPlayGifButton()
        navigationController?.navigationBar.setAppStyle()
    }
    
    func setupPlayGifButton() {
        DispatchQueue.main.async { [weak self] in
            self?.playGifButton.isEnabled = ImageManager.shared.images.count > 0
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageManager.shared.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryImageCell.className(), for: indexPath) as? GalleryImageCell else {
            fatalError("GalleryImageCell unwrapping error")
        }
        cell.configure(with: ImageManager.shared.images[indexPath.item])
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
    func imageManager(_ imageManager: ImageManager?, didUpdateImages images: [LocalImageModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.activityView.stop()
            self?.collectionView.reloadData()
            self?.setupPlayGifButton()
        }
    }
    
    func imageManager(_ imageManager: ImageManager?, didFailFetching error: Error?) {
        if let error = error {
            activityView.stop()
            showAlert(error: error)
        }
    }
    
    func imageManager(_ imageManager: ImageManager?, model: LocalImageModel, didReceiveAddress address: String) {
        if let index = ImageManager.shared.images.firstIndex(where: {$0 == model}) {
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
}

//MARK: - EmptyDataSetSource, EmptyDataSetDelegate
extension GalleryViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage.picturePlaceholder()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Ooops...")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "You have not uploaded any images and can not view the GIF.")
    }
}
