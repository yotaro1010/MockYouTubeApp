//
//  AttensionCollectionViewCell.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/05/03.
//

import UIKit

class AttensionCollectionViewCell: UICollectionViewCell {
   
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .purple
    }


}
