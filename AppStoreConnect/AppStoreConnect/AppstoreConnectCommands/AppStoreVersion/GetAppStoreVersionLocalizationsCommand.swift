//
//  GetAllLocalizationsCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

struct AppStoreVersionLocalization: Codable {
    var attributes: AppStoreVersionLocalizationAttributes
    var id: String
    var links: DocumentLink
}

struct AppStoreVersionLocalizationsResponse: Codable {
    var data: [AppStoreVersionLocalization]

    var links: DocumentLink
}

class GetAppStoreVersionLocalizationsCommand {
    struct APIRequest {
        /// this is actually platform id of an app
        var appStoreVersionId: String
    }

    private let method = Method.get
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func makeURLRequest(apiRequest: APIRequest) -> URLRequest {
        let urlString = "\(apiAccess.baseUrl)/appStoreVersions/\(apiRequest.appStoreVersionId)/appStoreVersionLocalizations"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(appStoreVersionId: String) async throws ->
        AppStoreVersionLocalizationsResponse {
        let request = APIRequest(appStoreVersionId: appStoreVersionId)
        let urlRequest = makeURLRequest(apiRequest: request)
        let response: AppStoreVersionLocalizationsResponse =
            try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
