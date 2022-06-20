//
//  DetailHeaderTCell.swift
//  Reloy InterviewTest
//
//  Created by Santhosh K on 19/06/22.
//

import UIKit

class DetailHeaderTCell: UITableViewCell,Reusable {

    @IBOutlet weak var displayImg: UIImageView!    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var resolutionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
