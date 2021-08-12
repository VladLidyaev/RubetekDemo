//
//  Configurates.swift
//  rubetekDemo
//
//  Created by Vlad on 09.08.2021.
//

import Foundation
import UIKit

enum menuPages : String, CaseIterable {
    case cameras = "Камеры"
    case doors = "Двери"
}

final class Configurates {
    
    static let defaultImage = UIImage(systemName: "star")
    static let rubetekCameraCellID = "RubetekCameraCell"
    static let rubetekDoorCellID = "RubetekDoorCell"
    static let rubetekTableViewHeaderID = "RubetekTableViewHeader"
    
    static let likeActionImage = UIImage(systemName: "star")
    static let editActionImage = UIImage(systemName: "square.and.pencil")
    
    static let backgroundColor : UIColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    static let cleanWhiteColor : UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let DetailsColor : UIColor = #colorLiteral(red: 0.01176470588, green: 0.662745098, blue: 0.9568627451, alpha: 1)
    static let TextColor : UIColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
}
