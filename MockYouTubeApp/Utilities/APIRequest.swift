//
//  APIRequest.swift
//  MockYouTubeApp
//
//  Created by Yotaro Ito on 2021/04/30.
//

import Foundation
import Alamofire

class APIRequest {
    
//    pathをさらに安全にする（タイプミスがないように）
    enum PathType: String {
        case search
        case channels
    }
    
    // シングルトンを作りメソッドも含めてclass自体をひとつのインスタンスにする
    static var shared = APIRequest()
    
    private let baseUrlString = "https://www.googleapis.com/youtube/v3/"
    
    
//    completionによってメソッドによって異なる処理を書ける、同じ処理をとにかく減らす。
//    GenericsによってAPIの処理を共通化<T: Decodable>, type: T  そして　@escapingでTをcompletionに渡す
//    引数pathにPathTypeを代入
    func request<T: Decodable>(path: PathType , params: [String: Any], type: T.Type, completion: @escaping (T) -> Void){
        
//        ベースURLの後ろにつけるsearchやchannel
//        PathTypeによって自動的にsearchをStringとして代入
        let path = path.rawValue
        
            let url = baseUrlString + path + "?"
            
            var params = params
            params["key"] = "AIzaSyDpwMmfE-r1Jx6rvkZn5yqWdXn9_EQJRpU"
            params["part"] = "snippet "
            
            let request = AF.request(url, method: .get, parameters: params)
            
            request.responseJSON { (response) in
                
                do {
                    guard let data = response.data else {return}
                    let decoder = JSONDecoder()
    //                どんな型(Video,Channel)が入ってきてもTが変換されて、Decodeしてくれる
                    let value = try decoder.decode(T.self, from: data)
                    completion(value)
                    
                }catch {
                    print("変換に失敗しました：", error)
                }
                
            }
        }
}
