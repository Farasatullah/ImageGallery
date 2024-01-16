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

    override func viewDidLoad() {
        super.viewDidLoad()
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

        initCollectionView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        

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
        
//        let cell = galleryCollection.dequeueReusableCell(withReuseIdentifier: "GalleryImageCell", for: indexPath) as! ImageViewCell
//
//        if let imageURL = URL(string: imageArray[indexPath.row].largeImageURL){
//            cell.image.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            cell.image.sd_imageIndicator?.startAnimatingIndicator()
//            cell.image.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "photo"), options: .continueInBackground, completed: nil)
//            cell.image.contentMode = .scaleToFill
//
//            cell.image.layer.cornerRadius = 20
//           } else {
//               print("Invalid URL")
//               cell.image.image = UIImage(named: "photo")
//           }
//        cell.imageName.text = imageArray[indexPath.row].user
//
          return cell
        
    }
    
}

