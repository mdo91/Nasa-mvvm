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


class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //Internal properties
    
    internal var vehiclesViewModel = GalleryViewModel()
    
    internal var networkClient = NetworkClient.shared
    var isPageRefreshing = false
    var pageIndex = 1
    var selectedRover = "curiosity"
    var viewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()


        collectionView.delegate = self
        collectionView.dataSource = self

        let width = view.frame.width/2
        let height = view.frame.height/3.5
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        loadVehicles(pageIndex: 1, selectedRover: selectedRover, completionHandler: {
            
        })
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "updateUI"), object: nil, queue: OperationQueue.main) { (notification) in

              self.collectionView.reloadData()
              self.collectionView.refreshControl?.endRefreshing()
             
         }


    }
    
    
    //MARK: SegmentedButton Action
    
    @IBAction func segmentedButtonAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
             selectedRover = "Curiosity"
             
             loadVehicles(pageIndex: 1, selectedRover: selectedRover, completionHandler: {
                
//                let cameras = self.vehiclesViewModel.map{
//
//                    $0.getCamera(by: self.selectedRover)
//                }
//                print("cameras: \(cameras)")
                
                
             })
   
        case 1:
            selectedRover = "Opportunity"
            loadVehicles(pageIndex: 1, selectedRover: selectedRover, completionHandler: {
                
            })
        case 2:
            selectedRover = "Spirit"
            loadVehicles(pageIndex: 1, selectedRover: selectedRover, completionHandler: {
                
                    
                }
            )
        default:
            break
        }
        
    }

    func loadVehicles(pageIndex:Int, selectedRover:String, completionHandler: @escaping () -> Void)
    {
        
        collectionView.refreshControl?.beginRefreshing()
             networkClient.getRovers(roverName: selectedRover, pageIndex: pageIndex, sucess: { [weak self] vehicles in
             guard let strongSelf = self else{
                 return
             }
             
             if strongSelf.pageIndex != 1{
                 
               // strongSelf.vehiclesViewModel.vehicles += vehicles
                let rovers = strongSelf.vehiclesViewModel.vehicles + vehicles
                strongSelf.vehiclesViewModel.addEntry(vehicles: rovers)
             }else{
          
               // strongSelf.vehiclesViewModel.vehicles = vehicles
                strongSelf.vehiclesViewModel.addEntry(vehicles: vehicles)
             }
             
    //         strongSelf.collectionView.refreshControl?.endRefreshing()
             
 //            strongSelf.collectionView.reloadData()
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
    
    @IBAction func FilteringOptionAction(_ sender: Any) {
        
        let next = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "filterTableView") as! FilterTableViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    

}
