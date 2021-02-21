//
//  PictureChoiceShowCell.swift
//  App
//
//  Created by 张海彬 on 2021/1/21.
//

import UIKit

typealias noparameterNoreturn = () -> ()
typealias parameterNoreturn = (_ array:[UIImage]) -> ()
class PictureChoiceShowCell: UICollectionViewCell {
    
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var iconImageView: UIImageView!
    
    var deleteBlock:noparameterNoreturn?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteClick(_ sender: UIButton) {
        if let block = deleteBlock {
            block()
        }
    }
}
