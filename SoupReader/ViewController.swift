//
//  ViewController.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/12.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate{
    
    var tags: Array<TagBean> = []
    
    var eName: String = String()
    var itemName: String = String()
    var link: String = String()
    var tTitle: String = String()
    var date: String = String()
    var subject: String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        doBlogXMLRequest()
    }
    
    func doBlogXMLRequest() -> Void{
        let httpClient = HttpClient(baseURL: URL(string: HttpClient.iOSURL))
        httpClient.httpClientSetting()
        httpClient.getRequest(url: "", paramters: nil, block: {(any: Any?, error: Error?) -> Void in
            
            if httpClient.httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                
                return
            }
            
            let data = any as! Data
            
            let parse = XMLParser(data: data)
            parse.delegate = self
            parse.parse()
            
        })
    }
    
    // MARK: XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        eName = elementName
        
        if elementName == "item" {
            itemName = elementName
            
            self.link = String()
            self.tTitle = String()
            self.date = String()
            self.subject = String()
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            
            let tag = TagBean()
            tag.link = self.link
            tag.title = self.tTitle
            tag.date = self.date
            tag.subject = self.subject
            
            tags.append(tag)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty{
            
            if itemName == "item"{
                
                if eName == "link" {
                    self.link += data
                } else if eName == "title" {
                    self.tTitle += data
                } else if eName == "dc:date" {
                    self.date += data
                }   else if eName == "dc:subject" {
                    self.subject += data
                }
                
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        for tag in tags{
            print("\(tag.link)\n\(tag.title)\n\(tag.date)\n\(self.subject)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

