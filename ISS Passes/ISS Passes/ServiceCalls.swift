//
//  ServiceCalls.swift
//  ISS Passes
//
//  Created by Jeremy Braud on 2/19/18.
//  Copyright © 2018 JPMC. All rights reserved.
//

import AFNetworking

import Foundation

class ServiceCalls {
    static var sharedInstance = ServiceCalls()
    
    // Cannot be created manually, must access through the shared instance singleton.
    private init() {
    }
    

    func getPasses(lon: String, lat: String, success: @escaping ([PassModel]) -> Void, failure: @escaping (_ dataTask: URLSessionDataTask?, _ error: Error?) -> Void) {
        let manager = AFHTTPSessionManager()
        
        manager.get(Url.getIssPasses+"lat=\(lat)&lon=\(lon)", parameters: nil, progress: nil, success: { (dataTask, responseData) in
            
            // Validate the request was successful and parse the JSON to get the array of passes.
            if let dict = responseData as? [String: Any],
                let message = dict["message"] as? String,
                message == "success",
                let response = dict["response"] as? [[String : Any]] {
                
                let passes =  response.map({ (entry) -> PassModel in
                    let pass = PassModel(dict: entry)
                    return pass
                })
                
                success(passes)
            } else {
                failure(dataTask, nil)
            }
            
        }) { (dataTask, error) in
            failure(dataTask, error)
        }
    } 
}
