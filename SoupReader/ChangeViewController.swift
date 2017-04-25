//
//  ChangeViewController.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/24.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit

public protocol ChangeViewControllerDelegate: NSObjectProtocol{
    func changeTypeSizeToSmall() -> Void
    func changeTypeSizeToBig() -> Void
}

class ChangeViewController: UIViewController {
    
    weak open var changeViewControllerDelegate: ChangeViewControllerDelegate?
    
    var image: UIImage?
    
    @IBAction func dismis(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func changeTypeSizeToSmall(_ sender: Any) {
        self.changeViewControllerDelegate?.changeTypeSizeToSmall()
    }
    
    @IBAction func changeTypeSizeToBig(_ sender: Any) {
        self.changeViewControllerDelegate?.changeTypeSizeToBig()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
