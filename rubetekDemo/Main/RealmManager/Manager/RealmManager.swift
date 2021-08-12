//
//  RealmManager.swift
//  rubetekDemo
//
//  Created by Vlad on 09.08.2021.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static var shared: RealmManager = {
        let manager = RealmManager()
        return manager
    }()
    
    public let backgroundQueue = DispatchQueue(label: "rubetekDemo.background", qos: .background, attributes: .concurrent)
    
    
    private init() {
        start()
    }
    
    public func save<T>(_ objects: [T], completion: @escaping (Error?) -> ()) where T : RubetekObject {
        DispatchQueue.main.async {
            do {
                let realmDataBase = try! Realm()
                try realmDataBase.safeWrite({
                    realmDataBase.add(objects)
                })
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func fetch<T>(_ model: T.Type, completion: @escaping ([T]) -> ()) where T : RubetekObject {
        DispatchQueue.main.async {
            let realmDataBase = try! Realm()
            completion(Array(realmDataBase.objects(model)))
        }
    }
    
    public func fetch<T>(_ model: T.Type, id : Int, completion: @escaping (Result<T,Error>) -> ()) where T : RubetekObject {
        DispatchQueue.main.async {
            let realmDataBase = try! Realm()
            let objectByID = realmDataBase.objects(model).filter{ $0.id == id }.first
            guard let object = objectByID else {
                completion(.failure(RealmError.objectNoExist))
                return
            }
            do {
                try realmDataBase.safeWrite({
                    completion(.success(object))
                })
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func delete<T>(_ model: T.Type, completion: @escaping (Error?) -> ()) where T : RubetekObject {
        DispatchQueue.main.async {
            let realmDataBase = try! Realm()
            let objects = realmDataBase.objects(model)
            do {
                try realmDataBase.safeWrite({
                    realmDataBase.delete(objects)
                })
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    private func start() {
        
        print("===REALM===")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {}})
        Realm.Configuration.defaultConfiguration = config
    }
}

extension RealmManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
