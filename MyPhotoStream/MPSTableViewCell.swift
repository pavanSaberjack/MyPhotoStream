//
//  MPSTableViewCell.swift
//  MyPhotoStream
//
//  Created by Pavan on 06/05/17.
//  Copyright © 2017 Pavan. All rights reserved.
//

import UIKit

class MPSTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
