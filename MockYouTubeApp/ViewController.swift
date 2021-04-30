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
        
        let params = ["q": "lebron"]
        
//        ここでapiRequestを呼び出す時に毎回初期化（let api = APIRequest()...みたいにやると良くない通信が重くなるのでそれは避ける）
//        では何を使うか、シングルトンを使い　class　APIRequstのメソッドをひとつのインスタンスとして扱い、それを呼びだすことで、毎回の初期化を避ける
        APIRequest.shared.request(path: .search, params: params, type: Video.self) { (video) in
//            fetchしたitemsの情報をvideoに渡す
                     self.videoItemsForVC = video.items
 //            1番最初の配列の要素[0]だけ情報を取得、またそこからchannelIdも取得
            let id = self.videoItemsForVC[0].snippet.channelId
            self.fetchYouTubeChannelInfo(id: id)
        }
    
//        元の処理
//        let urlString = "https://www.googleapis.com/youtube/v3/search?q=lebron&key=AIzaSyDpwMmfE-r1Jx6rvkZn5yqWdXn9_EQJRpU&part=snippet"
//        let request = AF.request(urlString)
//        request.responseJSON { (response) in
//            do {
//                guard let data = response.data else {return}
//                let decoder = JSONDecoder()
//                let video = try decoder.decode(Video.self, from: data)
//                fetchしたitemsの情報をvideoに渡す
//                self.videoItemsForVC = video.items
//                self.videoListCollectionView.reloadData()
//             番最初の配列の要素[0]だけ情報を取得、またそこからchannelIdも取得
//                let id = self.videoItemsForVC[0].snippet.channelId
//                self.fetchYouTubeChannelInfo(id: id)
//            }catch {
//                print("変換に失敗しました：", error)
//            }
//        }
    }
    
    private func fetchYouTubeChannelInfo(id: String){
        
        let params = [
            "id": id
        ]
        
        APIRequest.shared.request(path: .channels, params: params, type: Channel.self) { (channel) in
//            取得したすべての[Chanel]itemに情報を反映
            self.videoItemsForVC.forEach { (item) in
                item.channel = channel
            }
            self.videoListCollectionView.reloadData()
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
