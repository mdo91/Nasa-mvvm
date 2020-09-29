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
    
     static fileprivate let reuseIdentifier = "PhotosCollectionViewCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    
    
}


class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //Internal properties
    
    internal var vehicles : [VehicleInfo] = []
    internal var session = URLSession.shared
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


    }
    
    
    //MARK: SegmentedButton Action
    
    @IBAction func segmentedButtonAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
             selectedRover = "Curiosity"
             
             loadVehicles(pageIndex: 1, selectedRover: selectedRover, completionHandler: {
                let roverArray = VehicleInfo.getRover(by: self.selectedRover, array: self.vehicles)
                let cameraArray = roverArray.map {
                   $0.camera
                }
                print("available cameras \(cameraArray.count)")
                
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
             networkClient.getRovers(roverName: selectedRover, pageIndex: 1, sucess: { [weak self] vehicles in
             guard let strongSelf = self else{
                 return
             }
             
             if strongSelf.pageIndex != 1{
                 
                 strongSelf.vehicles += vehicles
             }else{
          
                 strongSelf.vehicles = vehicles
             }
             
             strongSelf.collectionView.refreshControl?.endRefreshing()
             
             strongSelf.collectionView.reloadData()
             strongSelf.isPageRefreshing = false
                completionHandler()
         }) { [weak self] error in
             guard let strongSelf = self else{
                 return
             }
             strongSelf.collectionView.refreshControl?.endRefreshing()
            completionHandler()
             print("retrieving rovers faild")
         }
        
        
    }
    
    
    // MARK: UICollectionViewDataSource
  
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return vehicles.count
        
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
    
        // Configure the cell
        
              DispatchQueue.global().async {

                  if  let url = self.vehicles[indexPath.row].img_src, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {

                      DispatchQueue.main.async {
                          cell.imageView.image = image
                          
                      }
                  }

              }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.viewController = self.storyboard?.instantiateViewController(withIdentifier: "PopoverViewController") as? ViewController

       //GalleryCollectionViewCell

        self.viewController!.modalPresentationStyle = .popover
        
        let popover = self.viewController!.popoverPresentationController
        
        let cell = self.collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        let _ = viewController?.view
        
        self.viewController?.imageView.image = cell.imageView.image
        self.viewController?.UIConfig(roverInfo: self.vehicles[indexPath.row])

        popover?.passthroughViews = [self.view]
        popover?.sourceRect = CGRect(x: 250, y: 500, width: 0, height: 0)
        self.viewController!.preferredContentSize = CGSize(width: 250, height: 419)

                 popover!.sourceView = self.view

        self.present(self.viewController!, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("scrollViewDidScroll")
        if !isPageRefreshing {
        if self.collectionView.contentOffset.y >= self.collectionView.contentSize.height - self.collectionView.bounds.size.height {
            
                
                pageIndex += 1
                // call API
                // set to true
                print("Fetching...")
            if self.vehicles.count < 25{
                
            }else{
                loadVehicles(pageIndex: pageIndex, selectedRover: selectedRover, completionHandler: {
                    
                })
            }
            
                isPageRefreshing = true
            
            print("fetch new results")
        }
    }
    }

}
