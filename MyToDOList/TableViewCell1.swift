//
//  TableViewCell1.swift
//  MyToDOList
//
//  Created by Matthew Ashley on 9/16/16.
//  Copyright © 2016 Matthew Ashley. All rights reserved.
//

import UIKit

class TableViewCell1: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDesc: UILabel!
    @IBOutlet weak var cellGroup: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
