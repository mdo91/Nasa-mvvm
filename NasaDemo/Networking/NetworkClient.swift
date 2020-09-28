//
//  NetworkClient.swift
//  NasaDemo
//
//  Created by Mdo on 28/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import Foundation

public final class NetworkClient{
    
    
    //MAKR: - Instance Properties
    
    internal let baseURL: URL
    internal let session = URLSession.shared
    
    //MARK: - Class Constructors
    
    public static var shared: NetworkClient = {
    
        let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile:file)!
        let urlString = dictionary["service_url"] as! String
        
        let url = URL(string: urlString)!
        
       
        return  NetworkClient(baseURL:url)
    }()
    
    private init(baseURL:URL){
        
        self.baseURL = baseURL
    }
}
