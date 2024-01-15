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

        APIRequestHandler.sharedInstance().fetchImages() { [self] data, success in
            print("Data count: \(data.count)")
            
            guard !data.isEmpty else {
                print("Error: Data cannot be empty.")
                return
                
            }

            
            for pixaBay in data {
                

                for pixabayImageInfo in pixaBay.hits {
                    print("Image URL : \(pixabayImageInfo.imageURL)")
                    print("Image id : \(pixabayImageInfo.id)")
                    self.imageArray.append(pixabayImageInfo)

                }
                print("No of total: \(pixaBay.total)")
                print("No of total tohits: \(pixaBay.totalHits)")

            }
                       print("Success: \(success)")
//            imageArray = data
                       // Use 'data' here as needed in your app
                   }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        initCollectionView()

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
        
        if let imageURL = URL(string: imageArray[indexPath.row].imageURL){
            cell.image.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.image.sd_imageIndicator?.startAnimatingIndicator()
            cell.image.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "photo"), options: .continueInBackground, completed: nil)
            cell.image.contentMode = .scaleToFill
            cell.image.layer.cornerRadius = cell.image.frame.height/2
           } else {
               print("Invalid URL")
               cell.image.image = UIImage(named: "photo")
           }
        cell.imageName.text = imageArray[indexPath.row].user

          return cell
        
    }
    
}
extension ImageGalleryVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (galleryCollection.frame.size.width-10)/2
        return CGSize(width: size, height: size)
    }

}
