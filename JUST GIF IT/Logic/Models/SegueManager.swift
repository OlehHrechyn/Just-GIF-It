//
//  SegueManager.swift
//  JUST GIF IT
//
//  Created by Developer on 11/30/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

enum SegueIdentifier: String {
    case toMainStoryboard = "toMainStoryboard"
    case toLoginStoryboard = "toLoginStoryboard"
    case toGifViewController = "toGifViewController"
}

protocol SegueCustomPerform {
    
}

extension SegueCustomPerform where Self: UIViewController {
    func performSegue(withIdentifier: SegueIdentifier, sender: Any?) {
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: withIdentifier.rawValue, sender: sender)
        }
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier \(String(describing: segue.identifier)).")
        }
        return segueIdentifier
    }
}
