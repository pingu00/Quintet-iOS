//
//  NetworkManager.swift
//  Quintet-iOS
//
//  Created by Phil on 2023/08/21.
//

import Foundation
import Moya
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private let provider = MoyaProvider<QuintetAPI>()
    
    func fetchWeekCheckData(userID: Int) {
        provider.request(.getWeekCheck(user_id: userID)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(WeeklyDataResponse.self, from: response.data)
                    print (decodedResponse.result)
                } catch let err {
                    print(err)
                }
            case .failure(let moyaError):
                print("There's an error, \(moyaError)")
            }
        }
    }
    
    func postCheckData(parameters: [String: Any]) {
        provider.request(.postTodays(parameters: parameters)) {result in
            switch result {
            case let .success(response):
                if response.statusCode == 200 {
                    print("POST request successful!")
                } else {
                    print("POST request failed with status code: \(response.statusCode)")
                }
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
    
}
