//
//  Channel.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/04/30.
//

import Foundation

class Channel: Decodable {
    let items: [ChannelItem]
}

class ChannelItem: Decodable{
    let snippet: ChannelSnippet
    
}

class ChannelSnippet: Decodable {
    let thumbnails: Thumbnail
}


