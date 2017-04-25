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
        
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(scaleImage(gesture:)))
        imageView.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panImage(gesture:)))
        imageView.addGestureRecognizer(panGesture)
    }
    
    func scaleImage(gesture: UIPinchGestureRecognizer){
        let state = gesture.state
        
        if state == .began || state == .changed{
            let scale = gesture.scale
            gesture.view?.transform = (gesture.view?.transform)!.scaledBy(x: scale, y: scale)
            gesture.scale = 1.0
        }
    }
    
    func panImage(gesture: UIPanGestureRecognizer){
        if gesture.state == .began || gesture.state == .changed{
            
            let view = gesture.view
            let translation = gesture.translation(in: view?.superview)
            view?.center = CGPoint(x: (view?.center.x)! + translation.x, y: (view?.center.y)! + translation.y)
            gesture.setTranslation(CGPoint.zero, in: view?.superview)
        }
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
