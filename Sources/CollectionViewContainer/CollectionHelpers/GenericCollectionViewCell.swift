//
//  GenericCollectionViewCell.swift
//
//  Created by Vitalii Sosin on 22.10.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import UIKit
import Combine

public final class GenericCollectionViewCell<T: UIView>: UICollectionViewCell, ReusableView where T: GenericCellSubview {

	// MARK: - Public variables
	public let customSubview = T()
	public weak var reusableComponent: ReusableComponent?
	override public var isSelected: Bool {
		didSet {
			customSubview.setSelected(isSelected, animated: false)
		}
	}

	// MARK: - Internal variables
	var cancellable = Set<AnyCancellable>()

	// MARK: - Initialization
	public init() {
		super.init(frame: .zero)
		setup()
	}

	override public init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	// MARK: - Public func
	override public func prepareForReuse() {
		super.prepareForReuse()
		cancellable.forEach({ $0.cancel() })
		reusableComponent?.reuse()

		if let reuseView = customSubview as? ReusableComponent {
			reuseView.reuse()
		}
	}

	override public func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
		return customSubview.systemLayoutSizeFitting(targetSize)
	}

	// MARK: - Private func
	private func setup() {
		contentView.addSubview(customSubview)
		customSubview.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			customSubview.topAnchor.constraint(equalTo: topAnchor),
			customSubview.bottomAnchor.constraint(equalTo: bottomAnchor),
			customSubview.leadingAnchor.constraint(equalTo: leadingAnchor),
			customSubview.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
		customSubview.setSelected(isSelected, animated: false)
	}
}
