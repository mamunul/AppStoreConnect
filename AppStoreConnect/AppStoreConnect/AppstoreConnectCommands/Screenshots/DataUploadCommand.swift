//
//  DataUploadCommand.swift
//  AppstoreAutomation
//
//  Created by newone on 4/7/22.
//

import Foundation

class DataUploadCommand {
    private let apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    func execute(upload: UploadOperation, data: Data) async throws {
        let url = URL(string: upload.url)!
        var urlRequest = URLRequest(url: url)

        upload.requestHeaders.forEach { header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
        }

        urlRequest.httpMethod = upload.method
        urlRequest.httpBody = data
        try await HTTPHandler().execute(urlRequest: urlRequest, access: apiAccess)
    }
}
