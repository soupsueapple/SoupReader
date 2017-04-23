//
//  ReadingViewController.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/13.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit
import Ono
import SafariServices

class ReadingViewController: UIViewController, UITextViewDelegate {
    let imageIdentity = "image"
    
    @IBOutlet weak var context_TV: UITextView!
    
    @IBAction func typeChange(_ sender: Any) {
    }
    var tag = TagBean()
    
    var readContexts: Array<ReadContext> = []
    
    let likeImage = UIImage(named: "like")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = tag.title
        self.context_TV.isEditable = false
        self.context_TV.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false;
        
        loadHtml(url: tag.link)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true;
    }
    
    // MARK: download image
    func downlongImage(readContext: ReadContext, index: Int) -> Void{
        let httpClient = HttpClient()
        httpClient.httpClientSetting()
        httpClient.getRequest(url: readContext.context, paramters: nil, block: {(any: Any?, error: Error?) -> Void in
            
            if httpClient.httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                return
            }
            
            let data = any as! Data
            
            
            
            let imgAttachment = NSTextAttachment()
            imgAttachment.image = UIImage(data: data)
            
            let width = (UIScreen.main.bounds.size.width - (imgAttachment.image?.size.width)! / 3) / 2
            
            imgAttachment.bounds = CGRect(x: width, y: 0, width: (imgAttachment.image?.size.width)! / 3, height: (imgAttachment.image?.size.height)! / 3)
            let attriStr = self.context_TV.attributedText.mutableCopy() as! NSMutableAttributedString
            attriStr.insert(NSAttributedString.init(attachment: imgAttachment), at: index)
            
            let label = NSAttributedString.init(string: "\n\n" + readContext.label + "\n\n")
            attriStr.insert(label, at: index + 1)
            
            self.context_TV.attributedText = attriStr
        })
    }
    
    func loadHtml(url: String){
        let httpClient = HttpClient()
        httpClient.httpClientSetting()
        httpClient.getRequest(url: url, paramters: nil, block: {(any: Any?, error: Error?) -> Void in
            
            if httpClient.httpError(error: error) {
                self.showAlert(text: error?.localizedDescription)
                return
            }
            
            let data = any as! Data
            
            self.doHtmlRequest(data: data)
        })
    }
    
    // MARK: HTMLParser
    func doHtmlRequest(data: Data) -> Void{
        
//        let data = NSData(contentsOf: URL(string: url)!)
        
        do{
            let doc = try ONOXMLDocument.htmlDocument(with: data as Data)
            
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
                                readContext.contextTag = .blockquote
                                readContext.lineNumber = b.lineNumber
                                readContexts.append(readContext)
                            }
                            
                            // list
                            let ol = d.children(withTag: "ol")
                            
                            for (_, li) in (ol?.enumerated())!{
                                
                                
                                
                                let list = li as! ONOXMLElement
                                
                                let ls = list.children(withTag: "li")
                                
                                for (index, l1) in (ls?.enumerated())!{
                                    
                                    let l = l1 as! ONOXMLElement
                                    
                                    let readContext = ReadContext()
                                    readContext.context = l.stringValue()
                                    readContext.contextType = .text
                                    readContext.contextTag = .li
                                    readContext.contextStyle = .normal
                                    readContext.index = index + 1
                                    readContext.lineNumber = l.lineNumber
                                    
                                    let aHrefs = l.children(withTag: "a")
                                    
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
                let h1AttriStr = NSAttributedString(string:readContext.context + "\n\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 28)])
                attriStr.append(h1AttriStr)
                break
            case .h2:
                let h2AttriStr = NSAttributedString(string: readContext.context + "\n\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)])
                attriStr.append(h2AttriStr)
                break
            case .h3:
                let h3AttriStr = NSAttributedString(string: readContext.context + "\n\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)])
                attriStr.append(h3AttriStr)
                break
            case .h4:
                break
            case .thumbnail:
                self.downlongImage(readContext: readContext, index: 0)
                break
            case .p:
//                var font = UIFont.systemFont(ofSize: 16)
//                if readContext.contextStyle == .strong{
//                    font = UIFont.boldSystemFont(ofSize: 16)
//                }
//                
//                let pAttriStr = NSAttributedString(string: readContext.context + "\n\n", attributes: [NSFontAttributeName: font])
//                attriStr.append(pAttriStr)
                
                self.setupTextAndLinks(readContext: readContext, attriStr: attriStr)
                break
            case .blockquote:
                let pAttriStr = NSAttributedString(string: readContext.context + "\n\n", attributes: [NSForegroundColorAttributeName: UIColor.init(hex: "#D22115"),NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
                attriStr.append(pAttriStr)
                break
            case .figure:
                self.downlongImage(readContext: readContext, index: attriStr.length)
                break
            case .li:
//                let pAttriStr = NSAttributedString(string: "\(readContext.index). "+readContext.context + "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)])
//                attriStr.append(pAttriStr)
                
                self.setupTextAndLinks(readContext: readContext, attriStr: attriStr)
                break
            default:
                break
                
            }
        }
        
        let imgAttachment = NSTextAttachment()
        imgAttachment.image = likeImage
        
        imgAttachment.bounds = CGRect(x: 0, y: 0, width: (imgAttachment.image?.size.width)! / 3, height: (imgAttachment.image?.size.height)! / 3)
        attriStr.insert(NSAttributedString.init(attachment: imgAttachment), at: attriStr.length)
        
        self.context_TV.attributedText = attriStr
    }
    
    func setupTextAndLinks(readContext: ReadContext, attriStr: NSMutableAttributedString){
        
        var font: UIFont!
        
        switch readContext.contextTag {
        case .h1:
            font = UIFont.boldSystemFont(ofSize: 28)
            break
        case .h2:
            font = UIFont.boldSystemFont(ofSize: 20)
            break
        case .h3:
            font = UIFont.boldSystemFont(ofSize: 18)
            break
        case .p:
            font = UIFont.systemFont(ofSize: 16)
            if readContext.contextStyle == .strong{
                font = UIFont.boldSystemFont(ofSize: 16)
            }
            break
        case .blockquote:
            font = UIFont.systemFont(ofSize: 16)
            break
        case .li:
            font = UIFont.systemFont(ofSize: 16)
            if readContext.contextStyle == .strong{
                font = UIFont.boldSystemFont(ofSize: 16)
            }
            break
        default:
            break
            
        }
        
        if readContext.contexts.count > 0{
            
            for dic in readContext.contexts{
                let value = dic["string"]
                
                if readContext.context.contains(value!){
                    
                    readContext.context = readContext.context.replacingOccurrences(of: value!, with: "isLink"+value!+"isLink")
                }
            }
            
            let contextStrs = readContext.context.components(separatedBy: "isLink")
            
            let count = contextStrs.count - 1
            
            for  index in 0...count {
                var str = contextStrs[index]
                
                if index == 0 && readContext.contextTag == .li {
                    str = "\(readContext.index). " + str
                }
                
                if index == count{
                    str += "\n\n"
                }
                
                for dic in readContext.contexts{
                    let value = dic["string"]
                    let href = dic["href"]
                    
                    if str.contains(value!){
                        
                        let pAttriStr = NSAttributedString(string: str, attributes: [NSForegroundColorAttributeName: UIColor.init(hex: "#007AFF"), NSFontAttributeName: font])
                        attriStr.append(pAttriStr)
                        
                        let length = attriStr.length
                        
                        attriStr.addAttribute(NSLinkAttributeName, value: URL.init(string: href!)!, range: NSRange.init(location: length - str.length, length: str.length))
                        
                        str = ""
                        
                    }
                }
                
                let pAttriStr = NSAttributedString(string: str, attributes: [NSFontAttributeName: font])
                attriStr.append(pAttriStr)
                
            }
            
        }else{
            let pAttriStr = NSAttributedString(string: readContext.context + "\n\n", attributes: [NSFontAttributeName: font])
            attriStr.append(pAttriStr)
        }
        
        
        self.context_TV.attributedText = attriStr
        
        
    }
    
    // MARK: UITextViewDelegate
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        let safariViewController = SFSafariViewController(url: URL, entersReaderIfAvailable: true)
        
        present(safariViewController, animated: true, completion: {() -> Void in
            
            
            
        })
        
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        
        if let image = textAttachment.image{
            if image == likeImage {
                
                print("likeImage")
                
            }else{
                self.performSegue(withIdentifier: imageIdentity, sender: image)
            }
        }
        
        return false
    }
    
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == imageIdentity{
            
            if let image: UIImage = sender as? UIImage{
                let imageViewController = segue.destination as! ImageViewController
                imageViewController.imgae = image
            }
            
            
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
