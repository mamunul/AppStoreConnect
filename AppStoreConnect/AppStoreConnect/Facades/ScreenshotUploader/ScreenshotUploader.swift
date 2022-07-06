//
//  ScreenshotUploader2.swift
//  AppstoreAutomation
//
//  Created by newone on 4/7/22.
//

import Foundation
import CryptoKit

struct Screenshot {
    let url: URL
    let displayType: DisplayType
    let locale: Localization
}

enum UploadError: Error {
    case uploadFailed
}

protocol UploadCommandStep {
    func execute(uploader: ScreenshotUploader) async throws
}

class ScreenshotUploader {
    private var currentStep: UploadCommandStep?
    func upload(appScreenshotSetId: String, apiAccess: APIAccess, screenshot: Screenshot) async throws {
        let data = try Data(contentsOf: screenshot.url)
        let fileName = screenshot.url.lastPathComponent
        let md5Checksum = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()

        let commitStep = CommitUploadStep(checksum: md5Checksum, apiAccess: apiAccess)
        let requestUploadStep = RequestUploadStep(
            appScreenshotSetId: appScreenshotSetId,
            fileName: fileName,
            fileSize: data.count,
            apiAccess: apiAccess
        )

        let dataUploadStep = DataUploadStep(assetData: data, apiAccess: apiAccess)
        dataUploadStep.nextStep = commitStep
        requestUploadStep.nextStep = dataUploadStep
        currentStep = requestUploadStep

        while currentStep != nil {
            try await currentStep?.execute(uploader: self)
        }
    }

    func setStep(step: UploadCommandStep?) {
        currentStep = step
    }
}
