//
//  ApiCore.swift
//  GetBetter
//
//  Created by Artur Islamgulov on 30.03.2020.
//  Copyright © 2020 Artur Islamgulov. All rights reserved.
//

import Foundation
import Alamofire

class Api {
    
    func constructRequest(urlString: String,
                          method: HTTPMethod,
                          parameters: [String: String]?,
                          body: String?) -> DataRequest {
        
        let encodingUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let request = AF.request(encodingUrl,
                                 method: method,
                                 parameters: parameters,
                                 encoder: URLEncodedFormParameterEncoder.default,
                                 headers: nil,
                                 interceptor: nil)
        return request
    }
    
    func request(urlString: String,
                 method: HTTPMethod,
                 parameters: [String: String]?,
                 body: String?,
                 completion: @escaping (ResponseData) -> ()) {
        
        let request = self.constructRequest(urlString: urlString, method: method, parameters: parameters, body: body)
        
        request.responseData(completionHandler: { response in
            switch response.result {
                
            case .failure:
                completion(ResponseData(data: nil, error: AppError(errorCode: .noInternet)))
                
            case .success:
                let statusCode = response.response?.statusCode ?? 0
                print("\(urlString) has statusCode = \(statusCode)")
                
                if statusCode >= 200 && statusCode < 300,
                    let data = response.data {
                    completion(ResponseData(data: data, error: nil))
                }
                if statusCode > 301 && statusCode < 401 {
                    completion(ResponseData(data: nil, error: AppError(errorCode: .serverError)))
                }
                if statusCode == 401 {
                    completion(ResponseData(data: nil, error: AppError(errorCode: .unAuthorized)))
                }
                if statusCode > 401 && statusCode < 500 {
                    completion(ResponseData(data: nil, error: AppError(errorCode: .notFound)))
                }
            }
        })
    }
}
