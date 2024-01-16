//
//  ImageViewCell.swift
//  ImageGallery
//
//  Created by Farasat's_MacBook_Pro on 16/01/2024.
//

import UIKit
import SDWebImage

class ImageViewCell: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with imageInfo: PixabayImage) {
        if let imageURL = URL(string: imageInfo.largeImageURL) {
                image.sd_imageIndicator = SDWebImageActivityIndicator.gray
                image.sd_imageIndicator?.startAnimatingIndicator()
            let sfSymbolImage = UIImage(systemName: "photo")
                image.sd_setImage(with: imageURL, placeholderImage: sfSymbolImage, options: .continueInBackground, completed: nil)
                image.contentMode = .scaleAspectFit
                image.layer.cornerRadius = 20

            } else {
                print("Invalid URL")
                image.image = UIImage(named: "photo")
            }
        
//        
//        image.widthAnchor.constraint(equalToConstant: CGFloat(imageInfo.imageWidth)).isActive = true
//        image.heightAnchor.constraint(equalToConstant: CGFloat(imageInfo.imageHeight)).isActive = true

//        imageName.text = imageInfo.user
        
        }
}
