//
//  VideoViewController.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/05/04.
//

import UIKit
import Nuke

class VideoViewController: UIViewController {
    
    var selectedItemForVVC: Item?
    
    private var imageViewCenterY: CGFloat?
    
//　下方向にスワイプ時の領域最大値を決める safeAreaを除外
    var videoImageMaxY: CGFloat {
        
        let excludeValue = view.safeAreaInsets.bottom + (imageViewCenterY ?? 0)
        return view.frame.maxY - excludeValue
    }
    
    var minimumImageViewTrailingConstant: CGFloat {
        -(view.frame.width - (150 + 12))
    }
    


    
    @IBOutlet weak var baseBacgroundView: UIView!
  
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
   
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoImageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoImageViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var videoImageBackView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var discribeView: UIView!
 
    
    @IBOutlet weak var discribeViewTopConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
   
    
    
    
   
//
   
    //　viewDidAppearは全部のviewが呼ばれた後に呼ばれる,全てのviewが呼ばれたのちにalphaを1に戻す
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.baseBacgroundView.alpha = 1 
        }
    }
    
    private func setupViews(){
        self.view.bringSubviewToFront(videoImageView)
        imageViewCenterY = videoImageView.center.y
        channelImageView.layer.cornerRadius = 45 / 2
        
        if let url = URL(string: selectedItemForVVC?.snippet.thumbnails.medium.url ?? ""){
          
          Nuke.loadImage(with: url, into: videoImageView)
          }
 
          if let channelUrl = URL(string: selectedItemForVVC?.channel?.items[0].snippet.thumbnails.medium.url ?? "") {
          Nuke.loadImage(with: channelUrl, into: channelImageView)
          }
          
        videoTitleLabel.text = selectedItemForVVC?.snippet.title
        channelTitleLabel.text = selectedItemForVVC?.channel?.items[0].snippet.title
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panVideoImageView))
        videoImageView.addGestureRecognizer(panGesture)
    }
    @objc private func panVideoImageView(gesture: UIPanGestureRecognizer){
        
        guard let iv = gesture.view else {return}
        let move = gesture.translation(in: iv)
        
        if gesture.state == .changed {
            
            if videoImageMaxY <= move.y {
                moveToBottom(imageView: iv as! UIImageView)
                return
            }
//            GRの動きをつける、縦に動かすときはY軸を使う
            iv.transform = CGAffineTransform(translationX: 0, y: move.y)
            videoImageBackView.transform = CGAffineTransform(translationX: 0, y: move.y)
            
//            左右のパディング
            let movingConstant = move.y / 30
            
            if movingConstant <= 12 {
                videoImageViewTrailingConstraint.constant = -movingConstant
                videoImageViewLeadingConstraint.constant = movingConstant
                
                backViewTrailingConstraint.constant = -movingConstant
            }
            
//            ivの高さの動き
//            高さ 280(最大値)  - 70(最小値) = 210
            let parantViewHeight = self.view.frame.height
            let heightRatio = 210 / (parantViewHeight - (parantViewHeight / 6))
            let moveHeight = move.y * heightRatio
            
            backViewTopConstraint.constant = move.y
            videoImageViewHeightConstraint.constant = 280 - moveHeight
            discribeViewTopConstraint.constant = move.y * 0.8
            
            
            let bottomMoveY = parantViewHeight - videoImageMaxY
            let bottomMoveRatio = bottomMoveY / videoImageMaxY
            let bottomMoveConstant = move.y * bottomMoveRatio
            backViewBottomConstraint.constant = bottomMoveConstant
             
            
//            alpha値の設定
            let alphaRatio = move.y / (parantViewHeight / 2)
             discribeView.alpha = 1 - alphaRatio
            baseBacgroundView.alpha = 1 - alphaRatio
//
//            ivの横幅の動き 150(最小値)
            let originalWidth = self.view.frame.width
//            12はすでにspacingを与えている分
            let constant = originalWidth - move.y
            
//            最小値に行ったら動きをやめる
            if minimumImageViewTrailingConstant > constant {
                videoImageViewTrailingConstraint.constant = minimumImageViewTrailingConstant
                return
            }
            
            if constant < -12 {
                videoImageViewTrailingConstraint.constant = constant
            }
            
 
            
        } else if gesture.state == .ended {
            
            if move.y < self.view.frame.height / 3 {
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: []) {
                    self.backToIdentityAllViews(iv: iv as! UIImageView)
                }
            }else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8 , options: []) {
                    self.moveToBottom(imageView: iv as! UIImageView)
                }

            }
            
            

            
            
        }
        print("gesture.translation:", gesture.translation(in: iv))
    }
    
//    一番したにvideoImageViewが行った時のbottomの確定するメソッド、ズレを防ぐため
    private func moveToBottom(imageView:UIImageView){
        
//        ivの設定
        imageView.transform = CGAffineTransform(translationX: 0, y: videoImageMaxY)
        videoImageViewTrailingConstraint.constant = minimumImageViewTrailingConstant
        videoImageViewHeightConstraint.constant = 70
        
        videoImageBackView.transform = CGAffineTransform(translationX: 0, y: videoImageMaxY)
        discribeView.alpha = 0
        backView.alpha = 0
        
        baseBacgroundView.alpha = 0
        
        self.view.layoutIfNeeded()
    }
    
    private func backToIdentityAllViews(iv: UIImageView){
        //        ivの設定
        iv.transform = .identity
        
        videoImageViewHeightConstraint.constant = 280
        videoImageViewLeadingConstraint.constant = 0
        videoImageViewTrailingConstraint.constant = 0
        
        //        backViewの設定
        backViewTrailingConstraint.constant = 0
        backViewBottomConstraint.constant = 0
        backViewTopConstraint.constant = 0
        backView.alpha = 1
        
        //        discribeViewの設定
        discribeViewTopConstraint.constant = 0
        discribeView.alpha = 1
        
        //        basebackGroundViewの設定
        baseBacgroundView.alpha = 1
        
        self.view.layoutIfNeeded()
    }
    
}
