//
//  RoverTestModels.swift
//  NasaDemoTests
//
//  Created by Mdo on 30/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import XCTest
@testable import NasaDemo
class RoverTestModels: XCTestCase {
    
    var sut:VehicleInfo!
    var cameraInfo : Camera!
    let imageUrl = URL(string: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG")
    
    let rover =  Rover(name: "Curiosity", landing_date: "2012-08-06", launch_date: "2011-11-26", status: .active)
    let rover2 = Rover(name: "Curiosity", landing_date: "2012-08-06", launch_date: "2011-11-26", status: .active)
    
  

    override func setUpWithError() throws {
        
          let cameraInfo = Camera(name: "RHAZ", full_name: "Rear Hazard Avoidance Camera")
         // let vehicle = VehicleInfo(img_src: imageUrl, earth_date: "2015-05-30", camera: cameraInfo, rover: rover)
        
        sut = VehicleInfo(img_src: imageUrl, earth_date: "2015-05-30", camera: cameraInfo, rover: rover)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testInit_VehicleWithInfo(){
        

        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.camera.full_name, "Rear Hazard Avoidance Camera")
        XCTAssertEqual(sut.camera.name, "RHAZ")
        XCTAssertEqual(sut.img_src?.absoluteString, "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG")
        
        XCTAssertEqual(sut.rover, rover2)
    }
    
    func test_ReturnFalseForDifferentRoversName(){
        
        let rover =  Rover(name: "Curiosity", landing_date: "2012-08-06", launch_date: "2011-11-26", status: .active)
        let rover2 = Rover(name: "Spirit", landing_date: "2012-08-06", launch_date: "2011-11-26", status: .active)
        
        XCTAssertNotEqual(rover, rover2)
   
    }
    
    func test_RetrunsTrue_EarthDate(){
        
        XCTAssertEqual(sut.earth_date, "2015-05-30")
        
    }
    
    


}
