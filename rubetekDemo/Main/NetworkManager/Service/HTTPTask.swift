//
//  HTTPTask.swift
//  rubetekDemo
//
//  Created by Vlad on 07.08.2021.
//

import Foundation

public typealias Parameters = [ String : Any ]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters : Parameters?,
                           urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters : Parameters?,
                                     urlParameters: Parameters?,
                                     addtionHeaders: HTTPHeaders?)
}
