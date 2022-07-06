//
//  CreateNewLocalizationCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class ModifyAppStoreVersionLocalizationCommand {
    struct RelationshipData: Codable {
        var type: String = "appStoreVersions"
        var id: String
    }

    struct AppStoreVersion: Codable {
        var data: RelationshipData
    }

    struct Relationships: Codable {
        var appStoreVersion: AppStoreVersion
    }

    struct RequestData: Codable {
        var type: String = "appStoreVersionLocalizations"
        var attributes: AppStoreVersionLocalizationAttributes
        var id: String
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
        let urlString = "\(apiAccess.baseUrl)/appStoreVersionLocalizations/\(apiRequest.data.id)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try JSONEncoder().encode(apiRequest)
        return urlRequest
    }

    private func makeAPIRequest(appStoreVersionLocalizaitonId: String, attributes: AppStoreVersionLocalizationAttributes) -> APIRequest {
        let data = RequestData(attributes: attributes, id: appStoreVersionLocalizaitonId)
        let request = APIRequest(data: data)
        return request
    }

    func execute(appStoreVersionLocalizaitonId: String, attributes: AppStoreVersionLocalizationAttributes)
    async throws -> AppStoreVersionLocalizationResponse {
        let request = makeAPIRequest(appStoreVersionLocalizaitonId: appStoreVersionLocalizaitonId, attributes: attributes)
        let urlRequest = try makeURLRequest(apiRequest: request)
        let response: AppStoreVersionLocalizationResponse =
            try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
