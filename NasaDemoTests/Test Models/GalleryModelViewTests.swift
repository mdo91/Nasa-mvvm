//
//  GalleryModelViewTests.swift
//  NasaDemoTests
//
//  Created by Mdo on 30/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import XCTest
@testable import NasaDemo
class GalleryModelViewTests: XCTestCase {
    
    var sut: GalleryViewModel!
    
    var cameraInfo : Camera!
    var cameraInfo2: Camera!
    var imageUrl:URL!
    var imageUrl2:URL!
    var earthDate: String!
    var earthDate2:String!
    var rover:  Rover!
    var rover2: Rover!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        cameraInfo = Camera(name: "NAVCAM", full_name: "Navigation Camera")
        cameraInfo2 = Camera(name: "RHAZ", full_name: "Rear Hazard Avoidance Camera")
        earthDate = "2015-05-30"
        earthDate2 = "2015-05-30"
        imageUrl = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG")
        
        imageUrl2 = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG")
        
         rover =  Rover(name: "Curiosity", landing_date: "2012-08-06", launch_date: "2011-11-26", status: .active)
        
         rover2 = Rover(name: "Curiosity", landing_date: "2012-08-06", launch_date: "2011-11-26", status: .active)
        sut = GalleryViewModel()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_totalRoversCount_2(){
        var vehicles: [VehicleInfo] = []
        vehicles.append(VehicleInfo(img_src: imageUrl, earth_date: earthDate, camera: cameraInfo, rover: rover))
        vehicles.append(VehicleInfo(img_src: imageUrl2, earth_date: earthDate2, camera: cameraInfo2, rover: rover2))
        sut.addEntry(vehicles: vehicles)
        
        XCTAssertEqual(vehicles.count, 2)
    }
    
    

}
