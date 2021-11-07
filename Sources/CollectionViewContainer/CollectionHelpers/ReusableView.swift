//
//  ReusableView.swift
//
//  Created by Vitalii Sosin on 22.10.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import UIKit

public typealias AppCollectionViewCell = UICollectionViewCell & ReusableView
public typealias AppCollectionReusableView = UICollectionReusableView & ReusableView

public protocol ReusableView {
	/// A string that identifies the purpose of the view.
	///
	/// ```
	/// The collection view identifies and queues reusable views using their reuse identifiers. The collection view sets this value when it first creates the view, and the value cannot be changed later. When your data source is prompted to provide a given view, it can use the reuse identifier to dequeue a view of the appropriate type.
	/// ```
	static var reuseIdentifier: String { get }
	/// The nib file associated with the cell.
	static var nib: UINib { get }
	/// A base type that represents a directory that conforms to one of the bundle layouts.
	static var bundle: Bundle? { get }
}

// MARK: - Default implementation
extension ReusableView {
	public static var reuseIdentifier: String {
		if let component = String(describing: self).split(separator: ".").last {
			return String(component)
		} else {
			return ""
		}
	}

	public static var nib: UINib {
		return UINib(nibName: reuseIdentifier, bundle: bundle)
	}

	public static var bundle: Bundle? {
		return nil
	}
}
