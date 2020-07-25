//
//  Application.swift
//  USB Input Switcher
//
//  Created by James Zaghini on 18/7/20.
//  Copyright © 2020 James Zaghini. All rights reserved.
//

import Foundation

final class Application: USBWatcherDelegate {

    init() {
        print("⌨️ USB Input Switcher started ⌨️")

        do {
            config = try Config.read()
        } catch {
            print("Couldn't parse config. Error: ", error)
            exit(0)
        }

        usbWatcher = USBWatcher(delegate: self)
    }

    // MARK: - USBWatcherDelegate

    func deviceAdded(_ device: io_object_t) {
        guard let deviceName = device.name() else { return }

        let targetDevice = findTargetDevice(in: config.usbDeviceNames, with: deviceName)

        if let targetDevice = targetDevice {
            foundConnected(targetDevice)
        }
    }

    func deviceRemoved(_ device: io_object_t) {
        guard let deviceName = device.name() else { return }

        let targetDevice = findTargetDevice(in: config.usbDeviceNames, with: deviceName)

        if targetDevice != nil {
            disconnected()
        }
    }

    // MARK: - Private

    private var usbWatcher: USBWatcher!
    private let config: Config

    private func findTargetDevice(in connected: [USBDeviceName], with deviceName: String) -> USBDeviceName? {
        connected.first { $0.caseInsensitiveCompare(deviceName) == .orderedSame }
    }

    private func foundConnected(_ connectedSetting: USBDeviceName) {
        activateSourceWithName(config.inputSourceNames.connected)
    }

    private func disconnected() {
        activateSourceWithName(config.inputSourceNames.disconnected)
    }

    private func activateSourceWithName(_ name: String) {
        let sources = InputSource.all()
        let source = sources.first { $0.name.caseInsensitiveCompare(name) == .orderedSame }
        source?.activate()
    }
}
