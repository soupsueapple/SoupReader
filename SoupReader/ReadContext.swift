//
//  ReadContext.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/13.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit

enum ContextType {
    case img
    case text
}

enum ContextTag {
    case thumbnail
    case figure
    case h1
    case h2
    case h3
    case h4
    case h5
    case p
    case li
}

enum ContextStyle {
    case strong
    case blockquote
    case normal
}

class ReadContext: NSObject {
    var contextType: ContextType = ContextType.text
    var contextTag: ContextTag = ContextTag.p
    var contextStyle: ContextStyle = ContextStyle.normal
    var context = ""
    var contexts: Array<Dictionary<String, String>> = []
    var label = ""
    var index = 0
}
