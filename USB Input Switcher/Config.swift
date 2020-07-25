//
//  Config.swift
//  USBInputSwitcher
//
//  Created by James Zaghini on 18/7/20.
//  Copyright © 2020 James Zaghini. All rights reserved.
//

import Foundation
import Yams

typealias USBDeviceName = String

struct Config: Decodable {
    let inputSourceNames: InputSourceNames
    let usbDeviceNames: [USBDeviceName]

    static func read() throws -> Config {
        let encodedYAML = try String(contentsOf: fileURL, encoding: .utf8)
        let decoder = YAMLDecoder()
        return try decoder.decode(Config.self, from: encodedYAML)
    }

    // MARK: - Private

    private static let filePath = ".usbinputswitcher/config.yaml"
    private static let baseURL = FileManager.default.homeDirectoryForCurrentUser
    private static let fileURL = baseURL.appendingPathComponent(filePath)
}
