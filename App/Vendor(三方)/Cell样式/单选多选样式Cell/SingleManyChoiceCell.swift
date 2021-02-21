//
//  SingleManyChoiceCell.swift
//  App
//
//  Created by 张海彬 on 2021/1/21.
//

import UIKit

class SingleManyChoiceCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            iconImageView.image = UIImage(named: "selectCircle")
        }else{
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseInOut, animations: { [weak self] in
                if let img = self?.iconImageView {
                    img.image =  UIImage(named: "circle_icon")
                }
            })
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected) {
            iconImageView.image = UIImage(named: "selectCircle")
        } else {
            iconImageView.image =  UIImage(named: "circle_icon")
        }
    }
    
}
