//
//  UIImageExtension.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/5/6.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import Foundation

extension UIImage{
    
    func imageByScalingToSize(targetSize: CGSize) -> UIImage{
        
        let sourceImage = self;
        var newImage: UIImage!
        
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        
        let targetWidth = targetSize.width
        let targetHeight = targetSize.height
        
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        
        if __CGSizeEqualToSize(imageSize, targetSize){
            let widthFactor = targetWidth / width
            let heightFactor = targetHeight / height
            
            if widthFactor < heightFactor{
                
                scaleFactor = widthFactor
                
            }else{
                
                scaleFactor = heightFactor
                scaledWidth  = width * scaleFactor
                scaledHeight = height * scaleFactor
                
                if widthFactor < heightFactor{
                    
                    thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
                    
                }else if widthFactor > heightFactor{
                    
                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
                    
                }
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
