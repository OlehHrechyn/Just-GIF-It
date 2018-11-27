//
//  GalleryViewController.swift
//  JUST GIF IT
//
//  Created by Developer on 11/25/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {


}

//MARK: - Lifecycle
extension GalleryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogic()
        setupUI()
    }
}

//MARK: - Private
private extension GalleryViewController {
    func setupLogic() {
        hideKeyboardOnTap()
    }
    
    func setupUI() {
        navigationController?.navigationBar.setGradientBackground(colors: [.darkGray, .black])
    }
    
}

