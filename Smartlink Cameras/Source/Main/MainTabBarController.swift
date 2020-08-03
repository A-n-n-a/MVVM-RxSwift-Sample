//
//  MainTabBarController.swift
//  Smartlink Cameras
//
//  Created by SecureNet Mobile Team on 1/10/20.
//  Copyright © 2020 SecureNet Technologies, LLC. All rights reserved.
//

import UIKit

enum ImageType {
    
}

extension ImageType {
    
    static func setImage(name: String) -> UIImage {
        guard let image = UIImage(named: name) else {
            fatalError("Specific UIImage could not be found from assets: \(name)")
        }
        return image
    }
    
}

enum TabBarItems: Int, CaseIterable {
    case activity
    case cameraList
    case settings
    
    var image: UIImage {
        switch self {
            case .activity:
                return ImageType.setImage(name: "icon-activity")
            
            case .cameraList:
                return ImageType.setImage(name: "icon-video")
            
            case .settings:
                return ImageType.setImage(name: "icon-settings")
        }
    }
    
    static func getAllCases() -> [TabBarItems] {
        return TabBarItems.allCases
    }
}

final class MainTabBarController: UITabBarController {

    // MARK: - UI variables
    fileprivate lazy var tabBarAppearance: UITabBarAppearance = {
        let appearance = UITabBarAppearance()
        appearance.backgroundImage = UIImage()
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        return appearance
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureAppearance()
    }

}

extension MainTabBarController {
    
    fileprivate func configureAppearance() {
        if #available(iOS 13.0, *) {
            tabBar.standardAppearance = tabBarAppearance
        }
        else {
            tabBar.backgroundImage = UIImage()
            tabBar.isTranslucent = true
            tabBar.itemPositioning = .centered
            tabBar.shadowImage = UIImage()
        }
        
        tabBar.tintColor = .lightGray
        tabBar.unselectedItemTintColor = .black
        
        viewControllers = TabBarItems.getAllCases().map({ item -> UINavigationController in
            let newNC = UINavigationController()
            newNC.tabBarItem = UITabBarItem(title: nil,
                                            image: item.image,
                                            tag: item.hashValue)
            return newNC
        })
    }
    
}
