//
//  BaseTabBarConroller.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/05/01.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    enum ControllerName: Int {
        case home, search, channel, inbox, library
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      TabVCの画像を決める
//      タブの位置はインデックスで取得可能
        viewControllers?.enumerated().forEach({ (index, viewcontroller) in
            if let name = ControllerName.init(rawValue: index) {
                switch name {
                case .home:
                    setTabBarInfo(viewcontroller, selectedImageName: "home_selected",
                                  imageName: "home", title: "Home")
                                    case .search:
                    setTabBarInfo(viewcontroller, selectedImageName: "safari_selected",
                                  imageName: "safari", title: "Search")
                                    case .channel:
                    setTabBarInfo(viewcontroller, selectedImageName: "channel_selected",
                                  imageName: "channel", title: "Channel")
                                    case .inbox:
                    setTabBarInfo(viewcontroller, selectedImageName: "mail_selected",
                                  imageName: "mail", title: "Inbox")
                                    case .library:
                    setTabBarInfo(viewcontroller, selectedImageName: "library_selected",
                                  imageName: "library", title: "Library")
                }
            }
        })
    }
    
    private func setupVCs(){
        
    }
    
    private func setTabBarInfo(_ viewController: UIViewController, selectedImageName: String, imageName: String, title: String) {
//        選択時
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
//        デフォルト
        viewController.tabBarItem.image = UIImage(named: imageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.title = title
    }
    
}
