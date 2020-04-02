//
//  TextPresets.swift
//  Vocable AAC
//
//  Created by Patrick Gatewood on 2/11/20.
//  Copyright © 2020 WillowTree. All rights reserved.
//

import Foundation

// Top level JSON object
struct PresetData: Codable {

    let schemaVersion: Int
    let categories: [PresetCategory]
    let phrases: [PresetPhrase]

}

struct PresetCategory: Codable {

    let id: String
    let localizedName: [String: String]
    let hidden: Bool

}

struct PresetPhrase: Codable {

    let id: String
    let categoryIds: [String]
    let localizedUtterance: [String: String]

}

struct TextPresets {

    static let savedSayingsIdentifier = NSLocalizedString("My Sayings", comment: "Category: My Sayings")

    static let numPadDescription = NSLocalizedString("123", comment: "Category: Num Pad")

    static var numPadCategory: [PhraseViewModel] {
        var numbers = (1...9).map { PhraseViewModel(unpersistedPhrase: "\($0)")}
        numbers.append(PhraseViewModel(unpersistedPhrase: "0"))
        let responses = [PhraseViewModel(unpersistedPhrase: NSLocalizedString("No", comment: "'No' num pad response")),
                         PhraseViewModel(unpersistedPhrase: NSLocalizedString("Yes", comment: "'Yes' num pad response"))]
        return numbers + responses
    }

    static var presets: PresetData? {
        if let json = dataFromBundle() {
            do {
                return try JSONDecoder().decode(PresetData.self, from: json)
            } catch {
                assertionFailure("Error decoding PresetData: \(error)")
            }
        }

        return nil
    }

    // TODO: Add this to Legends after handling savedSayingsIdentifier and numPadDescription
//    static var presetsByCategory: [PresetCategory] {
//        var result: [PresetCategory] = []
//
//        if let json = jsonFromBundle() {
//            do {
//                result = try JSONDecoder().decode([PresetCategory].self, from: json)
//            } catch {
//                print(error)
//            }
//        }
//
//        //result.append(PresetCategory(localizedUtterance: TextPresets.savedSayingsIdentifier, presets: []))
//        //result.append(PresetCategory(localizedUtterance: TextPresets.numPadDescription, presets: []))
//
//        return result
//    }

    private static func dataFromBundle() -> Data? {
        if let path = Bundle.main.path(forResource: "textpresets", ofType: "json") {
            do {
                return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch {
                assertionFailure("🚨 Cannot parse \(path)")
                return nil
            }
        }

        return nil
    }

}
