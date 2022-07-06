//
//  ScreenshotGetCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

enum UploadState: String, Codable {
    case AWAITING_UPLOAD, UPLOAD_COMPLETE, COMPLETE, FAILED
}

struct AppMediaStateError: Codable {
    var code: String
    var description: String
}

struct AppMediaAssetState: Codable {
    var errors: [AppMediaStateError]
    var state: UploadState
    var warnings: [AppMediaStateError]?
}

struct HttpHeader: Codable {
    var name: String
    var value: String
}

struct UploadOperation: Codable {
    var length: Int
    var method: String
    var offset: Int
    var requestHeaders: [HttpHeader]
    var url: String
}

struct ImageAsset: Codable {
    var templateUrl: String
    var height: Int
    var width: Int
}

struct ScreenshotAttributes: Codable {
    var assetDeliveryState: AppMediaAssetState
    var assetToken: String
    var assetType: String
    var fileName: String
    var fileSize: Int
    var imageAsset: ImageAsset?
    var sourceFileChecksum: String?
    var uploadOperations: [UploadOperation]?
}

struct AppScreenshot: Codable {
    var attributes: ScreenshotAttributes
    var id: String

    var links: DocumentLink
    var type: String = "appScreenshots"
}

class GetScreenshotCommand {
    struct AppScreenshotsResponse: Codable {
        var data: [AppScreenshot]

        var links: PagedDocumentLinks
    }

    private let method = Method.get
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    struct APIRequest {
        /// this is actually platform id of an app
        var appscreenshotSetId: String
    }

    private func makeURLRequest(apiRequest: APIRequest) -> URLRequest {
        let urlString = "\(apiAccess.baseUrl)/appScreenshotSets/\(apiRequest.appscreenshotSetId)/appScreenshots"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(screenshotSetId: String) async throws -> AppScreenshotsResponse {
        let request = APIRequest(appscreenshotSetId: screenshotSetId)
        let urlRequest = makeURLRequest(apiRequest: request)
        let response: AppScreenshotsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}
