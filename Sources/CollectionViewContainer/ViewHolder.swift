//
//  ViewHolder.swift
//
//  Created by Vitalii Sosin on 22.10.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol ViewHolder {
	associatedtype ViewType
	/// This variable returns a root view.
	/// - Returns: A root `view`.
	var rootView: ViewType { get }
}

extension ViewHolder where Self: UIViewController {
	var rootView: ViewType {
		guard let view = view as? ViewType else {
			fatalError("View type (\(type(of: view))) does not match with ViewType (\(ViewType.self))")
		}
		return view
	}
}
