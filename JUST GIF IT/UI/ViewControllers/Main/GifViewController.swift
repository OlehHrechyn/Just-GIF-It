//
//  GifViewController.swift
//  JUST GIF IT
//
//  Created by Developer on 11/27/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import SwiftyGif

class GifViewController: UIViewController {
    @IBOutlet private weak var gifImageView: UIImageView!
    @IBOutlet private weak var gifActivityView: UIActivityIndicatorView!
    
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
        gifImageView.delegate = nil // because delegate in framework is not weak and GifViewController has not been released
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Private
private extension GifViewController {
    func setupLogic() {
        DispatchQueue.main.async { [weak self] in
            self?.gifActivityView.start()
        }
        let url = URL(string: "https://media.giphy.com/media/l3vR92g7FWGIYhzC8/giphy.gif")
        gifImageView.setGifFromURL(url, showLoader: false)
        gifImageView.delegate = self
    }
    
    func setupUI() {
        DispatchQueue.main.async { [weak self] in
            self?.gifImageView.layer.setBorder(color: .orange, width: 2.0)
        }
    }
    
}
extension GifViewController : SwiftyGifDelegate {
    
    func gifURLDidFinish(sender: UIImageView) {
        DispatchQueue.main.async { [weak self] in
            self?.gifActivityView.stop()
        }
    }
}
