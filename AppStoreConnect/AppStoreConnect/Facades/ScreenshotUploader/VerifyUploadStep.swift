//
//  VerifyUploadState.swift
//  AppstoreAutomation
//
//  Created by newone on 4/7/22.
//

import Foundation

class VerifyUploadStep: UploadCommandStep {
    var failedStep: CancelUploadStep?
    func execute(uploader: ScreenshotUploader) async throws {
        uploader.setStep(step: nil)
    }
}
