//
//  ReusableComponent.swift
//
//  Created by Vitalii Sosin on 22.10.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import Foundation

public protocol ReusableComponent: AnyObject {
	/// This function reuses components.
	func reuse()
}
