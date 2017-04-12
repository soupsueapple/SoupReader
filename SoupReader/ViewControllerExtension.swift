//
//  ViewControllerExtension.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/12.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController{
    func showAlert(text: String!){
        let alertViewController = UIAlertController.init(title: "提示", message: text, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
}
