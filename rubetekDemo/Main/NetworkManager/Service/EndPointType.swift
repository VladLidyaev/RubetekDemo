//
//  EndPointType.swift
//  rubetekDemo
//
//  Created by Vlad on 07.08.2021.
//

import Foundation

public typealias HTTPHeaders = [ String : String ]

public enum returnType {
    case dictionary
    case image
}

protocol EndPointType {
    var url         : URL { get }
    var path        : String? { get }
    var method      : HTTPMethod { get }
    var task        : HTTPTask { get }
    var headers     : HTTPHeaders? { get }
    var returnType  : returnType { get }
}
