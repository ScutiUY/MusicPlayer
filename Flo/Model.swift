//
//  Model.swift
//  Flo
//
//  Created by 신의연 on 2020/10/05.
//

import Foundation

var playList = [MusicInfo]()

struct MusicInfo: Codable {
    var singer: String
    var albumTitle: String
    var title: String
    var duration: Int
    var image: String
    var file: String
    var lyrics: String
    
    enum CodingKeys: String, CodingKey {
        case singer
        case albumTitle = "album"
        case title
        case duration
        case image
        case file
        case lyrics
    }
}
