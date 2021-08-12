//
//  DoorRubetek.swift
//  rubetekDemo
//
//  Created by Vlad on 09.08.2021.
//

import Foundation

class DoorRubetek: RubetekObject {
    
    static public func setNewName(id : Int, newName : String, completion : @escaping (Error?) -> ()) {
        self.getObject(id: id) { (object) in
            guard object != nil else {
                completion(RealmError.objectNoExist)
                return
            }
            object!.name = newName
        }
    }
    
    static public func get(completion : @escaping (Result<[DoorRubetek]?,Error>) -> ()) {
        
        RealmManager.shared.backgroundQueue.async {
            DoorRubetek.getObjects { (objects) in
                
                guard objects.isEmpty else {
                    guard let objects = (objects as? [DoorRubetek]) else {
                        completion(.failure(RealmError.failedCast))
                        return
                    }
                    completion(.success(objects))
                    return
                }
                
                DoorRubetek.update { (result) in
                    switch result {
                    case .success(let objects):
                        completion(.success(objects))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    static public func update(completion : @escaping (Result<[DoorRubetek],Error>) -> ()) {
        
        RealmManager.shared.backgroundQueue.async {
            NetworkManager.shared.get(.doors, returnIn: doorListCodable.self) { (result) in
                switch result {
                
                case .success(let data):
                    
                    guard let array = data.data else {
                        completion(.failure(NetworkError.emptyData))
                        return
                    }
                    
                    var doorRubetekArray = [DoorRubetek]()
                    let group = DispatchGroup()
                    array.forEach { (doorCodable) in
                        
                        group.enter()
                        let element = DoorRubetek()
                        element.customInit(id: doorCodable.id, name: doorCodable.name, room: doorCodable.room, snapshot: doorCodable.snapshot, favorites: doorCodable.favorites) { (error) in
                            
                            doorRubetekArray.append(element)
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: RealmManager.shared.backgroundQueue) {
                        DoorRubetek.deleteObjects { (error) in
                            
                            guard error == nil else {
                                completion(.failure(error!))
                                return
                            }
                            
                            DoorRubetek.saveObjects(objects: doorRubetekArray) { (error) in
                                guard error == nil else {
                                    completion(.failure(error!))
                                    return
                                }
                                completion(.success(doorRubetekArray))
                            }
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
