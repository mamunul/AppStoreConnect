//
//  CreateNewLocalizationCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

enum ValidaitonError: Error {
    case invalidProperty(String)
}

struct AppStoreVersionLocalizationAttributes: Codable {
    private(set) var locale: Localization
    private(set) var description: String?
    private(set) var keywords: String?
    private(set) var marketingUrl: String?
    private(set) var promotionalText: String?
    private(set) var supportUrl: String?
    private(set) var whatsNew: String?

    init(
        locale: Localization,
        description: String,
        keywords: String? = nil,
        marketingUrl: String,
        promotionalText: String? = nil,
        supportUrl: String,
        whatsNew: String? = nil
    ) throws {
        self.locale = locale
        self.description = description
        self.keywords = keywords
        self.marketingUrl = marketingUrl
        self.promotionalText = promotionalText
        self.supportUrl = supportUrl
        self.whatsNew = whatsNew

        if description.count < 10 { throw ValidaitonError.invalidProperty("description") }
    }
}

class CreateAppStoreVersionLocalizationCommand {
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
        var relationships: Relationships
    }

    struct APIRequest: Codable {
        var data: RequestData
    }

    struct ResponseData: Codable {
        var type: String
        var attributes: AppStoreVersionLocalizationAttributes
        var id: String
    }

    struct AppStoreVersionLocalizationResponse: Codable {
        var data: ResponseData
    }

    private let method = Method.post
    private var urlString: String
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
        urlString = "\(apiAccess.baseUrl)/appStoreVersionLocalizations"
    }

    private func makeURLRequest(apiRequest: APIRequest) throws -> URLRequest {
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try JSONEncoder().encode(apiRequest)
        return urlRequest
    }

    private func makeAPIRequest(appStoreVersionId: String, attributes: AppStoreVersionLocalizationAttributes) -> APIRequest {
        let relationship = RelationshipData(id: appStoreVersionId)
        let appstoreVersion = AppStoreVersion(data: relationship)
        let relationships2 = Relationships(appStoreVersion: appstoreVersion)
        let data = RequestData(attributes: attributes, relationships: relationships2)
        let request = APIRequest(data: data)
        return request
    }

    func execute(appStoreVersionId: String, attributes: AppStoreVersionLocalizationAttributes) async throws ->
        AppStoreVersionLocalizationResponse {
        let request = makeAPIRequest(appStoreVersionId: appStoreVersionId, attributes: attributes)
        let urlRequest = try makeURLRequest(apiRequest: request)
        let response: AppStoreVersionLocalizationResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
