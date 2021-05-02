//
//  ViewController.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/04/30.
//

import UIKit
import Alamofire


class ViewController: UIViewController {

    @IBOutlet weak var headerVIew: UIView!
    @IBOutlet weak var headerHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var videoListCollectionView: UICollectionView!
    
//    0.5秒前にスクロールした位置
    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
//    headerを表示させるスピード
    private let headerMoveHeight: CGFloat = 7
    
    private let cellId = "cellId"
    
    private var videoItemsForVC = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self
        
        profileImageView.layer.cornerRadius = 20
        
       fetchYouTubeSearchInfo()
    }
    
    private func fetchYouTubeSearchInfo(){
        
        let params = ["q": "lebron"]
        
//        ここでapiRequestを呼び出す時に毎回初期化（let api = APIRequest()...みたいにやると良くない通信が重くなるのでそれは避ける）
//        では何を使うか、シングルトンを使い　class　APIRequstのメソッドをひとつのインスタンスとして扱い、それを呼びだすことで、毎回の初期化を避ける
        API.shared.request(path: .search, params: params, type: Video.self) { (video) in
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
        
        API.shared.request(path: .channels, params: params, type: Channel.self) { (channel) in
//            取得したすべての[Chanel]itemに情報を反映
            self.videoItemsForVC.forEach { (item) in
                item.channel = channel
            }
            self.videoListCollectionView.reloadData()
        }
    }
//    スクロールを認識させる、動きと合わせてヘッダーのアニメーションを作る
//    scrollViewを用いる
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        IBで作ったTopを座標取得によって移動させる
//        座標をマイナスさせることで上に移動可能,スクロールごとにマイナスになる
//        スクロールするたびに、0.5秒前の位置と比較しつつ上にスクロースしているのか、下にしているのか判断する
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.prevContentOffset = scrollView.contentOffset
        }
        
//        上下方向にスクロール時,動きがおかしくなっているのを直す
        guard let presentIndexPath = videoListCollectionView.indexPathForItem(at: scrollView.contentOffset) else {return}
//        下方向時,座標が0の時アニメーションをさせない
        if scrollView.contentOffset.y < 0 { return }
//        上方向時:CGポイントからCellの番号を取得し、一番最後のCellになる前にアニメーション表示を止める、カウントは0から始まるため、フルカウントをすると-1をした分の値が最後のcellの位置だが、それよりも前に止めるため-2をして最後から２番目のcellのindexを取得
        if presentIndexPath.row >= videoItemsForVC.count - 2 {return}
        
//        headerをスクロール時に薄くする
        let alphaRatio = 1 / headerHightConstraint.constant
        
//        0.5秒前の値が小さい時(下にスクロールしているとき)　ヘッダーを隠す
        if self.prevContentOffset.y < scrollView.contentOffset.y {
            if headerTopConstraint.constant <= -headerHightConstraint.constant{ return }
                headerTopConstraint.constant -= headerMoveHeight
            headerVIew.alpha -= alphaRatio * headerMoveHeight
        } else if self.prevContentOffset.y > scrollView.contentOffset.y {
//            headrのTopが０になった場合 = 最大値
            if headerTopConstraint.constant >= 0 {return}
            headerTopConstraint.constant += headerMoveHeight
            headerVIew.alpha += alphaRatio * headerMoveHeight

        }
    }
//    スクロールを途中で止めたときのheaderのアニメーション
//    挙動がまだおかしいときはscrollViewDidEndDragging,scrollViewDidEndDecelerating二つのメソッドが同時に呼び出されてしまっているから
    
//    指でピタッと止めたときはのみscrollViewDidEndDraggingを呼び出す 引数のdecelerateを使う
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            headerViewEndAnimation()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerViewEndAnimation()
    }
    
    private func headerViewEndAnimation(){
        //        下スクロール時
                if headerTopConstraint.constant < -headerHightConstraint.constant / 2 {
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
                        self.headerTopConstraint.constant = -self.headerHightConstraint.constant
                        self.headerVIew.alpha = 0
                        self.view.layoutIfNeeded()
                    })
                }else {
        //            上スクロール時
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
                        self.headerTopConstraint.constant = 0
                        self.headerVIew.alpha = 1
                        self.view.layoutIfNeeded()
                    })
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
