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
    
     var vehicle : VehicleInfo { get }
}


public class GalleryViewModel: GallaryViewModelProtocol {

    
    public let vehicle: VehicleInfo

    
    public init(vehicle:VehicleInfo){
        
        self.vehicle = vehicle

    }
    
    func getCamera(by name: String) -> Camera{
        
        if self.vehicle.rover.name == name{
            return vehicle.camera
        }
        
        return Camera(name: "", full_name: "")
    }

}
