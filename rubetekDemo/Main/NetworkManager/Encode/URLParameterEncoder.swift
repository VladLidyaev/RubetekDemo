//
//  ParameterEncoder.swift
//  rubetekDemo
//
//  Created by Vlad on 07.08.2021.
//

import Foundation

public struct URLParameterEncoder : ParameterEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        guard let url = urlRequest.url else { throw NetworkError.nilURL }
        guard !parameters.isEmpty else { throw NetworkError.nilParameters }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            
            urlComponents.queryItems = []
            parameters.forEach { (key,value) in
                
                let item = URLQueryItem(name: key, value: (value as? String)?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(item)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
