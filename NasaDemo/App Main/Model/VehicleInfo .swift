//
//  VehicleInfo .swift
//  NasaDemo
//
//  Created by Mdo on 24/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import Foundation

public final class VehicleInfo{
    
    var img_src : URL?
    var earth_date: String
    var camera : Camera
    var rover: Rover
    
    internal struct Keys{
        static let photos = "photos"
        static let img_src = "img_src"
        static let earth_date = "earth_date"
        static let camera = "camera"
        static let camera_name = "name"
        static let camera_full_name = "full_name"
        static let rover = "rover"
        static let rover_name = "name"
        static let rover_landing_date = "landing_date"
        static let rover_launch_date = "launch_date"
        static let rover_status = "status"
        
    }
    

    

    
    init(img_src: URL?, earth_date: String, camera: Camera,rover:Rover  ) {
        self.img_src = img_src
        self.camera = camera
        self.rover = rover
        self.earth_date = earth_date
    }
    
    public init?(json: [String:Any]){
        print("json \(json)")
 
        let imageURL1: URL?
        
        if let imageURLString = json[Keys.img_src] as? String{
            imageURL1 = URL(string: imageURLString)
           //  print("Error Parsing imageURL1")
        }else{
            imageURL1 = nil
            print("Error Parsing imageURL1 \( String(describing: json[Keys.img_src]))")
        }
        
       
        guard let earth_date = json[Keys.earth_date] as? String,let jsonCamera = json[Keys.camera] as? [String:Any], let jsonRover = json[Keys.rover] as? [String:Any] else{
    //         print("Error Parsing earth_date \(json[Keys.earth_date])")
            return nil
        }
        
        self.img_src = imageURL1
        self.earth_date = earth_date
        
        guard let camera_name = jsonCamera[Keys.camera_name] as? String, let camera_full_name = jsonCamera[Keys.camera_full_name] as? String else{
            
            return nil
        }
        
        self.camera = Camera(name: camera_name, full_name: camera_full_name)
        
        guard let rover_name = jsonRover[Keys.rover_name] as? String, let rover_landing_date = jsonRover[Keys.rover_landing_date] as? String, let rover_launch_date = jsonRover[Keys.rover_launch_date] as? String, let roverStatus = jsonRover[Keys.rover_status] as? String else{
            return nil
            
        }
        
        self.rover = Rover(name: rover_name, landing_date: rover_landing_date, launch_date: rover_launch_date, status: Status(rawValue: roverStatus)!)
        
     }
    
    public class func array(jsonArray: [[String:Any]])-> [VehicleInfo]{

        var array : [VehicleInfo] = []

        for json in jsonArray{
            
            //print("json \(json)")

            guard let vehicle = VehicleInfo(json:json ) else{ continue}
            array.append(vehicle)

        }
        
        return array
    }
    
//    public class func getCamerasByRover(name: String, rover array : [VehicleInfo] ) -> [Camera]{
//
//        var cameraArray : [Camera] = []
//
//        let filetrByCamera = array.filter { $0.rover.name ==  name }
//
//        let cameraResult = filetrByCamera.map { $0.camera
//        }
//        cameraArray = cameraResult
//        return cameraArray
//        }
    
    public class func getRover( by name: String, array: [VehicleInfo] ) -> [VehicleInfo]{

        var roverArray : [VehicleInfo] = []
        
     //   print("getRover.count \(array.count)")
        

        let filetrByName = array.filter { print("\($0.rover.name)")
            return $0.rover.name == name
            
           // print("\($0.rover.name)")
        }

        roverArray = filetrByName
        return roverArray
        }

    }
    
 
    

