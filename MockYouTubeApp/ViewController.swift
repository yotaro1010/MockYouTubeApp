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
    
    private var videoItemsForVC = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self
        
       fetchYouTubeSearchInfo()
    }
    
    private func fetchYouTubeSearchInfo(){
        let urlString = "https://www.googleapis.com/youtube/v3/search?q=lebron&key=AIzaSyDpwMmfE-r1Jx6rvkZn5yqWdXn9_EQJRpU&part=snippet"
        
        let request = AF.request(urlString)
        
        request.responseJSON { (response) in
            
            do {
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let video = try decoder.decode(Video.self, from: data)
//                fetchしたitemsの情報をvideoに渡す
                self.videoItemsForVC = video.items
//                self.videoListCollectionView.reloadData()
//             番最初の配列の要素[0]だけ情報を取得、またそこからchannelIdも取得
                let id = self.videoItemsForVC[0].snippet.channelId
                self.fetchYouTubeChannelInfo(id: id)

      
            }catch {
                print("変換に失敗しました：", error)
            }
            
        }
    }
    private func fetchYouTubeChannelInfo(id: String){
        let urlString = "https://www.googleapis.com/youtube/v3/channels?=lebron&key=AIzaSyDpwMmfE-r1Jx6rvkZn5yqWdXn9_EQJRpU&part=snippet&id=\(id)"
        
        let request = AF.request(urlString)
        
        request.responseJSON { (response) in
            
            do {
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                let channel = try decoder.decode(Channel.self, from: data)

//                 取得したすべての[Chanel]itemに情報を反映
                self.videoItemsForVC.forEach { (item) in
                    item.channel = channel
                }
                
                self.videoListCollectionView.reloadData()
                
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
        return videoItemsForVC.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoListCell
        cell.videoItemForCV = videoItemsForVC[indexPath.row]
        return cell
    }
    
    
}
