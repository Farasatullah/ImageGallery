//
//  PixabayResponse.swift
//  ImageGallery
//
//  Created by Farasat's_MacBook_Pro on 15/01/2024.
//

import Foundation

struct PixabayResponse: Codable {
    
    let total: Int
    let totalHits: Int
    let hits: [PixabayImage]
}

struct PixabayImage: Codable {
    
    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let webformatURL: String
    let webformatWidth: Int
    let webformatHeight: Int
    let largeImageURL: String
    let fullHDURL: String
    let imageURL: String
    let imageWidth: Int
    let imageHeight: Int
    let imageSize: Int
    let views: Int
    let downloads: Int
    let likes: Int
    let comments: Int
    let user_id: Int
    let user: String
    let userImageURL: String
    
}
