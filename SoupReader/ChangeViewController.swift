//
//  ChangeViewController.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/24.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit

class ChangeViewController: UIViewController {
    
    @IBOutlet weak var bg_iv: UIImageView!
    
    var image: UIImage?
    
    @IBAction func dismis(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bg_iv.image = image
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
