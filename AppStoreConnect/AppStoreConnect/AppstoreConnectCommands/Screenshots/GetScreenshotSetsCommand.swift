//
//  GetScreenshotSetsCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

enum DisplayType: String, Codable {
    case APP_IPHONE_65, APP_IPHONE_58, APP_IPHONE_55, APP_IPHONE_47, APP_IPHONE_40, APP_IPHONE_35
    case APP_IPAD_PRO_3GEN_129, APP_IPAD_PRO_3GEN_11, APP_IPAD_PRO_129, APP_IPAD_105, APP_IPAD_97
    case APP_DESKTOP
}

struct AppScreenshotSet: Codable {
    struct Attributes: Codable {
        var screenshotDisplayType: DisplayType
    }

    var attributes: Attributes
    var id: String
    var links: DocumentLink
    var type: String
}

class GetScreenshotSetsCommand {
    struct AppScreenshotSetsResponse: Codable {
        var data: [AppScreenshotSet]
        var links: PagedDocumentLinks
    }

    struct APIRequest {
        var localizationId: String
    }

    private let method = Method.get
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func makeURLRequest(apiRequest: APIRequest) -> URLRequest {
        let urlString = "\(apiAccess.baseUrl)/appStoreVersionLocalizations/\(apiRequest.localizationId)/appScreenshotSets"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(appStoreLocalizedVersionId: String) async throws -> AppScreenshotSetsResponse {
        let request = APIRequest(localizationId: appStoreLocalizedVersionId)
        let urlRequest = makeURLRequest(apiRequest: request)
        let response: AppScreenshotSetsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
