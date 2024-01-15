//
//  APIRequest.swift
//  ImageGallery
//
//  Created by Farasat's_MacBook_Pro on 15/01/2024.
//

import Foundation
import Alamofire

class APIRequestHandler{
    
    private static  let shared_Instance = APIRequestHandler()
    
    static func sharedInstance() -> APIRequestHandler{
        return shared_Instance
    }
    
    func fetchImages(result: @escaping ((_ data: [PixabayResponse], _ success: Bool) -> Void)) {
        
        AF.request(BASE_URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
                .response{ resp in
                    switch resp.result{
                      case .success(let data):
                        print("data recived")
                        print(data!.count)
                        print("data recived")

                        do{
                          let jsonData = try JSONDecoder().decode([PixabayResponse].self, from: data!)
                          print(jsonData)
                       } catch {
                          print(error.localizedDescription)
                       }
                     case .failure(let error):
                       print(error.localizedDescription)
                     }
           }
    }
}
