//
//  GalleryViewControllerExtension.swift
//  NasaDemo
//
//  Created by Mdo on 29/09/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import Foundation
import UIKit
extension GalleryViewController{
    
    
    // MARK: UICollectionViewDataSource
    
       func numberOfSections(in collectionView: UICollectionView) -> Int {
          // #warning Incomplete implementation, return the number of sections
          return 1
      }


       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          // #warning Incomplete implementation, return the number of items
        return vehiclesViewModel.vehicles.count
          
      }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        let cellId = "\(GalleryCollectionViewCell.reuseIdentifier)"
          
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId  , for: indexPath) as! GalleryCollectionViewCell
      
          // Configure the cell
          
                DispatchQueue.global().async {

                    if  let url = self.vehiclesViewModel.vehicles[indexPath.row].img_src, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {

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
        self.viewController?.UIConfig(roverInfo: self.vehiclesViewModel.vehicles[indexPath.row])

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
            if self.vehiclesViewModel.vehicles.count < 25{
                  
              }else{
                loadVehicles(cameraName: cameraName, pageIndex: pageIndex, selectedRover: selectedRover, completionHandler: {
                      
                  })
              }
              
                  isPageRefreshing = true
              
              print("fetch new results")
          }
      }
      }

}

