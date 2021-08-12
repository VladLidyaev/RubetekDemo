//
//  cameraDecodable.swift
//  rubetekDemo
//
//  Created by Vlad on 09.08.2021.
//

import Foundation

struct camerasListCodable : Decodable {
    let success : Bool?
    let data : camerasInfoCodable?
}

struct camerasInfoCodable : Decodable {
    let room : [String]?
    let cameras : [cameraCodable]?
}

struct cameraCodable : Decodable {
    let name : String?
    let snapshot : String?
    let room : String?
    let id : Int
    let favorites : Bool?
    let rec : Bool?
}
