//
//  CollectionViewController.swift
//
//  Created by Vitalii Sosin on 22.10.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import UIKit

public protocol CollectionViewHolderProtocol {
    /// An object that manages an ordered collection of data items and presents them using customizable layouts.
    var collectionView: UICollectionView { get }
}

open class CollectionViewController<ViewType: CollectionViewHolderProtocol>: UIViewController,
                                                                             UICollectionViewDataSource,
                                                                             UICollectionViewDelegate,
                                                                             UICollectionViewDelegateFlowLayout,
                                                                             ViewHolder {
    public typealias ViewType = ViewType

    // MARK: - Public variables
    public var container: CollectionViewContainer

    // MARK: - Initialization
    public init(container: CollectionViewContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal funcs
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        rootView.collectionView.refreshControl?.endRefreshing()
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return container.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return container.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        container.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        container.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return container.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: section)
    }

    // MARK: - UICollectionViewDelegate
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        container.numberOfSections
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        container.collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        return container.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        container.collectionView(collectionView, didSelectItemAt: indexPath)
    }

    // MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        container.numberOfItems(inSection: section)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return container.collectionView(collectionView, cellForItemAt: indexPath)
    }
}
