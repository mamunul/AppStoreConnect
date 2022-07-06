//
//  CreateAppInfoLocalization.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

struct AppInfoLocalizationsResponse: Codable {
    var data: [AppInfoLocalization]
    var links: PagedDocumentLinks
    var included: [CreateAppInfoLocalizationCommand.AppInfo]?
}

class GetAppInfoLocalizationsCommand {
    struct APIRequest: Codable {
        var appInfoId: String
    }

    private let method = Method.get
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func makeURLRequest(apiRequest: APIRequest) -> URLRequest {
        let urlString = "\(apiAccess.baseUrl)/appInfos/\(apiRequest.appInfoId)/appInfoLocalizations"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(appInfoId: String) async throws -> AppInfoLocalizationsResponse {
        let request = APIRequest(appInfoId: appInfoId)
        let urlRequest = makeURLRequest(apiRequest: request)
        let response: AppInfoLocalizationsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
