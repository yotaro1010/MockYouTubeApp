//
//  Attension.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/05/03.
//

import UIKit

class AttensionCell: UICollectionViewCell {
    
    private let attensionId = "attensionId"
    
    lazy var attentionColllectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(attentionColllectionView)
        attentionColllectionView.register(UINib(nibName: "AttensionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: attensionId)
        attentionColllectionView.contentInset = .init(top: 0, left: 15, bottom: 0, right: 0)
        attentionColllectionView.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AttensionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = self.frame.height
        return .init(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = attentionColllectionView.dequeueReusableCell(withReuseIdentifier: attensionId, for: indexPath) as! AttensionCollectionViewCell
        return cell
    }
}
