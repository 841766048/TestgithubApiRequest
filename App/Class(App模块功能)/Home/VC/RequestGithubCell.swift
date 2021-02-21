//
//  RequestGithubCell.swift
//  App
//
//  Created by 张海彬 on 2021/2/21.
//

import UIKit

class RequestGithubCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
