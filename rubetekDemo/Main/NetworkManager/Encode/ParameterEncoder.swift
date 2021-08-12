//
//  ParameterEncoder.swift
//  rubetekDemo
//
//  Created by Vlad on 07.08.2021.
//

import Foundation

public protocol ParameterEncoder {
    
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
