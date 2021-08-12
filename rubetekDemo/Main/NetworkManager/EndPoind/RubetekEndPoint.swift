//
//  RubetekEndPoint.swift
//  rubetekDemo
//
//  Created by Vlad on 08.08.2021.
//

import Foundation

public enum RubetekEndPoint {
    case doors
    case cameras
    case image(stringURL : String)
}

extension RubetekEndPoint : EndPointType {
    
    var url: URL {
        switch self {
        
        case .image(stringURL : let stringURL):
            guard let url = URL(string: stringURL) else {
                fatalError(NetworkError.failedURL.localizedDescription)
            }
            return url
            
        default:
            guard let url = URL(string: "https://cars.cprogroup.ru/api/rubetek/") else {
                fatalError(NetworkError.failedURL.localizedDescription)
            }
            return url
        }
    }
    
    var path: String? {
        switch self {
        case .doors:
            return "doors/"
        case .cameras:
            return "cameras/"
        case .image(stringURL: _):
            return nil
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var returnType: returnType {
        switch self {
        case .image(stringURL: _):
            return .image
        default:
            return .dictionary
        }
    }
}
