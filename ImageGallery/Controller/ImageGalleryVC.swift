//
//  ImageGalleryVC.swift
//  ImageGallery
//
//  Created by Farasat's_MacBook_Pro on 15/01/2024.
//

import UIKit
import SDWebImage

class ImageGalleryVC: UIViewController {

    
    @IBOutlet weak var galleryCollection: UICollectionView!
    
    var imageArray: [PixabayImage] = []
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSetup()
        initCollectionView()

        APIRequestHandler.sharedInstance().fetchImages() { [weak self] data, success in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                print("Data count: \(data?.hits.count ?? 0)")
                
                guard let hits = data?.hits, !hits.isEmpty else {
                    print("Error: Hits array is empty.")
                    return
                }

                self.imageArray = hits
                self.galleryCollection.reloadData()

                print("Success: \(success)")
            }
        }


    }
    func collectionViewSetup() {
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0.3, left: 4, bottom: 0.3, right: 4)
        
        let itemWidth = (screenWidth - 12) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        galleryCollection.collectionViewLayout = layout
    }

    private func initCollectionView() {
      let nib = UINib(nibName: "ImageViewCell", bundle: nil)
        galleryCollection.register(nib, forCellWithReuseIdentifier: "GalleryImageCell")
        galleryCollection.dataSource = self
    }

}

extension ImageGalleryVC: UICollectionViewDelegate{
    

}

extension ImageGalleryVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = galleryCollection.dequeueReusableCell(withReuseIdentifier: "GalleryImageCell", for: indexPath) as! ImageViewCell
        cell.configure(with: imageArray[indexPath.row])
        return cell
        
    }
    
}

