//
//  NetworkRouter.swift
//  rubetekDemo
//
//  Created by Vlad on 07.08.2021.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter : class {
    associatedtype EndPoint : EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint : EndPointType>: NetworkRouter {
    
    private var task : URLSessionTask?
    
    public func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        
        let session = URLSession.shared
        do {
            
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
        } catch {
            completion(nil,nil,error)
        }
        self.task?.resume()
    }
    
    public func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var url = route.url
        if route.path != nil {
            url = url.appendingPathComponent(route.path!)
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.method.rawValue
        do {
            
            switch route.task {
            case .request:
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(bodyParameters: let bodyParameters,
                                    urlParameters: let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(bodyParameters: let bodyParameters,
                                              urlParameters: let urlParameters,
                                              addtionHeaders: let additionalHeaders):
                
                self.additionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters( bodyParameters : Parameters? , urlParameters : Parameters? , request : inout URLRequest) throws {
        
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    private func additionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        
        guard let headers = additionalHeaders else { return }
        headers.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
