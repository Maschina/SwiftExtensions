//
//  File.swift
//  
//
//  Created by Robert Hahn on 23.10.23.
//

import AppKit

extension NSImage {
	public convenience init?(systemSymbolName: String) {
		self.init(systemSymbolName: systemSymbolName, accessibilityDescription: nil)
	}
}
