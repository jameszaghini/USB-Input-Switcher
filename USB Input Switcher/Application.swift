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
            usbWatcher = USBWatcher(delegate: self)
        } catch {
            exit(0)
        }
    }

    // MARK: - USBWatcherDelegate

    func deviceAdded(_ device: io_object_t) {
        guard let deviceName = device.name() else { return }

        let targetDevice = findTargetDevice(in: config.connected, with: deviceName)

        if let targetDevice = targetDevice {
            foundConnected(targetDevice)
        }
    }

    func deviceRemoved(_ device: io_object_t) {
        guard let deviceName = device.name() else { return }

        let targetDevice = findTargetDevice(in: config.connected, with: deviceName)

        if targetDevice != nil {
            disconnected()
        }
    }

    // MARK: - Private

    private var usbWatcher: USBWatcher!
    private let config: Config

    private func findTargetDevice(in connected: [USBInputPair], with deviceName: String) -> USBInputPair? {
        connected.first { $0.usb == deviceName }
    }

    private func foundConnected(_ connectedSetting: USBInputPair) {
        let sources = InputSource.all()
        let source = sources.first { $0.name == connectedSetting.inputSourceName }
        source?.activate()
    }

    private func disconnected() {
        let sources = InputSource.all()
        let source = sources.first { $0.name == config.disconnected }
        source?.activate()
    }
}
