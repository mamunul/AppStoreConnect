//
//  AppstoreConnectFacade.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

class AppstoreConnectFacade {
    enum APIError: Error {
        case emptyData, configureAPIACcess
    }

    private var apiAccess: APIAccess?

    func configure(apiAccess: APIAccess) {
        self.apiAccess = apiAccess
    }

    func invalidateAPIAccess() {
    }

    func createScreenshotSet(appStoreVersionLocalizaitonId: String, screenshotDisplayType: DisplayType) async throws -> String {
        let apiAccess = try verifyAPIAcess()
        let createScreenshotSetCommand = CreateScreenshotSetCommand(apiAccess: apiAccess)
        let response = try await createScreenshotSetCommand.execute(
            appStoreVersionLocalizaitonId: appStoreVersionLocalizaitonId,
            displayType: screenshotDisplayType
        )

        return response.data.id
    }

    func modifyAppInfoLocalization(appInfoLocalizationId: String, attributes: AppInfoLocalizationAttributes) async throws {
        let apiAccess = try verifyAPIAcess()
        let modifyAppInfoLocalizationCommand = ModifyAppInfoLocalizationCommand(apiAccess: apiAccess)
        let response =
            try await modifyAppInfoLocalizationCommand.execute(
                appInfoLocalizationId: appInfoLocalizationId,
                attributes: attributes
            )
        print(response)
    }

    func modifyAppStoreVersionLocalization(
        appStoreVersionLocalizaitonId: String,
        attributes: AppStoreVersionLocalizationAttributes
    ) async throws {
        let apiAccess = try verifyAPIAcess()
        let modifyAppStoreVersionLocalizationCommand = ModifyAppStoreVersionLocalizationCommand(apiAccess: apiAccess)

        let response =
            try await modifyAppStoreVersionLocalizationCommand.execute(
                appStoreVersionLocalizaitonId: appStoreVersionLocalizaitonId,
                attributes: attributes
            )
        print(response)
    }

    func createAppStoreVersionLocalizaiton(
        appStoreVersionId: String,
        attributes: AppStoreVersionLocalizationAttributes
    ) async throws -> String {
        let apiAccess = try verifyAPIAcess()
        let createAppStoreVersionLocalizationCommand = CreateAppStoreVersionLocalizationCommand(apiAccess: apiAccess)
        let response =
            try await createAppStoreVersionLocalizationCommand.execute(
                appStoreVersionId: appStoreVersionId,
                attributes: attributes
            )
        print(response)
        return response.data.id
    }

    func createAppInfoLocalization(appInfoId: String, attributes: AppInfoLocalizationAttributes) async throws -> String {
        let apiAccess = try verifyAPIAcess()
        let createAppInfoLocalizationCommand = CreateAppInfoLocalizationCommand(apiAccess: apiAccess)
        let response =
            try await createAppInfoLocalizationCommand.execute(
                appInfoId: appInfoId,
                attributes: attributes
            )
        print(response)

        return response.data.id
    }

    func getAppInfoLocalizations(appInfoId: String) async throws -> [AppInfoLocalization] {
        let apiAccess = try verifyAPIAcess()
        let getAppInfoLocalizationsCommand = GetAppInfoLocalizationsCommand(apiAccess: apiAccess)
        let response = try await getAppInfoLocalizationsCommand.execute(appInfoId: appInfoId)

        return response.data
    }

    func getScreenshots(screenshotSetId: String) async throws -> [AppScreenshot] {
        let apiAccess = try verifyAPIAcess()
        let getScreenshotCommand = GetScreenshotCommand(apiAccess: apiAccess)
        let response = try await getScreenshotCommand.execute(screenshotSetId: screenshotSetId)
        return response.data
    }

    func getScreenshotSets(appStoreLocalizedVersionId: String) async throws -> [AppScreenshotSet] {
        let apiAccess = try verifyAPIAcess()
        let getScreenshotSetsCommand = GetScreenshotSetsCommand(apiAccess: apiAccess)
        let response =
            try await getScreenshotSetsCommand.execute(
                appStoreLocalizedVersionId: appStoreLocalizedVersionId
            )

        return response.data
    }

    func getScreenshotSetId(displayType: DisplayType, appStoreLocalizedVersionId: String) async throws -> String? {
        let response = try await getScreenshotSets(appStoreLocalizedVersionId: appStoreLocalizedVersionId)
        let screenshotSetId = response.first(where: { $0.attributes.screenshotDisplayType == displayType })?.id

        return screenshotSetId
    }

    func getAppstoreVersions(appId: String) async throws -> [AppStoreVersion] {
        let apiAccess = try verifyAPIAcess()
        let getAppStoreVersionsCommand = GetAppStoreVersionsCommand(apiAccess: apiAccess)
        let response = try await getAppStoreVersionsCommand.execute(appId: appId)
        return response.data
    }

    func getAppStoreVesionId(platform: Platform, appId: String) async throws -> String? {
        let response = try await getAppstoreVersions(appId: appId)
        let appPlatformId = response.first(where: { $0.attributes.platform == platform })?.id
        return appPlatformId
    }

    func getAppStoreVersionLocalizations(appStoreVersionId: String) async throws ->
        [AppStoreVersionLocalization] {
        let apiAccess = try verifyAPIAcess()
        let getAppStoreVersionLocalizationsCommand = GetAppStoreVersionLocalizationsCommand(apiAccess: apiAccess)
        let response =
            try await getAppStoreVersionLocalizationsCommand.execute(
                appStoreVersionId: appStoreVersionId
            )

        return response.data
    }

    func getAppStoreLocalizedVersionId(appStoreVersionId: String, localization: Localization) async throws -> String? {
        let localizations = try await getAppStoreVersionLocalizations(appStoreVersionId: appStoreVersionId)
        let localizedVersionId = localizations.first(where: { $0.attributes.locale == localization })?.id
        return localizedVersionId
    }

    private func verifyAPIAcess() throws -> APIAccess {
        guard let apiAccess = apiAccess else {
            throw APIError.configureAPIACcess
        }

        return apiAccess
    }

    func getAppInfoId(appId: String) async throws -> String? {
        let apiAccess = try verifyAPIAcess()
        let getAppInfoCommand = GetAppInfoCommand(apiAccess: apiAccess)
        let response = try await getAppInfoCommand.execute(appId: appId)

        let appInfoId = response.data.first?.id
        return appInfoId
    }

    deinit {
        invalidateAPIAccess()
    }
}
