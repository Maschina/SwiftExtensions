//
//  SwiftUI+DoCatch.swift
//  SwiftExtensions
//
//  Created by Robert Hahn on 31.12.24.
//

import SwiftUI

@ViewBuilder public func DoCatch(
	@ViewBuilder try success: () throws -> some View,
	@ViewBuilder catch failure: (any Error) -> some View
) -> some View {
	switch Result(catching: success) {
		case .success(let success): success
		case .failure(let error): failure(error)
	}
}
