//
//  PlacesCellTableViewCell.swift
//  HW10
//
//  Created by Fox on 25.09.2022.
//

import UIKit

class PlacesCellTableViewCell: UITableViewCell {

    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var Detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
