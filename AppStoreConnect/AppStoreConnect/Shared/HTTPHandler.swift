//
//  HTTPHandler.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class HTTPHandler {
    let decoder = JSONDecoder()
    func execute(urlRequest: URLRequest, access: APIAccess) async throws {
        var request = urlRequest
        let token = try AuthTokenGenerator().generateToken(apiAccess: access)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        if !isSuccess(response: response) {
            let result = try decoder.decode(ErrorResponse.self, from: data)
            throw APIError.api(result)
        }
    }

    func execute<T: Codable>(urlRequest: URLRequest, access: APIAccess) async throws -> T {
        var request = urlRequest
        let token = try AuthTokenGenerator().generateToken(apiAccess: access)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
//        print((response as! HTTPURLResponse).statusCode, response)
        if isSuccess(response: response) {
            let result = try decoder.decode(T.self, from: data)
            return result
        } else {
            print(NSString(string: String(data: data, encoding: .utf8) ?? ""))
            let result = try decoder.decode(ErrorResponse.self, from: data)
            throw APIError.api(result)
        }
    }

    private func isSuccess(response: URLResponse) -> Bool {
        (200 ... 299).contains((response as? HTTPURLResponse)?.statusCode ?? 400)
    }

//    func execute(urlRequest: URLRequest) async throws {
//        let (data, response) = try await URLSession.shared.data(for: urlRequest)
//        if !isSuccess(response: response) {
//            let result = try decoder.decode(ErrorResponse.self, from: data)
//            throw APIError.api(result)
//        }
//    }
}
