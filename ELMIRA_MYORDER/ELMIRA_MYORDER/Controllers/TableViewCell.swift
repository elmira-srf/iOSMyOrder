//
//  TableViewCell.swift
//  ELMIRA_MYORDER
//
//  Created by Elmira Sarrafi on 2022-05-16.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
