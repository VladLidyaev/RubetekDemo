//
//  RealmError.swift
//  rubetekDemo
//
//  Created by Vlad on 09.08.2021.
//

import Foundation

public enum RealmError : LocalizedError {
    case objectNoExist
    case failedCast
}

extension RealmError {
    public var errorDescription: String? {
        switch self {
        case .objectNoExist:
            return "Object with this ID doesn't exist."
        case .failedCast:
            return "RubetekObject could not be casted to your subclass."
        }
    }
}
