//
//  RubetekDoorCell.swift
//  rubetekDemo
//
//  Created by Vlad on 11.08.2021.
//

import UIKit

class RubetekDoorCell: RubetekCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        preparingUI()
    }
    
    public func customInit(_ data : DoorRubetek) {
        self.titleLabel.text = data.name!
        self.dataID = data.id
        self.titleLabel.text = data.name
        if !data.favorites {
            self.leftIcon.alpha = 0
        } else {
            self.leftIcon.alpha = 1
        }
    }
    
    private func preparingUI() {
        self.background.layer.cornerRadius = cornerRadius
        self.background.layer.shadowColor = UIColor.black.cgColor
        self.background.layer.shadowOpacity = 0.1
        self.background.layer.shadowOffset = .zero
        self.background.layer.shadowRadius = cornerRadius/6
        self.background.layer.shadowOffset = CGSize(width: 0, height: 6)
    }
}
