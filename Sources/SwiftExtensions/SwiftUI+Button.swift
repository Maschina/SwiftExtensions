//
//  SwiftUI+Button.swift
//  SwiftExtensions
//
//  Created by Robert Hahn on 11.11.24.
//

import SwiftUI

extension Button where Label == Image {
	public init(systemImage: String, action: sending @escaping @MainActor () -> Void) {
		self.init {
			action()
		} label: {
			Image(systemName: systemImage)
		}
	}
}

extension Button where Label == Text {
	public init(_ titleKey: LocalizedStringKey, action: sending @escaping @MainActor () async -> Void) {
		self.init(titleKey) {
			Task {
				await action()
			}
		}
	}
	
	public init(_ titleKey: LocalizedStringKey, role: ButtonRole?, action: sending @escaping @MainActor () async -> Void) {
		self.init(titleKey, role: role) {
			Task {
				await action()
			}
		}
	}
}

extension Button {
	public init(action: sending @escaping @MainActor () async -> Void, @ViewBuilder label: () -> Label) {
		self.init {
			Task {
				await action()
			}
		} label: {
			label()
		}
	}
}

extension Button where Label == SwiftUI.Label<Text, Image> {
	public init(_ titleKey: LocalizedStringKey, systemImage: String, action: sending @escaping @MainActor () async -> Void) {
		self.init(titleKey, systemImage: systemImage) {
			Task {
				await action()
			}
		}
	}
}

#Preview {
	@MainActor
	func printOnMain(_ message: String) {
		print(message)
	}
	
	return Button(systemImage: "info.circle") {
		printOnMain("hello")
	}
	.padding()
}
