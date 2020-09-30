//
//  GalleryViewModel.swift
//  NasaDemo
//
//  Created by Mdo on 29/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import Foundation

typealias BlockVoid = () -> Void
typealias blockWithRovers = ([VehicleInfo]) -> Void

protocol GallaryViewModelProtocol {
    
     var vehicles : [VehicleInfo] { get }
}


public class GalleryViewModel: GallaryViewModelProtocol {

    
    public var vehicles: [VehicleInfo] = []
    
    fileprivate var observer = Observable<[VehicleInfo]>([])
    
    func addEntry(vehicles: [VehicleInfo]){
        
        observer.bind = { _ in
            
            NotificationCenter.default.post(Notification(name: Notification.Name("updateUI")))
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() ) {
            
            self.observer.value = vehicles
            self.vehicles = vehicles
        }

       // let roverObservable =
    }
    

    
    
     subscript(at index:Int) -> VehicleInfo{
        
        return vehicles[index]
    }
    
    

    
//    public init(vehicle:VehicleInfo){
//
//        self.vehicle = vehicle
//
//    }
    
//    func getCamera(by name: String) -> [Camera]{
//
//
//        let cameras =
//
//        if self.vehicle.rover.name == name{
//            return vehicle.camera
//        }
//        
//        return Camera(name: "", full_name: "")
//    }

}
