//
//  MainViewController.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/12.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    let identity = "LaunchScreen"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let sbBlog = UIStoryboard(name: "Blog", bundle: nil)
        let sbDiscover = UIStoryboard(name: "Discover", bundle: nil)
        let sbSetting = UIStoryboard(name: "Setting", bundle: nil)
        
        let blogNavigationViewController = sbBlog.instantiateViewController(withIdentifier: "Blog") as! UINavigationController
        let discoverNavigationViewController = sbDiscover.instantiateViewController(withIdentifier: "Discover") as! UINavigationController
        let settingNavigationViewController = sbSetting.instantiateViewController(withIdentifier: "Setting") as! UINavigationController
        
        blogNavigationViewController.tabBarItem = UITabBarItem(title: "Read", image: UIImage.init(named: "blog"), tag: 0)
        discoverNavigationViewController.tabBarItem = UITabBarItem(title: "Featured", image: UIImage.init(named: "favorite"), tag: 1)
        settingNavigationViewController.tabBarItem = UITabBarItem(title: "Other", image: UIImage.init(named: "setting"), tag: 2)
        
        self.viewControllers = [blogNavigationViewController, discoverNavigationViewController, settingNavigationViewController]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let viewController = UIStoryboard(name: identity, bundle: nil).instantiateViewController(withIdentifier: identity)
        
        let launchView = viewController.view
        let mainWindow = UIApplication.shared.keyWindow
        launchView?.frame = (UIApplication.shared.keyWindow?.frame)!
        mainWindow?.addSubview(launchView!)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
        
            launchView?.alpha = 0.0
            launchView?.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0, 2.0, 1.0)
            
        }, completion: {(finished: Bool) -> Void in
        
            launchView?.removeFromSuperview()
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
