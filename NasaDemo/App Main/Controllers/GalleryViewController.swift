//
//  GalleryViewController.swift
//  NasaDemo
//
//  Created by Mdo on 24/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    
     static internal let reuseIdentifier = "PhotosCollectionViewCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    
}


class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, cameraSelectionProtocol {

    

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //Internal properties
    
    internal var vehiclesViewModel = GalleryViewModel()
    
    internal var networkClient = NetworkClient.shared
    var isPageRefreshing = false
    var pageIndex = 1
    var selectedRover = "Curiosity"
    var viewController: ViewController?
    var cameraName = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()


        collectionView.delegate = self
        collectionView.dataSource = self
       

        let width = view.frame.width/2
        let height = view.frame.height/3.5
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        loadVehicles(cameraName: cameraName, pageIndex: 1, selectedRover: selectedRover, completionHandler: {
            
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "updateUI"), object: nil, queue: OperationQueue.main) { (notification) in

              self.collectionView.reloadData()
              self.collectionView.refreshControl?.endRefreshing()
             
         }


    }
    
    
    //MARK: SegmentedButton Action
    
    @IBAction func segmentedButtonAction(_ sender: UISegmentedControl) {
        
        pageIndex = 1
        
        switch sender.selectedSegmentIndex {
        case 0:
             selectedRover = "Curiosity"
             
             loadVehicles(cameraName: cameraName, pageIndex: pageIndex, selectedRover: selectedRover, completionHandler: {

                
                
             })
   
        case 1:
           
            selectedRover = "Opportunity"
            loadVehicles(cameraName: cameraName, pageIndex: pageIndex, selectedRover: selectedRover, completionHandler: {
                
            })
        case 2:
           
            selectedRover = "Spirit"
            loadVehicles(cameraName: cameraName, pageIndex: pageIndex, selectedRover: selectedRover, completionHandler: {
                
                    
                }
            )
        default:
            break
        }
        
    }

    func loadVehicles(cameraName:String,pageIndex:Int, selectedRover:String, completionHandler: @escaping () -> Void)
    {
        
        collectionView.refreshControl?.beginRefreshing()
        
     //   print("cameraName \(cameraName)")
      //  print("pageIndex \(pageIndex)")
        networkClient.getRovers(roverName: selectedRover, pageIndex: pageIndex, cameraName: cameraName, sucess: { [weak self] vehicles in
             guard let strongSelf = self else{
                 return
             }
             
             if strongSelf.pageIndex != 1{

                let rovers = strongSelf.vehiclesViewModel.vehicles + vehicles
                strongSelf.vehiclesViewModel.addEntry(vehicles: rovers)
             }else{

                
                strongSelf.vehiclesViewModel.addEntry(vehicles: vehicles)
             }

             strongSelf.isPageRefreshing = false
                completionHandler()
         }) { [weak self] error in
             guard let strongSelf = self else{
                 return
             }
             strongSelf.collectionView.refreshControl?.endRefreshing()
            completionHandler()
             print("retrieving rovers failed")
         }
        
        
    }
    
    //MARK: selecting camera protocol
    func cameraSelected(cameraName: String) {
        
        
        self.cameraName = cameraName
        pageIndex = 1
        
        loadVehicles(cameraName: cameraName, pageIndex: pageIndex, selectedRover: selectedRover) {
            
        }
    }
    
    @IBAction func FilteringOptionAction(_ sender: Any) {
        
        let next = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "filterTableView") as! FilterTableViewController
             next.delegateCamera = self
//        var cameras : [String] = []
//        let roversInfo = self.vehiclesViewModel.vehicles.filter {
//
//             $0.rover.name == self.selectedRover
//
//        }
//        let cameraInfo = roversInfo.map{
//
//            $0.camera.name
//        }
//        for camera in cameraInfo{
//            
//            if cameras.contains(camera){
//                print("cameras ***** \(camera)")
//                continue
//            }
//            cameras.append(camera)
//        }
//        next.cameras = cameras
        
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    

}
