//
//  CollectionViewController.swift
//
//  Created by Vitalii Sosin on 22.10.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol CollectionViewHolderProtocol {
	/// An object that manages an ordered collection of data items and presents them using customizable layouts.
	var collectionView: UICollectionView { get }
}

class CollectionViewController<ViewType: CollectionViewHolderProtocol>: UIViewController,
																		UICollectionViewDataSource,
																		UICollectionViewDelegate,
																		UICollectionViewDelegateFlowLayout,
																		ViewHolder {
	typealias ViewType = ViewType
	
	// MARK: - Internal variables
	var container: CollectionViewContainer
	
	// MARK: - Initialization
	init(container: CollectionViewContainer) {
		self.container = container
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Internal funcs
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		rootView.collectionView.refreshControl?.endRefreshing()
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		container.scrollViewDidScroll(scrollView)
	}
	
	// MARK: - Private funcs
	private func setup() {
		container.internalCollectionView = rootView.collectionView
		rootView.collectionView.dataSource = self
		rootView.collectionView.delegate = self
		rootView.collectionView.backgroundColor = UIColor.clear
        rootView.collectionView.contentInsetAdjustmentBehavior = .never
		guard rootView.collectionView.collectionViewLayout is UICollectionViewFlowLayout else {
			assertionFailure("Wrong layout")
			return
		}
	}
	
	// MARK: - UICollectionViewDelegateFlowLayout
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		return container.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return container.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		container.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumInteritemSpacingForSectionAt section: Int
	) -> CGFloat {
		container.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		return container.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
	}
	
	// MARK: - UICollectionViewDelegate
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		container.numberOfSections
	}
	
	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		container.collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		return container.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		container.collectionView(collectionView, didSelectItemAt: indexPath)
	}
	
	// MARK: - UICollectionViewDataSource
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		container.numberOfItems(inSection: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return container.collectionView(collectionView, cellForItemAt: indexPath)
	}
}
