//
//  NetworkManager.swift
//  rubetekDemo
//
//  Created by Vlad on 08.08.2021.
//

import Foundation

class NetworkManager {
    
    static var shared: NetworkManager = {
        let manager = NetworkManager()
        return manager
    }()
    
    private init() {}
    
    public func get<T : Decodable>(_ endPoint : RubetekEndPoint, returnIn: T.Type, completion : @escaping (Result<T, Error>) -> ()) {
        
        let router = Router<RubetekEndPoint>()
        router.request(endPoint) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let responce = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.failedResponce))
                return
            }
            
            switch self.handleNetworkResponce(responce) {
            case .success(()):
                
                guard let data = data else {
                    completion(.failure(NetworkError.emptyData))
                    return
                }
                
                do {
                    switch endPoint.returnType {
                    
                    case .dictionary:
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(result))
                        return
                        
                    case .image:
                        let result = data as? T
                        guard result != nil else {
                            completion(.failure(NetworkError.failedDataCast))
                            return
                        }
                        completion(.success(result!))
                        return
                    }
                    
                } catch {
                    completion(.failure(error))
                    return
                }
                
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    private func handleNetworkResponce(_ responce : HTTPURLResponse) -> (Result<Void,Error>) {
        let statusCode = responce.statusCode
        switch statusCode {
        case 200...299:
            return .success(())
        default:
            print(statusCode)
            return .failure(NetworkError.failedRequest)
        }
    }
}

extension NetworkManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
