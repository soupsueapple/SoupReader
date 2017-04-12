//
//  BlogMainTableViewCell.swift
//  SoupReader
//
//  Created by 汤坤 on 2017/4/12.
//  Copyright © 2017年 汤坤. All rights reserved.
//

import UIKit

class BlogMainTableViewCell: UITableViewCell {

    @IBOutlet weak var title_lb: UILabel!
    @IBOutlet weak var digest_lb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
