//
//  ReplaceRootSegue.swift
//  JUST GIF IT
//
//  Created by Developer on 11/26/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

enum Segue: String {
    case toMainStoryboard = "toMainStoryboard"
    case toGifViewController = "toGifViewController"
}

class ReplaceRootSegue: UIStoryboardSegue {
    override func perform() {
        guard let window = UIApplication.shared.keyWindow else { return }
        UIView.transition(with: window, duration: 0.3, options: .curveEaseInOut, animations: { [weak self] in
            window.rootViewController = self?.destination
        })
        
    }
}
