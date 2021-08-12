//
//  CameraRubetek.swift
//  rubetekDemo
//
//  Created by Vlad on 09.08.2021.
//

import Foundation

class CameraRubetek: RubetekObject {
    
    @objc dynamic var rec : Bool = false
    
    private func customInit(id: Int, name: String?, room: String?, snapshot: String?, favorites: Bool?, rec: Bool? , completion: @escaping (Error?) -> ()) {
        self.customInit(id: id, name: name, room: room, snapshot: snapshot, favorites: favorites) { (error) in
            guard error == nil else {
                completion(error!)
                return
            }
            self.rec = rec ?? false
            completion(nil)
        }
    }
    
    static public func get(completion : @escaping (Result<[CameraRubetek]?,Error>) -> ()) {
        
        RealmManager.shared.backgroundQueue.async {
            CameraRubetek.getObjects { (objects) in
                
                guard objects.isEmpty else {
                    guard let objects = (objects as? [CameraRubetek]) else {
                        completion(.failure(RealmError.failedCast))
                        return
                    }
                    completion(.success(objects))
                    return
                }
                
                CameraRubetek.update { (result) in
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
    
    static public func update(completion : @escaping (Result<[CameraRubetek],Error>) -> ()) {
        
        RealmManager.shared.backgroundQueue.async {
            NetworkManager.shared.get(.cameras, returnIn: camerasListCodable.self) { (result) in
                switch result {
                
                case .success(let data):
                    
                    guard let array = data.data?.cameras else {
                        completion(.failure(NetworkError.emptyData))
                        return
                    }
                    
                    var cameraRubetekArray = [CameraRubetek]()
                    let group = DispatchGroup()
                    array.forEach { (cameraCodable) in
                        
                        group.enter()
                        let element = CameraRubetek()
                        element.customInit(id: cameraCodable.id, name: cameraCodable.name, room: cameraCodable.room, snapshot: cameraCodable.snapshot, favorites: cameraCodable.favorites, rec: cameraCodable.rec) { (error) in
                            
                            cameraRubetekArray.append(element)
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: RealmManager.shared.backgroundQueue) {
                        CameraRubetek.deleteObjects { (error) in
                            
                            guard error == nil else {
                                completion(.failure(error!))
                                return
                            }
                            
                            CameraRubetek.saveObjects(objects: cameraRubetekArray) { (error) in
                                guard error == nil else {
                                    completion(.failure(error!))
                                    return
                                }
                                completion(.success(cameraRubetekArray))
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
