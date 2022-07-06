//
//  RequestUploadCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

class RequestUploadCommand {
//    POST \(apiAccess.baseUrl)/appScreenshots
    struct AppScreenshotSetData: Codable {
        var id: String
        var type: String = "appScreenshotSets"
    }

    struct AppScreenshotSet: Codable {
        var data: AppScreenshotSetData
    }

    struct Relationships: Codable {
        var appScreenshotSet: AppScreenshotSet
    }

    struct RequestAttributes: Codable {
        var fileName: String
        var fileSize: Int
    }

    struct RequestData: Codable {
        var attributes: RequestAttributes
        var relationships: Relationships
        var type: String = "appScreenshots"
    }

    struct APIRequest: Codable {
        var data: RequestData
    }

    struct ScreenshotResponse: Codable {
        var links: DocumentLink
        var data: AppScreenshot
    }

    private let method = Method.post
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func makeURLRequest(apiRequest: APIRequest) throws -> URLRequest {
        let urlString = "\(apiAccess.baseUrl)/appScreenshots"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(apiRequest)
        return urlRequest
    }

    private func makeAPIRequest(appScreenshotSetId: String, fileName: String, fileSize: Int) -> APIRequest {
        let screenshotSetData = AppScreenshotSetData(id: appScreenshotSetId)
        let screenshotSet = AppScreenshotSet(data: screenshotSetData)
        let relationships = Relationships(appScreenshotSet: screenshotSet)
        let attributes = RequestAttributes(fileName: fileName, fileSize: fileSize)
        let requestData = RequestData(attributes: attributes, relationships: relationships)
        let request = APIRequest(data: requestData)
        return request
    }

    func execute(appScreenshotSetId: String, fileName: String, fileSize: Int) async throws ->
        ScreenshotResponse {
        let request = makeAPIRequest(appScreenshotSetId: appScreenshotSetId, fileName: fileName, fileSize: fileSize)
        let urlRequest = try makeURLRequest(apiRequest: request)
        let response: ScreenshotResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
