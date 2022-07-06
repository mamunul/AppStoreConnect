//
//  CommitAssetUploadCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class CommitAssetUploadCommand {
    struct RequestDataAttributes: Codable {
        var uploaded: Bool
        var sourceFileChecksum: String
    }

    struct RequestData: Codable {
        var type = "appScreenshots"
        var id: String
        var attributes: RequestDataAttributes
    }

    struct APIRequest: Codable {
        var data: RequestData
    }

    private let method = Method.patch
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func makeURLRequest(apiRequest: APIRequest) throws -> URLRequest {
        let urlString = "\(apiAccess.baseUrl)/appScreenshots/\(apiRequest.data.id)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(apiRequest)
        return urlRequest
    }

    private func makeAPIRequest(reservationId: String, sourceFileChecksum: String) -> APIRequest {
        let attributes = RequestDataAttributes(uploaded: true, sourceFileChecksum: sourceFileChecksum)
        let data = RequestData(id: reservationId, attributes: attributes)
        let request = APIRequest(data: data)
        return request
    }

    func execute(reservationId: String, sourceFileChecksum: String, access: APIAccess) async throws {
        let request = makeAPIRequest(reservationId: reservationId, sourceFileChecksum: sourceFileChecksum)
        let urlRequest = try makeURLRequest(apiRequest: request)
        try await HTTPHandler().execute(urlRequest: urlRequest, access: access)
    }
}
