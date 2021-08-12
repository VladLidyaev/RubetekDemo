//
//  RubetekObject.swift
//  rubetekDemo
//
//  Created by Vlad on 09.08.2021.
//

import Foundation
import RealmSwift

class RubetekObject : Object {
    
    static private let defaultName = "No name"
    static private let defaultRoom = "No room"
    
    @objc dynamic var id = 0
    @objc dynamic var name : String? = nil
    @objc dynamic var room : String? = nil
    @objc dynamic var snapshot : Data? = nil
    @objc dynamic var favorites : Bool = false
    
    public func customInit(id : Int, name : String?, room : String?, snapshot : String?, favorites : Bool?,completion : @escaping (Error?) -> ()) {
        self.id = id
        self.name = name ?? RubetekObject.defaultName
        self.room = room ?? RubetekObject.defaultRoom
        self.favorites = favorites ?? false
        
        if snapshot != nil {
            RubetekObject.getImageData(pathString: snapshot!) { (result) in
                switch result {
                case .success(let data):
                    self.snapshot = data
                    completion(nil)
                case . failure(let error):
                    completion(error)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    static public func toggleFavorite(id : Int, completion : @escaping (Error?) -> ()) {
        self.getObject(id: id) { (object) in
            guard object != nil else {
                completion(RealmError.objectNoExist)
                return
            }
            object!.favorites.toggle()
        }
    }
    
    static internal func getObject(id : Int, completion : @escaping (RubetekObject?) -> ()) {
        RealmManager.shared.fetch(self, id: id) { (result) in
            switch result {
            case .success(let object):
                completion(object)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    static internal func getObjects(completion : @escaping ([RubetekObject]) -> ()) {
        RealmManager.shared.fetch(self) { (arrayOfObjects) in
            completion(arrayOfObjects)
        }
    }
    
    static internal func deleteObjects(completion : @escaping (Error?) -> ()) {
        RealmManager.shared.delete(self) { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    static internal func saveObjects(objects : [RubetekObject],completion : @escaping (Error?) -> ()) {
        RealmManager.shared.save(objects) { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    static private func getImageData(pathString : String, completion : @escaping (Result<Data,Error>) -> ()) {
        NetworkManager.shared.get(.image(stringURL: pathString), returnIn: Data.self) { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
