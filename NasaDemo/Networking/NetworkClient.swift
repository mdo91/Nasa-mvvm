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
    
    public func getRovers(roverName:String,
                          pageIndex:Int,
                          sucess _success: @escaping ([VehicleInfo]) -> Void,
                          faluire _failure: @escaping (NetworkError) -> Void)
    {
        let success: ([VehicleInfo]) -> Void = { rovers in
            
            DispatchQueue.main.async {
                _success(rovers)
            }
        }
        
        let failure: (NetworkError) -> Void = { error in
            
            DispatchQueue.main.async {
                _failure(error)
            }
            
        }
        //todo set url params

        
        let url = baseURL.appendingPathComponent("rovers/\(roverName)/photos?sol=1000&api_key=s0m3KJpvHCtD5J5pCoqD7k3YVeFIgrK0WdX9hsa8&page=\(pageIndex)").absoluteString.removingPercentEncoding
        
        print("URL: \(url ?? "not found")")
        let urlWithPath = URL(string: url!)
        let task = session.dataTask(with: urlWithPath!, completionHandler: { (data,
            response, error) in
            
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode.IsSuccessHTTPCode,
            let data = data,
            let jsonObject = try? JSONSerialization.jsonObject(with: data,options: []),
            let json = jsonObject as? [String:Any] else{
                
                    if let error = error{
                        
                        failure(NetworkError(error: error))
                    }else{
                        
                        failure(NetworkError(response: response))
                    }
                    
                    return
            }
            
            if let jsonobj = json[photosResponseEntity] as? [Any]{
                
                let dictionray = jsonobj.map{ $0 as! [String:Any] }
                
                let vehicles = VehicleInfo.array(jsonArray: dictionray)
                
//                let vehicelViewModel = vehicles.map{
//                    GalleryViewModel(vehicle: $0)
//                }
                
                success(vehicles)
                
                }else{
                
                failure(NetworkError(response: response))
                
            }
  
        })
        task.resume()
    }
}
