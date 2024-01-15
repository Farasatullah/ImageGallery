//
//  ImageViewCell.swift
//  ImageGallery
//
//  Created by Farasat's_MacBook_Pro on 16/01/2024.
//

import UIKit

class ImageViewCell: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
