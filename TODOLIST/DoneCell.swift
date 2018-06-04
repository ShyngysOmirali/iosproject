//
//  DoneCell.swift
//  TODOLIST
//
//  Created by Shyngys on 20.04.17.
//  Copyright © 2017 SDU. All rights reserved.
//

import UIKit

class DoneCell: UITableViewCell {

    @IBOutlet weak var roundView: UIView!
    
    @IBOutlet weak var label: UILabel!    
    @IBOutlet weak var deleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
