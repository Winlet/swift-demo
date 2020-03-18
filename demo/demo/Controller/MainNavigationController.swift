//
//  MainNavigationController.swift
//  demo
//
//  Created by uinpay on 2020/3/18.
//  Copyright © 2020 U-NAS. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil);
        if viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true;
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(popSelf))
            viewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.white;
            
        }
        super.pushViewController(viewController, animated: animated);
    }
    
    @objc func popSelf() {
        self.popViewController(animated: true);
    }

}
