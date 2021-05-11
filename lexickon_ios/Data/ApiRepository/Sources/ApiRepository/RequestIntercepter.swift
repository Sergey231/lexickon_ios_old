//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 11.05.2021.
//

import Alamofire
import Foundation
import KeychainRepository
import ConfigsRepository
import LexickonApi

class LxRequestInterceptor: RequestInterceptor {
    
    let retryLimit = 5
    let retryDelay: TimeInterval = 10
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        
        let authToken = KeychainRepository().object(forKey: .authToken)
        
        guard let strongAuthToken = authToken else {
            completion(.failure(LxHTTPObject.Error.unauthorized))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(strongAuthToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        completion(.success(urlRequest))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        let response = request.task?.response as? HTTPURLResponse
        if
            let statusCode = response?.statusCode,
            (500...599).contains(statusCode),
            request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
}
