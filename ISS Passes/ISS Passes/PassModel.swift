//
//  PassModel.swift
//  ISS Passes
//
//  Created by Jeremy Braud on 2/19/18.
//  Copyright © 2018 JPMC. All rights reserved.
//

import Foundation

import UIKit

class PassModel: NSObject {
    
    var duration : Int!
    
    var risetime : String!
    
    init(dict : [String : Any]) {
        if let duration = dict["duration"] as? Int{
            self.duration = duration
        }
        
        if let riseTime = dict["risetime"] as? Double{
            // Convert UNIX timestamp to human readable.
            let date = NSDate(timeIntervalSince1970: riseTime)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .medium
            dateFormatter.dateStyle = .medium
            let localDate = dateFormatter.string(from: date as Date)
            
            self.risetime = localDate
        }
    }
}
