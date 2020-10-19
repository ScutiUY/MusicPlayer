//
//  Model.swift
//  Flo
//
//  Created by 신의연 on 2020/10/05.
//

import Foundation

var playList = [MusicInfo]()

var refineLyrics: [(Double,String)] {
    var refine = [(Double,String)]()
    for i in playList[0].lyrics.split(separator: "\n") {
        var time = String(i.split(separator: "]")[0])
        let lyrics = String(i.split(separator: "]")[1])
        time.removeFirst()
        refine.append(((Double(time.split(separator: ":")[0])! * 60) + (Double(time.split(separator: ":")[1])!) + (Double(time.split(separator: ":")[2])! * 0.001), lyrics))
    }
    return refine
}

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
