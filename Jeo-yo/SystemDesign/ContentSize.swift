//
//  ContentSize.swift
//  Jeo-yo
//
//  Created by 김수경 on 9/24/24.
//

import UIKit

enum ContentSize {
    static var screenWidth: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds.size.width
        }
        return UIScreen.main.bounds.size.width
    }
    static var screenHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds.size.height
        }
        return UIScreen.main.bounds.size.height
    }
    
    case profileImageCell
    case contentUserProfileImage
    case joinButton
    case informationImage
    case floatingButton
    case unit
}
