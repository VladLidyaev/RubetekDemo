//
//  RubetekCell.swift
//  rubetekDemo
//
//  Created by Vlad on 11.08.2021.
//

import UIKit

class RubetekCell: UITableViewCell {
    
    public let cornerRadius : CGFloat = 10
    
    public var dataID : Int? = nil
    public var dataImage = UIImage(systemName: "questionmark.circle")
    public var dataTitle : String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .blue
    }
}
