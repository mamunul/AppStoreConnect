//
//  GetAllPlatformVersionCommand.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 1/7/22.
//

import Foundation

struct AppStoreVersionAttributes: Codable {
    var platform: Platform
    var appStoreState: AppStoreVersionState
    var copyright: String?
    var earliestReleaseDate: String?
    var releaseType: ReleaseType

    var versionString: String
    var createdDate: String
    var downloadable: Bool
}

struct AppStoreVersion: Codable {
    var attributes: AppStoreVersionAttributes
    var type: String
    var id: String
}

///
/// Command to get the id of the avialable platform for an app
///
/// Provide an app _id_ in the  __GET__  request it will send response with the each platorm info id in return.
/// This class conforms with ``Command`` _protocol_
/// ```swift
/////usage
/// AllPlatformsGetCommand().execute()
///
/// ```
class GetAppStoreVersionsCommand {
    struct APIRequest {
        static var empty: APIRequest = APIRequest(appId: "")
        static var quranApp = APIRequest(appId: "1632370801")

        var appId: String
    }

    /// actually providing all platforms (ios, macos, tvos) id for an app
    struct AppStoreVersionsResponse: Codable {
        var data: [AppStoreVersion]
        var links: DocumentLink
    }

    private let method = Method.get
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func makeURLRequest(apiRequest: APIRequest) -> URLRequest {
        let urlString = "\(apiAccess.baseUrl)/apps/\(apiRequest.appId)/appStoreVersions"
        let url: URL = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }

    func execute(appId: String) async throws -> AppStoreVersionsResponse {
        let request = APIRequest(appId: appId)
        let urlRequest = makeURLRequest(apiRequest: request)
        let response: AppStoreVersionsResponse = try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
        return response
    }
}

enum APIError: Error {
    case api(ErrorResponse)
}
