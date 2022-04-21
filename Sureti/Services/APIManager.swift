//
//  APIManager.swift
//  nullbrainer-sureti
//
//  Created by Amjad on 20/04/2022.
//

import Foundation
import Alamofire
class APIManager {
    static let shared = APIManager()
    func configure() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.httpAdditionalHeaders = getHeaders().dictionary
        print("configuration httpAdditional Headers are.... \((configuration.httpAdditionalHeaders)!)")
        return configuration
    }
    func getHeaders() -> HTTPHeaders{
        let deviceModel = UserDefaults.standard.value(forKey: "DeviceModelName") ?? ""
        let appVersion = UserDefaults.standard.value(forKey: "currentAppVersion") ?? ""
        let systemVersion = UserDefaults.standard.value(forKey: "systemVersion") ?? ""
        let params: HTTPHeaders = [
            "device": "iphone",
            "device_model": "\(deviceModel)",
            "platform": "ios",
            "platform_version": "\(systemVersion)",
            "app_version": "\(appVersion)"
        ]
        return params
    }
    func  request<T: Decodable>(url: String, method: HTTPMethod, parameters: [String: Any], completion: @escaping (Bool, T?, Int?, String?) -> ()) {

        let sessionManager = Alamofire.Session(configuration: configure())
        sessionManager.request(url, method: method, parameters: parameters)
            .responseJSON { (response ) in
                print(url, " : ", response)
                switch response.result{
                case .success:
                    if let jsonData = response.data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let decodeData = try jsonDecoder.decode(T.self, from: jsonData)
                            completion(true, decodeData, response.response?.statusCode, nil)
                            
                        } catch let DecodingError.typeMismatch(type, context)  {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                            completion(false, nil, nil, "Unable to parse data!")
                        } catch let error{
                            print(error.localizedDescription)
                            completion(false, nil, response.response?.statusCode, error.localizedDescription)
                        }
                    } else {
                        completion(false, nil, nil, "Unable to parse data!")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, nil, response.response?.statusCode, error.localizedDescription)
                    
                }
                sessionManager.session.invalidateAndCancel()
            }
    }
}
