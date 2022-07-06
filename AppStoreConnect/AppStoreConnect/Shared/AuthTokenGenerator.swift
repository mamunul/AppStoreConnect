//
//  ConnectAuthorization.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import CoreMedia
import CryptoKit
import Foundation
import SwiftJWT

struct JWTHeader: Codable {
    ///  Encryption Algorithm ES256; All JWTs for App Store Connect API must be signed with ES256 encryption
    var alg: String
    ///  Key Identifier; Your private key ID from App Store Connect; for example 2X9R4HXF34.
    var kid: String
    ///  Token Type
    var typ: String
}

/// this is the payload of token generation
struct JWTPayload: Claims {
    ///  Issuer ID;Your issuer ID from the API Keys page in App Store Connect; for example, 57246542-96fe-1a63-e053-0824d011072a.
    var iss: String
    ///  Issued At Time;The token’s creation time, in UNIX epoch time; for example, 1528407600.
    var iat: Date
    ///  Expiration Time;The token’s expiration time in Unix epoch time. Tokens that expire more than 20 minutes into the future are not valid except for resources listed in Determine the Appropriate Token Lifetime.
    var exp: Date
    ///  Audience;appstoreconnect-v1
    var aud: String
    ///  Token Scope;A list of operations you want App Store Connect to allow for this token; for example, GET /v1/apps/123. (Optional)
//    var scope: [String]
    ///     Your app’s bundle ID (Ex: “com.example.testbundleid2021”)
    var bid: String
}

/// Go to https://appstoreconnect.apple.com/access/api and create your own key. This is also the page to find the private key ID and the issuer ID.
/// Download the private key and open it in a text editor. Remove the line breaks from the private key string and copy the contents over to the private key parameter.
class AuthTokenGenerator {
    // https://developer.apple.com/documentation/appstoreconnectapi/generating_tokens_for_api_requests

    private func createJWTPayload(issuerID: String, bundleId: String) -> JWTPayload {
        let intervalInSeconds: TimeInterval = 60
        let issuedTime = Date()
        let expiredTime = Date(timeIntervalSinceNow: intervalInSeconds)

        let payload =
            JWTPayload(
                iss: issuerID,
                iat: issuedTime,
                exp: expiredTime,
                aud: "appstoreconnect-v1",
                bid: bundleId
            )
        return payload
    }

    /// This method will generate token for accessing app store connect api
    ///
    /// - Parameter secret: Private key taken from app store connect website
    func generateToken(apiAccess: APIAccess) throws -> String {
        let payload = createJWTPayload(issuerID: apiAccess.issuerID, bundleId: apiAccess.bundleId)

        let privateKey = apiAccess.secret.data(using: .utf8)!
        let jwtSigner = JWTSigner.es256(privateKey: privateKey)

        let myHeader = Header(kid: apiAccess.apiKey)
        var jwt = JWT(header: myHeader, claims: payload)
        let signedJWT = try jwt.sign(using: jwtSigner)
        return signedJWT
    }
}
