//
//  GenericCellSubview.swift
//
//  Created by Vitalii Sosin on 22.10.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import Foundation

public protocol GenericCellSubview {
	init()
	/// The selection state of the cell.
	///
	/// ```
	/// This property manages the selection state of the cell only. The default value of this property is false, which indicates an unselected state.
	///
	/// You typically do not set the value of this property directly. Changing the value of this property programmatically does not change the appearance of the cell. The preferred way to select the cell and highlight it is to use the selection methods of the collection view object.
	/// ```
	///
	/// - Parameter selected: A Boolean value that determines state of the cell.
	/// - Parameter animated: A Boolean value that determines state of the cell.
	func setSelected(_ selected: Bool, animated: Bool)
	/// The highlight state of the cell.
	///
	/// ```
	/// This property manages the highlight state of the cell only. The default value of this property is NO, which indicates that the cell is not in a highlighted state.
	///
	/// You typically do not set the value of this property directly. Instead, the preferred way to select the cell and highlight it is to use the selection methods of the collection view object.
	/// ```
	///
	/// - Parameter selected: A Boolean value that determines state of the cell.
	/// - Parameter animated: A Boolean value that determines state of the cell.
	func setHighlighted(_ highlighted: Bool, animated: Bool)
}

// MARK: - Default implementation
extension GenericCellSubview {
	public func setSelected(_ selected: Bool, animated: Bool) {}
	public func setHighlighted(_ highlighted: Bool, animated: Bool) {}
}
