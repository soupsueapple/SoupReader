//
//  ImageViewController.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/21.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imgae: UIImage!

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = imgae
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
