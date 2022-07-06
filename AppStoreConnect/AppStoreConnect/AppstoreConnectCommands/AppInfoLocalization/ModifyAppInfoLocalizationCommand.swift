//
//  CreateAppInfoLocalization.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

struct AppInfoLocalization: Codable {
    var type: String
    var id: String
    var links: DocumentLink
    var attributes: AppInfoLocalizationAttributes
}

struct AppInfoLocalizationResponse: Codable {
    var data: AppInfoLocalization
    var links: DocumentLink
    var included: [ModifyAppInfoLocalizationCommand.AppInfo]?
}

class ModifyAppInfoLocalizationCommand {
    struct AppInfoData: Codable {
        /// appInfo Id
        var id: String
        var type: String = "appInfos"
    }

    struct AppInfo: Codable {
        var data: AppInfoData
    }

    struct Relationships: Codable {
        var appInfo: AppInfo
    }

    struct RequestData: Codable {
        var attributes: AppInfoLocalizationAttributes
        var id: String
        var type: String = "appInfoLocalizations"
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
        let urlString = "\(apiAccess.baseUrl)/appInfoLocalizations/\(apiRequest.data.id)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try JSONEncoder().encode(apiRequest)
        return urlRequest
    }

    private func makeAPIRequest(appInfoLocalizationId: String, attributes: AppInfoLocalizationAttributes) -> APIRequest {
        let requestData = RequestData(attributes: attributes, id: appInfoLocalizationId)
        let request = APIRequest(data: requestData)
        return request
    }

    func execute(appInfoLocalizationId: String, attributes: AppInfoLocalizationAttributes) async throws ->
        AppInfoLocalizationResponse {
        let request = makeAPIRequest(appInfoLocalizationId: appInfoLocalizationId, attributes: attributes)
        let urlRequest = try makeURLRequest(apiRequest: request)
        let response: AppInfoLocalizationResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
