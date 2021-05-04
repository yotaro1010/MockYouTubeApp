//
//  AttensionCollectionViewCell.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/05/03.
//

import UIKit
import Nuke

class AttensionCollectionViewCell: UICollectionViewCell {
   
    var videoItemForACVC: Item? {
        didSet {
            if let url = URL(string: videoItemForACVC?.snippet.thumbnails.medium.url ?? ""){
              
  //            Nukeを使って画像をキャッシング
              Nuke.loadImage(with: url, into: thumbnailImageView)
              }
            
            videoTitleLabel.text = videoItemForACVC?.snippet.title
            discriptionLabel.text = videoItemForACVC?.snippet.description
            channelTitleLabel.text = videoItemForACVC?.channel?.items[0].snippet.title
        }
    }
    
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


}
