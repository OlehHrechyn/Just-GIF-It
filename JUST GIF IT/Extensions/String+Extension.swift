//
//  String+Extension.swift
//  JUST GIF IT
//
//  Created by Developer on 11/27/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        return count >= 3
    }
}
