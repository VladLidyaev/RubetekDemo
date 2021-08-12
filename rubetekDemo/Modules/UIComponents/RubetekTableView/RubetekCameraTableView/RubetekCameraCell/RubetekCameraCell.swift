//
//  RubetekCameraCell.swift
//  rubetekDemo
//
//  Created by Vlad on 11.08.2021.
//

import UIKit

class RubetekCameraCell: RubetekCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var bacakgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        preparingUI()
    }
    
    public func customInit(_ data : CameraRubetek) {
        
        if data.snapshot != nil {
            guard UIImage(data: data.snapshot!) != nil else {
                return
            }
            self.dataImage = UIImage(data: data.snapshot!)
        }
        
        self.mainImageView.image = self.dataImage
        self.dataID = data.id
        self.titleLabel.text = data.name
        if !data.favorites {
            self.leftIcon.alpha = 0
        } else {
            self.leftIcon.alpha = 1
        }
    }
    
    public func customInit(_ data : DoorRubetek) {
        
        if data.snapshot != nil {
            guard UIImage(data: data.snapshot!) != nil else {
                return
            }
            self.dataImage = UIImage(data: data.snapshot!)
        }
        
        self.mainImageView.image = self.dataImage
        self.dataID = data.id
        self.titleLabel.text = data.name
        if !data.favorites {
            self.leftIcon.alpha = 0
        } else {
            self.leftIcon.alpha = 1
        }
    }
    
    private func preparingUI() {
        self.bacakgroundView.layer.cornerRadius = cornerRadius
        self.mainImageView.layer.cornerRadius = cornerRadius
        self.mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.bacakgroundView.layer.shadowColor = UIColor.black.cgColor
        self.bacakgroundView.layer.shadowOpacity = 0.1
        self.bacakgroundView.layer.shadowOffset = .zero
        self.bacakgroundView.layer.shadowRadius = cornerRadius/6
        self.bacakgroundView.layer.shadowOffset = CGSize(width: 0, height: 6)
    }
}
