//
//  ScreenshotSetDeleteCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class DeleteScreenshotSetCommand {
    /*
     DELETE \(apiAccess.baseUrl)/appScreenshotSets/{id}
     */

    struct APIRequest {
        var appScreenshotsId: String
    }

    private let method = Method.delete
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func makeURLRequest(apiRequest: APIRequest) -> URLRequest {
        let urlString = "\(apiAccess.baseUrl)/appScreenshotSets/\(apiRequest.appScreenshotsId)"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(appScreenshotsId: String) async throws {
        let request = APIRequest(appScreenshotsId: appScreenshotsId)
        let urlRequest = makeURLRequest(apiRequest: request)
        try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
    }
}
