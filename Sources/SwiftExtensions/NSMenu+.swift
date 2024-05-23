//
//  File.swift
//
//
//  Created by Robert Hahn on 22.10.23.
//

import AppKit

extension NSMenuItem {
	public convenience init(title string: String, image: NSImage? = nil) {
		self.init(title: string, action: nil, keyEquivalent: "")
		if let image {
			self.image = image
		}
	}

	public convenience init(title string: String, image: NSImage? = nil, action selector: Selector?)
	{
		self.init(title: string, action: selector, keyEquivalent: "")
		if let image {
			self.image = image
		}
	}
}

extension NSMenu {
	public func addItem(
		withTitle string: String,
		image: NSImage? = nil
	) {
		let item = NSMenuItem(title: string, action: nil, keyEquivalent: "")
		item.isEnabled = false
		if let image {
			item.image = image
		}
		self.addItem(item)
	}

	public func addItem(
		withTitle string: String,
		image: NSImage? = nil,
		action selector: Selector?,
		target: AnyObject? = nil
	) {
		let item = NSMenuItem(title: string, action: selector, keyEquivalent: "")
		if let image {
			item.image = image
		}
		item.target = target
		self.addItem(item)
	}

	public func addItem(
		withTitle string: String,
		image: NSImage? = nil,
		state: Bool? = nil,
		keyEquivalent: String = "",
		closure action: @escaping (NSMenuItem) -> Void
	) {
		self.addItem(ActionMenuItem(title: string, image: image, state: state, closure: action))
	}

	public func addItem(
		withTitle string: String,
		image: NSImage? = nil,
		state: Bool? = nil,
		keyEquivalent: String = "",
		closure action: @escaping () -> Void
	) {
		self.addItem(
			ActionMenuItem(title: string, image: image, state: state, closure: { _ in action() })
		)
	}

	public func addSeparator() {
		self.addItem(NSMenuItem.separator())
	}
}

// MARK: ActionMenuItem

public class ActionMenuItem: NSMenuItem {
	private var closure: ((NSMenuItem) -> Void)?

	public init(
		title: String,
		keyEquivalent: String = "",
		closure: ((NSMenuItem) -> Void)?
	) {
		super.init(title: title, action: #selector(onClick), keyEquivalent: keyEquivalent)
		self.closure = closure
		self.target = self
	}

	public convenience init(
		title: String,
		image: NSImage? = nil,
		state: Bool? = nil,
		keyEquivalent: String = "",
		closure: ((NSMenuItem) -> Void)?
	) {
		self.init(title: title, keyEquivalent: keyEquivalent, closure: closure)
		if let image {
			self.image = image
		}
		if let state {
			self.state = state ? .on : .off
		}
	}

	required init(
		coder: NSCoder
	) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc func onClick(sender: NSMenuItem) {
		closure?(sender)
	}
}
