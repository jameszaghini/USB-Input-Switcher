//
//  InputSourceNames.swift
//  USBInputSwitcher
//
//  Created by James Zaghini on 25/7/20.
//  Copyright © 2020 James Zaghini. All rights reserved.
//

import Foundation

typealias InputSourceName = String

struct InputSourceNames: Decodable {
    let connected: InputSourceName
    let disconnected: InputSourceName
}
