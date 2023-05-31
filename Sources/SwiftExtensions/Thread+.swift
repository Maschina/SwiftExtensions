// Copyright (C) 2023 Robert Hahn. All Rights Reserved.

import Foundation

extension Thread {
	public static func printCurrent() {
		print("\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
	}
}
