//
//  CancelUploadState.swift
//  AppstoreAutomation
//
//  Created by newone on 4/7/22.
//

import Foundation

class CancelUploadStep: UploadCommandStep {
    var reservationId: String?
    private var apiAccess: APIAccess

    init(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    private func deleteReservation() async throws {
        guard let reservationId = reservationId else {
            return
        }
        let deleteCommand = DeleteAppScreenshotsCommand(apiAccess: apiAccess)
        try await deleteCommand.execute(appScreenshotId: reservationId)
    }

    func execute(uploader: ScreenshotUploader) async throws {
        try await deleteReservation()
        uploader.setStep(step: nil)
    }
}
