//
//  File.swift
//  
//
//  Created by Robert Hahn on 22.10.23.
//

import AppKit

extension NSMenuItem {
	public convenience init(title string: String) {
		self.init(title: string, action: nil, keyEquivalent: "")
	}
	
	public convenience init(title string: String, action selector: Selector?) {
		self.init(title: string, action: selector, keyEquivalent: "")
	}
}

extension NSMenu {
	public func addItem(withTitle string: String) {
		self.addItem(withTitle: string, action: nil as Selector?, keyEquivalent: "")
	}
	
	public func addItem(withTitle string: String, action selector: Selector?, target: AnyObject? = nil) {
		self.addItem(withTitle: string, action: selector, keyEquivalent: "")
		self.items.last?.target = target
	}
	
	public func addItem(withTitle string: String, closure: ((NSMenuItem) -> Void)?, keyEquivalent: String = "") {
		self.addItem(ActionMenuItem(title: string, closure: closure, keyEquivalent: keyEquivalent))
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
		closure: ((NSMenuItem) -> Void)?,
		keyEquivalent: String = ""
	) {
		super.init(title: title, action: #selector(onClick), keyEquivalent: keyEquivalent)
		self.closure = closure
		self.target = self
	}
	
	public convenience init(
		title: String,
		closure: ((NSMenuItem) -> Void)?,
		keyEquivalent: String = "",
		image: NSImage? 
	) {
		self.init(title: title, closure: closure, keyEquivalent: keyEquivalent)
		self.image = image
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
