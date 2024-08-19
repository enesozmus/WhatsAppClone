//
//  UIWindowScene+Extensions.swift
//  WhatsAppClone
//
//  Created by enesozmus on 19.08.2024.
//

import UIKit

extension UIWindowScene {
    static var current: UIWindowScene? {
        return UIApplication.shared.connectedScenes
            .first {
                $0 is UIWindowScene
            } as? UIWindowScene
    }
    
    var screenHeight: CGFloat {
        return UIWindowScene.current?.screen.bounds.height ?? 0
    }
    
    var screenWidth: CGFloat {
        return UIWindowScene.current?.screen.bounds.width ?? 0
    }
}
