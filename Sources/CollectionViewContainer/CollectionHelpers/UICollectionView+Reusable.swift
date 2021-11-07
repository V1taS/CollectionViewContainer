//
//  UICollectionView+Reusable.swift
//
//  Created by Vitalii Sosin on 22.10.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func registerReusableCellWithNib<T: AppCollectionViewCell>(_ cellType: T.Type) {
		register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
	}

    func registerReusableCellWithClass<T: AppCollectionViewCell>(_ cellType: T.Type) {
		register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
	}

    func registerAnonimusReusableCellWithClass(_ anonimusCellType: AppCollectionViewCell.Type) {
		register(anonimusCellType, forCellWithReuseIdentifier: anonimusCellType.reuseIdentifier)
	}

    func dequeueReusableCellWithType<T: AppCollectionViewCell>(_ viewType: T.Type, indexPath: IndexPath) -> T {
		return dequeueReusableCell(withReuseIdentifier: viewType.reuseIdentifier, for: indexPath) as! T
	}

    func registerHeaderViewWithClass<T: AppCollectionReusableView>(_ viewType: T.Type) {
		self.register(
			viewType,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: viewType.reuseIdentifier
		)
	}

    func registerAnonimusHeaderViewWithClass(_ anonimusHeaderType: AppCollectionReusableView.Type) {
		self.register(
			anonimusHeaderType,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: anonimusHeaderType.reuseIdentifier
		)
	}

    func dequeueHeaderViewWithClass<T: AppCollectionReusableView>(_ viewType: T.Type, forIndexPath indexPath: IndexPath) -> T {
		return self.dequeueReusableSupplementaryView(
			ofKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: viewType.reuseIdentifier,
			for: indexPath
		) as! T
	}
}

