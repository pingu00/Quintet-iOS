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
                    print("오늘의 체크내용 post 성공!")
                } else {
                    print("포스팅 실패 code: \(response.statusCode)")
                }
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
    func fetchWeekStatistics(userID: String, startDate: String, endDate : String) {
        provider.request(.getWeekStatic(user_id: userID, startDate: startDate, endDate: endDate)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(StatisticsDataResponse.self, from: response.data)
                    print (decodedResponse.result)
                } catch let err {
                    print(err)
                }
            case .failure(let moyaError):
                print("There's an error, \(moyaError)")
            }
        }
    }
    func fetchMonthStatistics(userID: String, year: Int, month: Int) {
        provider.request(.getMonthStatic(user_id: userID, year: year, month: month)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(StatisticsDataResponse.self, from: response.data)
                    print (decodedResponse.result)
                } catch let err {
                    print(err)
                }
            case .failure(let moyaError):
                print("There's an error, \(moyaError)")
            }
        }
    }
    func fetchYearStatistics(userID: String, year: Int) {
        provider.request(.getYearStatic(user_id: userID, year: year)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(StatisticsDataResponse.self, from: response.data)
                    print (decodedResponse.result)
                } catch let err {
                    print(err)
                }
            case .failure(let moyaError):
                print("There's an error, \(moyaError)")
            }
        }
    }
    func fetchRecordsByDate(userID: String, year: Int, month: Int, completion: @escaping (Result<[RecordResult], Error>) -> Void) {
        provider.request(.getRecordsByDate(user_id: userID, year: year, month: month)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(RecordDataResponse.self, from: response.data)
                    print(decodedResponse.result)
                    completion(.success(decodedResponse.result))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let moyaError):
                completion(.failure(moyaError))
            }
        }
    }

    func fetchRecordsByElement(userID: String, year: Int, month: Int, element: String, completion: @escaping (Result<[RecordResult], Error>) -> Void) {
        provider.request(.getRecordsByElement(user_id: userID, year: year, month: month, element: element)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(RecordDataResponse.self, from: response.data)
                    print("요소별",decodedResponse.result)
                    completion(.success(decodedResponse.result))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let moyaError):
                completion(.failure(moyaError))
            }
        }
    }

    func fetchProfileName(completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.getProfileName) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(ProfileDataResponse.self, from: response.data)
                    print(decodedResponse.result)
                    completion(.success(decodedResponse.result.nickname)) // 클로저를 통해 닉네임 전달
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let moyaError):
                print("There's an error, \(moyaError)")
                completion(.failure(moyaError))
            }
        }
    }

    func EditProfileName(newNickname : String) {
        provider.request(.patchProfileName(newNickname: newNickname)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(ProfileDataResponse.self, from: response.data)
                    
                    if response.statusCode == 400 {
                        print(decodedResponse.message)
                    } else {
                        print("\(decodedResponse.result.nickname)으로프로필 이름 변경완료")
                    }
                } catch let err {
                    print(err)
                }
            case .failure(let moyaError):
                print("There's an error, \(moyaError)")
            }
        }
    }
}

