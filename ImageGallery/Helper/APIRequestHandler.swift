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
    
    func fetchImages(result: @escaping ((_ data: PixabayResponse?, _ success: Bool) -> Void)) {
        
        AF.request(BASE_URL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .response { resp in
                switch resp.result {
                case .success(let data):
                    print("Data received: \(String(describing: data))")
                    
                    do {
                        guard let jsonData = data else {
                            print("Error: Data is nil.")
                            result(nil, false)
                            return
                        }
                        
                        let decodedData = try JSONDecoder().decode(PixabayResponse.self, from: jsonData)
                        print("Decoded data: \(decodedData)")
                        result(decodedData, true)
                    } catch let decodingError {
                        print("Error decoding PixabayResponse: \(decodingError)")
                        result(nil, false)
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                    result(nil, false)
                }
            }}
}
