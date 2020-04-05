//
//  PixbayResponse.swift
//  iDeliver
//
//  Created by Hugo Flores Perez on 4/3/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

struct PixbayResponse: Codable {
    let total, totalHits: Int
    var hits: [PixbayHit]
}

struct PixbayHit: Codable {
    let id: Int
    let pageURL: String
    let type, tags: String
    let previewURL: String
    let previewWidth, previewHeight: Int
    let webformatURL: String
    let webformatWidth, webformatHeight: Int
    let largeImageURL: String
    let imageWidth, imageHeight, imageSize, views: Int
    let downloads, favorites, likes, comments: Int
    let user_id: Int
    let user: String
    let userImageURL: String
}
