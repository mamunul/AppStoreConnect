//
//  main.swift
//  AppstoreAutomation
//
//  Created by newone on 30/6/22.
//

import Foundation

let baseUrl = "https://api.appstoreconnect.apple.com/v1"

let secret =
    """
    -----BEGIN PRIVATE KEY-----
    sdfsdfsdfsdfretregggte63576rt349AwEHBHkwdwIBAQQgwqqzRCF7dcOxVZ7z
    kJsQ6vJsdfsdfsdfsdfsdfsdfsdfdsfsdfsdfsdfsdfsdfdsfsdfdsfXV+k3Xgvd
    2bVqYjrR7nETP0v6+IViakpP5WnOqm8Zfgfdgdfgsdfgsdfsdfdsfsdfsdfdsfdf
    i3/+3otK
    -----END PRIVATE KEY-----
    """
let issuerID = "3456d846-345-4545-345-4546456cbd6"
let apiKey = "dgdgert5"

let bundleId = "com.google.calc"

let api = APIAccess(secret: secret, issuerID: issuerID, apiKey: apiKey, bundleId: bundleId, baseUrl: baseUrl)
let facade = AppstoreConnectFacade()
facade.configure(apiAccess: api)

// testUploadScreenshot()
// testModifyAppStoreVersionLocalizedAPI()
// testModifyAppInfoVersionAPI()
// testGetApi(facade: facade)
// testCreateALocalizationAPI(facade: facade)
RunLoop.main.run()
