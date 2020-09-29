//
//  Rover.swift
//  NasaDemo
//
//  Created by Mdo on 24/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import Foundation

public enum Status: String{
    
    case active
    case inactive
    case complete
}





struct Rover {
    
    var name: String
    var landing_date: String
    var launch_date: String
    var status : Status
    
    init(name:String,landing_date: String,launch_date: String, status: Status  ) {
        self.name = name
        self.launch_date = launch_date
        self.landing_date = landing_date
        self.status = status
        
    }
    
}
