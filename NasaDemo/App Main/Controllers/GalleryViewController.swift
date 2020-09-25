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
    var isPageRefreshing = false
    var pageIndex = 1
    var selectedRover = "curiosity"
    
    override func viewDidLoad() {
        super.viewDidLoad()


        collectionView.delegate = self
        collectionView.dataSource = self

        let width = view.frame.width/2
        let height = view.frame.height/3.5
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        loadVehicles(pageIndex: 1, selectedRover: selectedRover)

    }
    
    
    //MARK: SegmentedButton Action
    
    @IBAction func segmentedButtonAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
             selectedRover = "Curiosity"
            loadVehicles(pageIndex: 1, selectedRover: selectedRover)
        case 1:
            selectedRover = "Opportunity"
            loadVehicles(pageIndex: 1, selectedRover: selectedRover)
        case 2:
            selectedRover = "Spirit"
            loadVehicles(pageIndex: 1, selectedRover: selectedRover)
        default:
            break
        }
        
    }
    
    
    
    
    func loadVehicles(pageIndex:Int, selectedRover:String){
        
        collectionView.refreshControl?.beginRefreshing()
       // isPageRefreshing = true
        let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(selectedRover)/photos?sol=1000&api_key=s0m3KJpvHCtD5J5pCoqD7k3YVeFIgrK0WdX9hsa8&page=\(pageIndex)")!
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error{
                
                print("Photos download failed \(error)")
                return
            }
            
            guard let data = data else{
                print("Photos download failed: data is nil!")
                return
                
            }
            
            let jsonArray: [String:Any]
            
            do{
                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options:[]) as? [String:Any] else{
                    
                    print("Photos download failed: invalid JSON \(data)")
                    return
                }
                if let jsonobj = jsonObject["photos"] as? [Any]{
                    
                 
                    let dictionray = jsonobj.map{ $0 as! [String:Any] }

   
                    let vehicles = VehicleInfo.array(jsonArray: dictionray)
                    
                    DispatchQueue.main.async { [weak self] in
                        
                        guard let selfStrong = self else{
                            
                          print("nil class object ")
                            return
                        }
                        
                        if pageIndex != 1{
                            
                        selfStrong.vehicles += vehicles
                        }else{
                            
                            selfStrong.vehicles = vehicles
                        }
                        
                        selfStrong.collectionView.refreshControl?.endRefreshing()
                        
                        selfStrong.collectionView.reloadData()
                        selfStrong.isPageRefreshing = false
                        
                    }
                    
                }else{
                    
                    
                    
                    print("Photos download failed: invalid JSON")
                }

                jsonArray = jsonObject
            }catch{
                
                print("Photos download failed: invalid JSON")
                return
       
            }
 

            
        }
        task.resume()
        
        
        
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
                loadVehicles(pageIndex: pageIndex, selectedRover: selectedRover)
            }
            
                isPageRefreshing = true
            
            print("fetch new results")
        }
    }
    }

}
