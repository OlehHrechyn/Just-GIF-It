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
        gifImageView.delegate = self
        setupGif()
    }
    
    func setupGif() {
        DispatchQueue.main.async { [weak self] in
            self?.gifActivityView.start()
            
            APIManager.getGifLink { (url, error) in
                if let error = error {
                    self?.gifActivityView.stop()
                    self?.showAlert(error: error)
                } else if let url = url {
                    self?.gifImageView.setGifFromURL(url, showLoader: false)
                } else {
                    self?.gifActivityView.stop()
                }
            }
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
