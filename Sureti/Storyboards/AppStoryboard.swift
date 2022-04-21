//
//  AppStoryboard.swift
//  nullbrainer-sureti
//
//  Created by Amjad on 20/04/2022.
//

import Foundation


import UIKit
enum AppStoryboard:String{
    case main = "Main"
    var instance :UIStoryboard{
        return UIStoryboard(name:self.rawValue,bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type) -> T{
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return (instance.instantiateViewController(withIdentifier: storyboardID) as! T)
    }
    func initialViewController()->UIViewController?{
        return instance.instantiateInitialViewController()
    }
}

extension UIViewController{
    class var storyboardID:String{
        return "\(self)"
    }
    
    static func instantiate(storyboard:AppStoryboard = .main)-> Self?{
        return storyboard.viewController(viewControllerClass: self)
    }
}
