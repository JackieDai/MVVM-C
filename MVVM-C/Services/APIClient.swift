//
//  APIClient.swift
//  MVVM-C
//
//  Created by LingXiao Dai on 2023/7/26.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

/// manage request
protocol ClientType {
    func request<T: Codable>(_ endpoint : URLRequestConvertible) -> Single<T>
    func requestImage(_ endpoint: URLRequestConvertible) -> Single<UIImage>
}

class APIClient: ClientType {
    func request<T: Codable>(_ endpoint: URLRequestConvertible) -> Single<T> {
        let single = Single<T>.create { single in
            let request = AF.request(endpoint)
            request.responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let val):
                    single(.success(val))
                case .failure(let err):
                    single(.failure(err))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
        return single
    }
    
    func requestImage(_ endpoint: URLRequestConvertible) -> Single<UIImage> {
        return Single<UIImage>.create { single in
            let request = AF.request(endpoint)
            request.responseData { response in
                switch response.result {
                case .success(let value):
                    guard let image = UIImage(data: value) else {
                        single(.failure(ClientError.imageDecodingFailed))
                        return
                    }
                    single(.success(image))
                case .failure(let err):
                    single(.failure(err))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}


enum ClientError: Error {
    case imageDecodingFailed
}

extension ClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .imageDecodingFailed:
            return "Unable to decode image"
        }
    }
}
