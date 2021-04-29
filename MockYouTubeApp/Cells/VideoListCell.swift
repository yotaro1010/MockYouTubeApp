//
//  VideoListCell.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/04/30.
//

import UIKit

class VideoListCell: UICollectionViewCell{
    
    @IBOutlet weak var channelImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        channelImageView.layer.cornerRadius = 40/2
    }
    
    
    
}
