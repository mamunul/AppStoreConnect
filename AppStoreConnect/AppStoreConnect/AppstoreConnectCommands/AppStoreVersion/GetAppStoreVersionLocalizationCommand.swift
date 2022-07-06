//
//  GetALocalizationCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

struct AppStoreVersionLocalizationResponse: Codable {
    var data: AppStoreVersionLocalization
    var included: String // AppStoreVersion, AppScreenshotSet, AppPreviewSet
    var links: DocumentLink
}

class GetAppStoreVersionLocalizationCommand {
    private let method = Method.get
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func makeURLRequest(appStoreVersionLocalizationId: String) -> URLRequest {
        let urlString = "\(apiAccess.baseUrl)/appStoreVersionLocalizations/\(appStoreVersionLocalizationId)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(appStoreVersionLocalizationId: String) async throws -> AppStoreVersionLocalizationResponse {
        let urlRequest = makeURLRequest(appStoreVersionLocalizationId: appStoreVersionLocalizationId)
        let response: AppStoreVersionLocalizationResponse =
            try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
