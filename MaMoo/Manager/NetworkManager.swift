//
//  NetworkManager.swift
//  MaMoo
//
//  Created by Sebin Kwon on 1/27/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchResults<T: Decodable>(api: TMDBRequest, type: T.Type, _ completionHandler: @escaping (T) -> Void, failHandler: @escaping (ErrorType) -> Void) {
        AF.request(api.endPoint, method: api.method, parameters: api.parameter, encoding: URLEncoding(destination: .queryString), headers: api.header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                print("Success")
                completionHandler(value)
            case .failure(let error):
                print(error)
                guard let code = error.responseCode else { return }
                failHandler(ErrorType(rawValue: code) ?? ErrorType.server)
            }
        }
    }
    
    enum ErrorType: Int {
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
        case server = 500
        
        var title: String {
            switch self {
            case .badRequest: return "잘못된 요청"
            case .unauthorized: return "인증 실패"
            case .forbidden: return "금지됨"
            case .notFound: return "찾을 수 없음"
            case .server: return "내부 오류"
            }
        }
        
        var reason: String {
            switch self {
            case .badRequest: return "잘못된 매개변수입니다."
            case .unauthorized: return "서비스에 액세스할 수 있는 권한이 없습니다."
            case .forbidden: return "이 사용자는 정지되었습니다."
            case .notFound: return "요청하신 리소스를 찾을 수 없습니다."
            case .server: return "오류가 발생했습니다. TMDB에 문의하세요."
            }
        }
    }
}
