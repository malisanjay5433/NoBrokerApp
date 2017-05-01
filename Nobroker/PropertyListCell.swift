//
//  PropertyListCell.swift
//  Nobroker
//
//  Created by Sanjay Mali on 29/04/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import UIKit
class PropertyListCell: UITableViewCell {
    @IBOutlet weak var propertyTitle: UILabel!
    @IBOutlet weak var propertySecondTitle: UILabel!
    @IBOutlet weak var propertyRent: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var propertyFurnishing: UILabel!
    @IBOutlet weak var propertyBuitupArea: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var propertyImage: UIImageView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
