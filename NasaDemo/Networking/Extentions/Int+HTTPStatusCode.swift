//
//  Int+HTTPStatusCode.swift
//  NasaDemo
//
//  Created by Mdo on 28/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

extension Int{
    public var IsSuccessHTTPCode: Bool{
        
        return 200 <= self && self < 300
    }
    
}
