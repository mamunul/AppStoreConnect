//
//  CreateAppInfoLocalization.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

struct AppInfoLocalizationAttributes: Codable {
    var locale: Localization
    var name: String
    var privacyPolicyText: String?
    var privacyPolicyUrl: String?
    var subtitle: String?
    var privacyChoicesUrl: String?
}

class CreateAppInfoLocalizationCommand {
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

        var relationships: Relationships

        var type: String = "appInfoLocalizations"
    }

    struct APIRequest: Codable {
        var data: RequestData
    }

    private let method = Method.post
    private var urlString: String
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
        urlString = "\(apiAccess.baseUrl)/appInfoLocalizations"
    }

    private func makeURLRequest(apiRequest: APIRequest) throws -> URLRequest {
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try JSONEncoder().encode(apiRequest)
        return urlRequest
    }

    private func makeAPIRequest(appInfoId: String, attributes: AppInfoLocalizationAttributes) -> APIRequest {
        let appInfoData = AppInfoData(id: appInfoId)
        let appInfo = AppInfo(data: appInfoData)
        let relationships = Relationships(appInfo: appInfo)
        let requestData = RequestData(attributes: attributes, relationships: relationships)
        let request = APIRequest(data: requestData)
        return request
    }

    func execute(appInfoId: String, attributes: AppInfoLocalizationAttributes) async throws ->
        AppInfoLocalizationResponse {
        let request = makeAPIRequest(appInfoId: appInfoId, attributes: attributes)
        let urlRequest = try makeURLRequest(apiRequest: request)
        let response: AppInfoLocalizationResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
