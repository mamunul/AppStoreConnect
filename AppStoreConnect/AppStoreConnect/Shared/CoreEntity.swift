//
//  CoreEntity.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

enum Localization: String, Codable {
    case en = "en-US"
    case it, ja, ko, fr = "fr-FR", de = "de-DE", ru, es = "es-ES", sv, nb = "no"
    case hongkong = "zh-HK"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
}

struct APIAccess {
    var secret: String
    var issuerID: String
    var apiKey: String
    var bundleId: String
    var baseUrl: String
}

struct DocumentLink: Codable {
    var `self`: String
}

struct ErrorResponse: Codable {
    struct Errors: Codable {
        /// (Required) A machine-readable code indicating the type of error. The code is a hierarchical value with levels of specificity separated by the '.' character. This value is parseable for programmatic   error handling in code.
        var code: String

        /// (Required) The HTTP status code of the error. This status code usually matches the response's status code; however, if the request produces multiple errors, these two codes may differ.
        var status: String

        /// The unique ID of a specific instance of an error, request, and response. Use this ID when providing feedback to or debugging issues with Apple.
        var id: String?

        /// (Required) A summary of the error. Do not use this field for programmatic error handling.
        var title: String

        /// (Required) A detailed explanation of the error. Do not use this field for programmatic error handling.
        var detail: String
    }

    var errors: [Errors]
}

enum ReleaseType: String, Codable {
    case MANUAL, AFTER_APPROVAL, SCHEDULED
}

enum Platform: String, Codable {
    case IOS, MAC_OS, TV_OS
}

enum AppStoreVersionState: String, Codable {
    case DEVELOPER_REMOVED_FROM_SALE, DEVELOPER_REJECTED, IN_REVIEW, INVALID_BINARY, METADATA_REJECTED,
         PENDING_APPLE_RELEASE, PENDING_CONTRACT, PENDING_DEVELOPER_RELEASE, PREPARE_FOR_SUBMISSION,
         PREORDER_READY_FOR_SALE, PROCESSING_FOR_APP_STORE, READY_FOR_SALE, REJECTED, REMOVED_FROM_SALE,
         WAITING_FOR_EXPORT_COMPLIANCE, WAITING_FOR_REVIEW, REPLACED_WITH_NEW_VERSION, ACCEPTED, READY_FOR_REVIEW
}

enum Method: String {
    case get = "GET", delete = "DELETE", post = "POST", patch = "PATCH"
}
