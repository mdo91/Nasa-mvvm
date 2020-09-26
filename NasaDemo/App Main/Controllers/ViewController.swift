//
//  ViewController.swift
//  NasaDemo
//
//  Created by Mdo on 24/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var roverNameLable: UILabel!
    
    @IBOutlet weak var launchDateLable: UILabel!
    
    @IBOutlet weak var LandingDateLable: UILabel!
    
    @IBOutlet weak var statusLable: UILabel!
    
    @IBOutlet weak var cameraNameLable: UILabel!
    
    @IBOutlet weak var cameraFullNameLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func UIConfig(roverInfo: VehicleInfo){
        
        roverNameLable.text = roverInfo.rover.name
        launchDateLable.text = roverInfo.rover.launch_date
        LandingDateLable.text = roverInfo.rover.landing_date
        statusLable.text = roverInfo.rover.status.rawValue
        cameraNameLable.text = roverInfo.camera.name
        cameraFullNameLable.text = roverInfo.camera.full_name
        
    }


}

