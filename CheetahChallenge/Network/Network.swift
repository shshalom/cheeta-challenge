//
//  Network.swift
//  CheetahChallenge
//
//  Created by Shalom Shwaitzer on 29/01/2020.
//  Copyright © 2020 Shalom Shwaitzer. All rights reserved.
//

import Foundation
public protocol Networking: class {
    func request<ResponseType: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<ResponseType, Error>) -> Void) -> Cancellable?
}

public class Network: NSObject, Networking {
    
    let environment: Environment
    
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        
        return URLSession(configuration: configuration)
    }()
    
    public required init(environment: Environment) {
        self.environment = environment
    }
    
    public func request<ResponseType: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<ResponseType, Error>) -> Void) -> Cancellable? {
        
        let endpoint = endpoint.set(environment: self.environment)
        
        guard let urlComponents = URLComponents(url: endpoint.url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return nil
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return nil
        }
        
        let cancellableRequest =  self.urlSession.dataTask(with: url ) { result in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try Utils.jsonDecoder.decode(ResponseType.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure:
                completion(.failure(.apiError))
            }
        }
        
        cancellableRequest.resume()
        
        return cancellableRequest
    }
}
