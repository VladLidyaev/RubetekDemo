//
//  NetworkError.swift
//  rubetekDemo
//
//  Created by Vlad on 07.08.2021.
//

import Foundation

public enum NetworkError : LocalizedError {
    case nilParameters
    case encodingFailed
    case nilURL
    case failedURL
    case failedResponce
    case emptyData
    case failedDataCast
    case failedRequest
}

extension NetworkError {
    public var errorDescription: String? {
        switch self {
        case .nilParameters:
            return "Parameters is nil."
        case .encodingFailed:
            return "Perameter encoding failed."
        case .nilURL:
            return "URL is nil."
        case .failedURL:
            return "URL could not be configured."
        case .failedResponce:
            return "Responce could not be casted to HTTPURLResponse."
        case .emptyData:
            return "Empty data in responce."
        case .failedDataCast:
            return "Responce data could not be casted to your type."
        case .failedRequest:
            return "Failed request. Check status code."
        }
    }
}
