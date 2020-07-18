//
//  InputSource.swift
//  USB Input Switcher
//
//  Created by James Zaghini on 17/7/20.
//  Copyright © 2020 James Zaghini. All rights reserved.
//

import Carbon

struct InputSource {

    private let source: TISInputSource

    init(_ source: TISInputSource) {
        self.source = source
    }

    var name: String {
        let ptr = TISGetInputSourceProperty(source, kTISPropertyLocalizedName)
        return unsafeBitCast(ptr, to: CFString.self) as String
    }

    static func all() -> [InputSource] {
        let inputSources = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
        // swiftlint:disable:next force_cast
        return (inputSources as! [TISInputSource]).map { InputSource($0) }
    }

    func activate() {
        TISSelectInputSource(self.source)
    }
}
