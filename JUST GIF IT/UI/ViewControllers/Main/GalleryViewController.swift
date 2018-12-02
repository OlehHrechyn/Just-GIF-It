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
        hideKeyboardOnTap()
    }
    
    func setupUI() {
        navigationController?.navigationBar.setAppGradientBackground()
    }
    
}

