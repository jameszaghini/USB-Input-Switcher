// Taken from https://stackoverflow.com/questions/39003986/usb-connection-delegate-on-swift

import IOKit.usb.IOUSBLib

protocol USBWatcherDelegate: class {
    func deviceAdded(_ device: io_object_t)
    func deviceRemoved(_ device: io_object_t)
}

final class USBWatcher {
    fileprivate weak var delegate: USBWatcherDelegate?
    private let notificationPort = IONotificationPortCreate(kIOMasterPortDefault)
    fileprivate var addedIterator: io_iterator_t = 0
    fileprivate var removedIterator: io_iterator_t = 0
    private let query = IOServiceMatching(kIOUSBDeviceClassName)

    private lazy var opaqueSelf = Unmanaged.passUnretained(self).toOpaque()

    init(delegate: USBWatcherDelegate) {

        self.delegate = delegate

        observeAddedUSBDevices()
        observeRemovedUSBDevices()

        CFRunLoopAddSource(CFRunLoopGetMain(),
                           IONotificationPortGetRunLoopSource(notificationPort).takeUnretainedValue(),
                           .commonModes)
    }

    deinit {
        IOObjectRelease(addedIterator)
        IOObjectRelease(removedIterator)
        IONotificationPortDestroy(notificationPort)
    }

    // MARK: - Private

    private func observeAddedUSBDevices() {
        IOServiceAddMatchingNotification(notificationPort,
                                         kIOMatchedNotification,
                                         query,
                                         handleNotification,
                                         opaqueSelf,
                                         &addedIterator)

        handleNotification(instance: opaqueSelf, addedIterator)
    }

    private func observeRemovedUSBDevices() {
        IOServiceAddMatchingNotification(notificationPort,
                                         kIOTerminatedNotification,
                                         query,
                                         handleNotification,
                                         opaqueSelf,
                                         &removedIterator)

        handleNotification(instance: opaqueSelf, removedIterator)
    }
}

private func handleNotification(instance: UnsafeMutableRawPointer?, _ iterator: io_iterator_t) {

    let watcher = Unmanaged<USBWatcher>.fromOpaque(instance!).takeUnretainedValue()
    let handler: ((io_iterator_t) -> Void)?

    switch iterator {
    case watcher.addedIterator: handler = watcher.delegate?.deviceAdded
    case watcher.removedIterator: handler = watcher.delegate?.deviceRemoved
    default: assertionFailure("received unexpected IOIterator"); return
    }

    while case let device = IOIteratorNext(iterator), device != IO_OBJECT_NULL {
        handler?(device)
        IOObjectRelease(device)
    }
}

extension io_object_t {

    func name() -> String? {
        let buf = UnsafeMutablePointer<io_name_t>.allocate(capacity: 1)
        defer { buf.deallocate() }
        return buf.withMemoryRebound(to: CChar.self, capacity: MemoryLayout<io_name_t>.size) {
            if IORegistryEntryGetName(self, $0) == KERN_SUCCESS {
                return String(cString: $0)
            }
            return nil
        }
    }
}
