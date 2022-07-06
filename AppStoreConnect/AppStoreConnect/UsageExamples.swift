//
//  UsageExamples.swift
//  AppstoreAutomation
//
//  Created by Mamunul Mazid on 2/7/22.
//

import Foundation

func testModifyAppInfoVersionAPI(facade: AppstoreConnectFacade) {
    Task {
        do {
            let appId = GetAppStoreVersionsCommand.APIRequest.quranApp.appId
            guard let appInfoId = try await facade.getAppInfoId(appId: appId) else { return }
            let localizations = try await facade.getAppInfoLocalizations(appInfoId: appInfoId)

            guard let first = localizations.first(where: { $0.attributes.locale == .es }) else { return }

            let attributes = AppInfoLocalizationAttributes(
                locale: .es,
                name: "skhdfjksh",
                privacyPolicyText: "sdfsdfs",
                privacyPolicyUrl: "http://www.jsfhl.com",
                subtitle: "safdsdfsdf",
                privacyChoicesUrl: "https://www.sjhfsl.org"
            )
            try await facade.modifyAppInfoLocalization(appInfoLocalizationId: first.id, attributes: attributes)
        } catch {
            print(error)
        }
    }
}

func testModifyAppStoreVersionLocalizedAPI(facade: AppstoreConnectFacade) {
    Task {
        do {
            let appId = GetAppStoreVersionsCommand.APIRequest.quranApp.appId
            guard let appStoreVersionId = try await facade.getAppStoreVesionId(platform: .IOS, appId: appId) else { return }
            guard let appStoreVersionLocalizaitonId = try await facade.getAppStoreLocalizedVersionId(appStoreVersionId: appStoreVersionId, localization: .fr) else { return }

            let attributes = try AppStoreVersionLocalizationAttributes(
                locale: .fr,
                description: "sdfsdfsdfsdfsdfsdfsdf sfsdf sfsdf sfdsdf",
                keywords: "key, word",
                marketingUrl: "http://www.marketing.com",
                promotionalText: "sdfsdfsdfsdf",
                supportUrl: "http://support.com"
            )
            try await facade.modifyAppStoreVersionLocalization(appStoreVersionLocalizaitonId: appStoreVersionLocalizaitonId, attributes: attributes)
        } catch {
            print(error)
        }
    }
}

func testGetApi(facade: AppstoreConnectFacade) {
    Task {
        do {
            let appId = GetAppStoreVersionsCommand.APIRequest.quranApp.appId
            guard let appInfoId = try await facade.getAppInfoId(appId: appId) else { return }
            _ = try await facade.getAppInfoLocalizations(appInfoId: appInfoId)
            guard let appPlatformId = try await facade.getAppStoreVesionId(platform: .IOS, appId: appId) else { return }
            guard let localizedVersionId = try await facade.getAppStoreLocalizedVersionId(appStoreVersionId: appPlatformId, localization: .en) else { return }
            guard let screenshotSetId = try await facade.getScreenshotSetId(displayType: .APP_IPHONE_55, appStoreLocalizedVersionId: localizedVersionId) else { return }
            _ = try await facade.getScreenshots(screenshotSetId: screenshotSetId)
            print("success")
        } catch {
            print(error)
        }
    }
}

func testCreateALocalizationAPI(facade: AppstoreConnectFacade) {
    Task {
        do {
            let appId = GetAppStoreVersionsCommand.APIRequest.quranApp.appId
            guard let appInfoId = try await facade.getAppInfoId(appId: appId) else { return }
            let attributes =
                AppInfoLocalizationAttributes(
                    locale: Localization.de,
                    name: "Quran in de-DE"
                )

            _ = try await facade.createAppInfoLocalization(appInfoId: appInfoId, attributes: attributes)

        } catch {
            print(error)
        }
    }
}

func testUploadScreenshot() {
    Task {
        do {
            let basePath = "Documents/Anonymous Appstore/ScreenshotsGeneration/NewScreenshots/iPhoneSEPlus/ja/MediaListView.png"
            let homeDirectory = FileManager.default.homeDirectoryForCurrentUser

            let folderUrl = homeDirectory.appendingPathComponent(basePath, isDirectory: false)
            let screenshot = Screenshot(url: folderUrl, displayType: .APP_IPHONE_55, locale: .ja)

            let appId = GetAppStoreVersionsCommand.APIRequest.quranApp.appId
            guard let appPlatformId = try await facade.getAppStoreVesionId(platform: .IOS, appId: appId) else { return }
            guard let localizedVersionId = try await facade.getAppStoreLocalizedVersionId(appStoreVersionId: appPlatformId, localization: .ja) else { return }
            var appScreenshotSetId = try await facade.getScreenshotSetId(displayType: .APP_IPHONE_55, appStoreLocalizedVersionId: localizedVersionId)

            if appScreenshotSetId == nil {
                appScreenshotSetId = try await facade.createScreenshotSet(appStoreVersionLocalizaitonId: localizedVersionId, screenshotDisplayType: .APP_IPHONE_55)
            }

            try await ScreenshotUploader().upload(appScreenshotSetId: appScreenshotSetId!, apiAccess: api, screenshot: screenshot)
            print("Success")
        } catch {
            print(error)
        }
    }
}
