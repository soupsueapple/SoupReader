//
//  MainViewController.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/12.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let sbBlog = UIStoryboard(name: "Blog", bundle: nil)
        let sbDiscover = UIStoryboard(name: "Discover", bundle: nil)
        
        let blogNavigationViewController = sbBlog.instantiateViewController(withIdentifier: "Blog") as! UINavigationController
        let discoverNavigationViewController = sbDiscover.instantiateViewController(withIdentifier: "Discover") as! UINavigationController
        
        blogNavigationViewController.tabBarItem = UITabBarItem(title: "Blog", image: nil, tag: 0)
        discoverNavigationViewController.tabBarItem = UITabBarItem(title: "Discover", image: nil, tag: 0)
        
        self.viewControllers = [blogNavigationViewController, discoverNavigationViewController]
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
