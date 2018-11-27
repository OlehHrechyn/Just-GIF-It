//
//  GifViewController.swift
//  JUST GIF IT
//
//  Created by Developer on 11/27/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

class GifViewController: UIViewController {
    @IBOutlet private weak var gifImageView: UIImageView!
    
}

//MARK: - Lifecycle
extension GifViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogic()
        setupUI()
    }
}

//MARK: - IBActions
extension GifViewController {
    @IBAction func viewDidTape(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Private
private extension GifViewController {
    func setupLogic() {

    }
    
    func setupUI() {
        gifImageView.layer.setBorder(color: .orange, width: 2.0)
    }
    
}
