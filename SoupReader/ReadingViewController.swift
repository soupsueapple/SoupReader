//
//  ReadingViewController.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/13.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit
import Ono

class ReadingViewController: UIViewController {
    
    @IBOutlet weak var context_TV: UITextView!
    
    var tag = TagBean()
    
    var readContexts: Array<ReadContext> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = tag.title
        self.context_TV.isEditable = false
        self.automaticallyAdjustsScrollViewInsets = false;
        
        doHtmlRequest(url: tag.link)
    }
    
    // MARK: download image
    func downlongImage(url: String) -> Void{
        let httpClient = HttpClient()
        httpClient.httpClientSetting()
        httpClient.getRequest(url: url, paramters: nil, block: {(any: Any?, error: Error?) -> Void in
            
            if httpClient.httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                return
            }
            
            let data = any as! Data
            UIImage(data: data)
        })
    }
    
    // MARK: HTMLParser
    func doHtmlRequest(url: String) -> Void{
        
        let data = NSData(contentsOf: URL(string: url)!)
        
        do{
            let doc = try ONOXMLDocument.htmlDocument(with: data! as Data)
            
            let postsParentElement: ONOXMLElement? = doc.firstChild(withXPath: "//*[@id='primary']")
            
            if let p = postsParentElement{
                
                
                
                for (_, element) in p.children.enumerated() {
                    let e: ONOXMLElement = element as! ONOXMLElement
                    
                    let articleElement = e.firstChild(withTag: "article")
                    
                    if let article = articleElement{

                        
                        // 文章头
                        let headerElement = article.firstChild(withTag: "header")
                        
                        if let header = headerElement{
                            
                            // 封面
                            let divs = header.children(withTag: "div")
                            
                            for (_, div) in (divs?.enumerated())!{
                                
                                let d = div as! ONOXMLElement
                                let imgElement = d.firstChild(withTag: "img")
                                
                                let file = imgElement?.value(forAttribute: "data-orig-file") as? String
                                
                                let readContext = ReadContext()
                                
                                if let img = file{
                                    
                                    readContext.context = img
                                    readContext.contextType = .img
                                    readContext.contextTag = .thumbnail
                                    readContext.contextStyle = .normal
                                    readContext.lineNumber = (imgElement?.lineNumber)!
                                    readContexts.append(readContext)
                                }
                            }
                            
                            // 标题
                            let h1Elements = header.children(withTag: "h1")
                            
                            for (_, h1Element) in (h1Elements?.enumerated())!{
                                
                                let h1 = h1Element as! ONOXMLElement
                                
                                let readContext = ReadContext()
                                readContext.context = h1.stringValue()
                                readContext.contextType = .text
                                readContext.contextTag = .h1
                                readContext.contextStyle = .normal
                                readContext.lineNumber = h1.lineNumber
                                readContexts.append(readContext)
                            }
                            
                        }
                        
                        // 正文
                        if let d = article.firstChild(withTag: "div"){
                            // 副标题
                            let h2Elements = d.children(withTag: "h2")
                            
                            for (_, h2) in (h2Elements?.enumerated())!{
                                let h = h2 as! ONOXMLElement
                                
                                let readContext = ReadContext()
                                readContext.context = h.stringValue()
                                readContext.contextType = .text
                                readContext.contextTag = .h2
                                readContext.contextStyle = .normal
                                readContext.lineNumber = h.lineNumber
                                readContexts.append(readContext)
                            }
                            
                            let h3Elements = d.children(withTag: "h3")
                            
                            for (_, h3) in (h3Elements?.enumerated())!{
                                let h = h3 as! ONOXMLElement
                                
                                let readContext = ReadContext()
                                readContext.context = h.stringValue()
                                readContext.contextType = .text
                                readContext.contextTag = .h3
                                readContext.contextStyle = .normal
                                readContext.lineNumber = h.lineNumber
                                readContexts.append(readContext)
                            }
                            
                            let h4Elements = d.children(withTag: "h4")
                            
                            for (_, h4) in (h4Elements?.enumerated())!{
                                let h = h4 as! ONOXMLElement
                                
                                let readContext = ReadContext()
                                readContext.context = h.stringValue()
                                readContext.contextType = .text
                                readContext.contextTag = .h4
                                readContext.contextStyle = .normal
                                readContext.lineNumber = h.lineNumber
                                readContexts.append(readContext)
                            }
                            
                            let h5Elements = d.children(withTag: "h5")
                            
                            for (_, h5) in (h5Elements?.enumerated())!{
                                let h = h5 as! ONOXMLElement
                                
                                let readContext = ReadContext()
                                readContext.context = h.stringValue()
                                readContext.contextType = .text
                                readContext.contextTag = .h5
                                readContext.contextStyle = .normal
                                readContext.lineNumber = h.lineNumber
                                readContexts.append(readContext)
                            }
                            
                            // 文字
                            let pElements = d.children(withTag: "p")
                            
                            for (_, pElement) in (pElements?.enumerated())!{
                                let p = pElement as! ONOXMLElement
                                
                                let readContext = ReadContext()
                                readContext.context = p.stringValue()
                                readContext.contextType = .text
                                readContext.contextTag = .p
                                readContext.contextStyle = .normal
                                
                                let strongs = p.children(withTag: "strong")
                                
                                for (_, strong) in (strongs?.enumerated())!{
                                    let s = strong as! ONOXMLElement
                                    if s.stringValue() == readContext.context{
                                        readContext.contextStyle = .strong
                                    }
                                }
                                
                                let aHrefs = p.children(withTag: "a")
                                
                                var contexts: Array<Dictionary<String, String>> = []
                                
                                for (_,aHref) in (aHrefs?.enumerated())!{
                                    let a = aHref as! ONOXMLElement
                                    let href = a.value(forAttribute: "href") as! String
                                    let dic = ["href": href, "string": a.stringValue()]
                                    contexts.append(dic as! [String : String])
                                }
                                
                                readContext.contexts = contexts
                                readContext.lineNumber = p.lineNumber
                                readContexts.append(readContext)
                            }
                            
                            // 引用文字
                            let blockquotes = d.children(withTag: "blockquote")
                            
                            for (_, blockquote) in (blockquotes?.enumerated())!{
                                let b = blockquote as! ONOXMLElement
                                
                                let readContext = ReadContext()
                                readContext.context = b.stringValue()
                                readContext.contextType = .text
                                readContext.contextTag = .p
                                readContext.contextStyle = .blockquote
                                readContext.lineNumber = b.lineNumber
                                readContexts.append(readContext)
                            }
                            
                            // list
                            let ol = d.children(withTag: "ol")
                            
                            for (index, li) in (ol?.enumerated())!{
                                
                                let list = li as! ONOXMLElement
                                
                                let readContext = ReadContext()
                                readContext.context = list.stringValue()
                                readContext.contextType = .text
                                readContext.contextTag = .li
                                readContext.contextStyle = .normal
                                readContext.index = index + 1
                                readContext.lineNumber = list.lineNumber
                                
                                let aHrefs = list.children(withTag: "a")
                                
                                var contexts: Array<Dictionary<String, String>> = []
                                
                                for (_,aHref) in (aHrefs?.enumerated())!{
                                    let a = aHref as! ONOXMLElement
                                    let href = a.value(forAttribute: "href") as! String
                                    let dic = ["href": href, "string": a.stringValue()]
                                    contexts.append(dic as! [String : String])
                                }
                                
                                readContext.contexts = contexts
                                
                                readContexts.append(readContext)
                            }
                            
                            // 文字插图
                            let figureElements = d.children(withTag: "figure")
                            
                            for (_, f) in (figureElements?.enumerated())!{
                                let figure = f as! ONOXMLElement
                                let imgElement = figure.firstChild(withTag: "img")
                                
                                let file = imgElement?.value(forAttribute: "data-orig-file") as? String
                                
                                let readContext = ReadContext()
                                
                                if let img = file{
                                    
                                    readContext.context = img
                                    readContext.contextType = .img
                                    readContext.contextTag = .figure
                                    readContext.contextStyle = .normal
                                    readContext.lineNumber = (imgElement?.lineNumber)!
                                    readContexts.append(readContext)
                                }
                                
                                let figcaptionElement = figure.firstChild(withTag: "figcaption")
                                if let f = figcaptionElement{
                                    readContext.label = f.stringValue()
                                }
                                
                                
                            }
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                contextOnTextView()
                
            }
            
        }catch{
            
        }
    }
    
    func contextOnTextView(){
        let attriStr = NSMutableAttributedString()
        
        readContexts.sort(by: {$0.lineNumber < $1.lineNumber})
        
        for readContext in readContexts{
            
            switch readContext.contextTag {
            case .h1:
                let h1AttriStr = NSAttributedString(string: readContext.context + "\n\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 28)])
                attriStr.append(h1AttriStr)
                break
            case .h2:
                let h2AttriStr = NSAttributedString(string: readContext.context + "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 24)])
                attriStr.append(h2AttriStr)
                break
            case .h3:
                let h3AttriStr = NSAttributedString(string: readContext.context + "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20)])
                attriStr.append(h3AttriStr)
                break
            case .h4:
                break
            case .thumbnail:
                break
            case .p:
                let pAttriStr = NSAttributedString(string: readContext.context + "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
                attriStr.append(pAttriStr)
                break
            case .figure:
                break
            case .li:
                break
            default:
                break
                
            }
        }
        
        self.context_TV.attributedText = attriStr
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false;
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
