//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by Chingiz on 21.02.24.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable{
    let id: IdVideoElement
}

struct IdVideoElement: Codable{
    let kind: String
    let videoId: String
}
