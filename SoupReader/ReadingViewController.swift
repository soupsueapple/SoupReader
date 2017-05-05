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

class ReadingViewController: UIViewController, UITextViewDelegate, ChangeViewControllerDelegate{
    let imageIdentity = "image"
    
    @IBOutlet weak var context_TV: UITextView!
    
    var changeViewController: ChangeViewController?
    
    @IBAction func typeChange(_ sender: Any) {
        

        let blogStoryboard = UIStoryboard.init(name: "Blog", bundle: nil)
        let changeViewController = blogStoryboard.instantiateViewController(withIdentifier: "Change") as! ChangeViewController
        changeViewController.changeViewControllerDelegate = self
        changeViewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        changeViewController.modalPresentationStyle = .overCurrentContext
        changeViewController.modalTransitionStyle = .coverVertical
        self.present(changeViewController, animated: false, completion: nil)

    }
    var tag = TagBean()
    
    var readContexts: Array<ReadContext> = []
    
    let likeImage = UIImage(named: "like")!
    
    var h1_font: CGFloat = 30.0
    
    var h2_font: CGFloat = 22.0
    
    var h3_font: CGFloat = 20.0
    
    var p_font: CGFloat = 18.0
    
    var row = "\n\n"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = tag.title
        self.context_TV.isEditable = false
        self.context_TV.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false;
        
        loadHtml(url: tag.link)
        
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
            
            imgAttachment.bounds = CGRect(x: 0, y: 0, width: (imgAttachment.image?.size.width)! / 2, height: (imgAttachment.image?.size.height)! / 2)
            
            let attriStr = self.context_TV.attributedText.mutableCopy() as! NSMutableAttributedString
            attriStr.insert(NSAttributedString.init(attachment: imgAttachment), at: index)
            
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
            
            if url.contains("wordpress"){
                self.doHtmlRequest(data: data)
            }else{
                self.doHtmlRequestWithTyplog(data: data)
            }
            
        })
    }
    
    // MARK: HTMLParser
    func doHtmlRequest(data: Data) -> Void{
        
        if self.readContexts.count > 0{
            self.readContexts.removeAll()
        }
        
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
    
    func doHtmlRequestWithTyplog(data: Data) -> Void{
        
        if self.readContexts.count > 0{
            self.readContexts.removeAll()
        }
        
        do{
            let doc = try ONOXMLDocument.htmlDocument(with: data as Data)
            
            let postsParentElement: ONOXMLElement? = doc.firstChild(withXPath: "/html/body/article")
            
            if let article = postsParentElement{
                
                
                
//                let article: ONOXMLElement = element as! ONOXMLElement
                
                // 标题
                let h1Element: ONOXMLElement? = article.firstChild(withXPath: "/html/body/article/h1")
                
                if let h1 = h1Element{
                    
                    let readContext = ReadContext()
                    readContext.context = h1.stringValue()
                    readContext.contextType = .text
                    readContext.contextTag = .h1
                    readContext.contextStyle = .normal
                    readContext.lineNumber = h1.lineNumber
                    readContexts.append(readContext)
                    
                }
                // 封面
                let divs = article.children(withTag: "div")
                
                
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
                    let divs = d.children(withTag: "div")
                    for (_, div) in (divs?.enumerated())!{
                        let d = div as! ONOXMLElement
                        
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
                let h1AttriStr = NSAttributedString(string:readContext.context + self.row, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: self.h1_font)])
                attriStr.append(h1AttriStr)
                break
            case .h2:
                let h2AttriStr = NSAttributedString(string: readContext.context + self.row, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: self.h2_font)])
                attriStr.append(h2AttriStr)
                break
            case .h3:
                let h3AttriStr = NSAttributedString(string: readContext.context + self.row, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: self.h3_font)])
                attriStr.append(h3AttriStr)
                break
            case .h4:
                break
            case .thumbnail:
                let label = NSAttributedString.init(string: self.row)
                attriStr.append(label)
                self.downlongImage(readContext: readContext, index: 0)
                break
            case .p:
                self.setupTextAndLinks(readContext: readContext, attriStr: attriStr)
                break
            case .blockquote:
                let quoteStr = NSAttributedString(string: "“", attributes: [NSForegroundColorAttributeName: UIColor.init(hex: "#D22115"),NSFontAttributeName: UIFont.systemFont(ofSize: self.h1_font)])
                attriStr.append(quoteStr)
                let pAttriStr = NSAttributedString(string: readContext.context + self.row, attributes: [NSForegroundColorAttributeName: UIColor.init(hex: "#D22115"),NSFontAttributeName: UIFont.systemFont(ofSize: self.p_font)])
                attriStr.append(pAttriStr)
                break
            case .figure:
                let row = NSAttributedString.init(string: self.row)
                attriStr.append(row)
                self.downlongImage(readContext: readContext, index: attriStr.length)
                let label = NSAttributedString.init(string: readContext.label + self.row)
                attriStr.append(label)
                break
            case .li:
                self.setupTextAndLinks(readContext: readContext, attriStr: attriStr)
                break
            default:
                break
                
            }
        }
        
        self.context_TV.attributedText = attriStr
        
        
    }
    
    func setupTextAndLinks(readContext: ReadContext, attriStr: NSMutableAttributedString){
        
        var font: UIFont!
        
        switch readContext.contextTag {
        case .h1:
            font = UIFont.boldSystemFont(ofSize: self.h1_font)
            break
        case .h2:
            font = UIFont.boldSystemFont(ofSize: self.h2_font)
            break
        case .h3:
            font = UIFont.boldSystemFont(ofSize: self.h3_font)
            break
        case .p:
            font = UIFont.systemFont(ofSize: self.p_font)
            if readContext.contextStyle == .strong{
                font = UIFont.boldSystemFont(ofSize: self.p_font)
            }
            break
        case .blockquote:
            font = UIFont.systemFont(ofSize: self.p_font)
            break
        case .li:
            font = UIFont.systemFont(ofSize: self.p_font)
            if readContext.contextStyle == .strong{
                font = UIFont.boldSystemFont(ofSize: self.p_font)
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
                    str += self.row
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
            let pAttriStr = NSAttributedString(string: readContext.context + self.row, attributes: [NSFontAttributeName: font])
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
    
    // MARK: 截图
    func imageViewWithView() -> UIImage{
        let screenWindow = UIApplication.shared.keyWindow
        
        UIGraphicsBeginImageContextWithOptions((screenWindow?.frame.size)!, false, UIScreen.main.scale)
        screenWindow?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
        
        return image!
    }
    
    // MARK: ChangeViewControllerDelegate
    
    func changeTypeSizeToSmall() {
        
        if(self.p_font > 10){
            
            self.h1_font -= 2.0
            self.h2_font -= 2.0
            self.h3_font -= 2.0
            self.p_font -= 2.0
            
            contextOnTextView()
            
            
        }
    }
    
    func changeTypeSizeToBig() {
        self.h1_font += 2.0
        self.h2_font += 2.0
        self.h3_font += 2.0
        self.p_font += 2.0
        
        contextOnTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
