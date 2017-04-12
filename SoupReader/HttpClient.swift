//
//  HttpClient.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/12.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit
import AFNetworking

class HttpClient: AFHTTPSessionManager {
    
    public static let iOSURL: String = "https://feeds.pinboard.in/rss/u:soupsue/t:MyBlog"
    
    func httpClientSetting() -> Void {
        self.securityPolicy = AFSecurityPolicy.init(pinningMode: .none)
        self.responseSerializer = AFHTTPResponseSerializer()
        self.responseSerializer.acceptableContentTypes = ["text/html", "text/plain", "text/xml","application/json", "text/json", "text/javascript", "application/rss+xml"]
    }
    
    func httpError(error: Error?) -> Bool{
        if error != nil{
            
            return true
        }
        
        return false
    }
    
    public func getRequest(url: String!, paramters: Dictionary<String, String>!, block: @escaping (_ responseObject: Any?, _ error: Error?) -> Void){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.get(url, parameters: paramters, progress: nil, success: {(task: URLSessionDataTask?, json: Any?) -> Void in
            
            block(json, nil)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }, failure: {(task: URLSessionDataTask?, error: Error?) -> Void in
            
            block(nil, error)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        })
    }
    
    public func postRequest(url: String!, paramters: Dictionary<String, String>!, block: @escaping (_ responseObject: Any?, _ error: Error?) -> Void){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.post(url, parameters: paramters, progress: nil, success: {(task: URLSessionDataTask?, json: Any?) -> Void in
            
            block(json, nil)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }, failure: {(task: URLSessionDataTask?, error: Error?) -> Void in
            
            block(nil, error)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
}


