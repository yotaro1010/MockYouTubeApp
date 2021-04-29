//
//  ViewController.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/04/30.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    
    @IBOutlet weak var videoListCollectionView: UICollectionView!
    
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self
        
        let urlString = "https://www.googleapis.com/youtube/v3/search?q=lebron&key=AIzaSyDpwMmfE-r1Jx6rvkZn5yqWdXn9_EQJRpU&part=snippet"
        
        let request = AF.request(urlString)
        
        request.responseJSON { (response) in
            
            do {
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let video = try decoder.decode(Video.self, from: data)
                print("Video:", video.items.count)
            }catch {
                print("変換に失敗しました：", error)
            }
            
        }
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoListCell
 
        return cell
    }
    
    
}
