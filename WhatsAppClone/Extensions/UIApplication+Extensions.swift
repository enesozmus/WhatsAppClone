//
//  UIApplication+Extensions.swift
//  WhatsAppClone
//
//  Created by enesozmus on 19.08.2024.
//

import UIKit

extension UIApplication {
    
    /// Disappear the keyboard
    static func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIApplication.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
