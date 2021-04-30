//
//  VideoListCell.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/04/30.
//

import UIKit
import Nuke

class VideoListCell: UICollectionViewCell{
    
    var videoItemForCV: Item? {
        didSet {
            

          if let url = URL(string: videoItemForCV?.snippet.thumbnails.medium.url ?? ""){
            
//            Nukeを使って画像をキャッシング
            Nuke.loadImage(with: url, into: thumbnailImageView)
            }
            
//           Searchで取得したchannelIdを使ってチャンネルの画像取得を行う (Searchで取得したthumbnail画像とchannnel画像はセットであるため)
            if let channelUrl = URL(string: videoItemForCV?.channel?.items[0].snippet.thumbnails.medium.url ?? "") {
            Nuke.loadImage(with: channelUrl, into: channelImageView)
            }
            
            titleLabel.text = videoItemForCV?.snippet.title
            discriptionLabel.text = videoItemForCV?.snippet.description
        }
    }
    
   
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var channelImageView: UIImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var discriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        channelImageView.layer.cornerRadius = 40/2
    }
    
    

    
}
