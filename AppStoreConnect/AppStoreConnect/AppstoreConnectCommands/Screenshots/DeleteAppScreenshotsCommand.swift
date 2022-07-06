//
//  ScreenshotSetDeleteCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class DeleteAppScreenshotsCommand {
    struct APIRequest {
        var appScreenshotId: String
    }

    private let method = Method.delete
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func makeURLRequest(apiRequest: APIRequest) -> URLRequest {
        let urlString = "\(apiAccess.baseUrl)/appScreenshots/\(apiRequest.appScreenshotId)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(appScreenshotId: String) async throws {
        let request = APIRequest(appScreenshotId: appScreenshotId)
        let urlRequest = makeURLRequest(apiRequest: request)
        try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
    }
}
