//
//  CollectionViewContainer.swift
//
//  Created by Vitalii Sosin on 22.10.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import UIKit

open class CollectionViewContainer: CollectionViewDataSource, CollectionViewDataSourceContainerDelegate {

    // MARK: - Internal variables
    weak public var delegate: CollectionViewDataSourceContainerDelegate?
    public let dataSources: [CollectionViewDataSource]
    public var numberOfSections: Int = .zero
    public var isEnabled = true

    public var internalCollectionView: UICollectionView? {
        didSet {
            if let collectionView = internalCollectionView {
                registerCellsFor(collectionView: collectionView)
                registerHeadersFor(collectionView: collectionView)
            }
        }
    }

    public var cellsForRegistration: [AppCollectionViewCell.Type]? {
        return dataSources.reduce([]) { (result, dataSource) -> [AppCollectionViewCell.Type] in
            result + (dataSource.cellsForRegistration ?? [])
        }
    }

    public var headersForRegistration: [AppCollectionReusableView.Type]? {
        return dataSources.reduce([]) { (result, dataSource) -> [AppCollectionReusableView.Type] in
            result + (dataSource.headersForRegistration ?? [])
        }
    }

    // MARK: - Private variables
    private var sections: [Range<Int>: CollectionViewDataSource] = [:]
    private var previousSections: [Range<Int>: CollectionViewDataSource] = [:]

    // MARK: - Initialization
    public init(dataSources: [CollectionViewDataSource]) {
        self.dataSources = dataSources
        reload(shouldReloadCollection: false)
    }


    // MARK: - Internal funcs
    public func getCollectionView() -> UICollectionView? {
        return internalCollectionView
    }

    public func getContainer() -> CollectionViewContainer {
        return self
    }

    public func reload(shouldReloadCollection: Bool) {
        var currentSection: Int = .zero
        previousSections = sections
        sections = [:]

        for source in dataSources {
            source.delegate = self
            let startIndex = currentSection
            let endIndex = currentSection + source.numberOfSections
            if source.numberOfSections != .zero {
                sections[startIndex ..< endIndex] = source
                currentSection += source.numberOfSections
            }
        }

        numberOfSections = currentSection

        if shouldReloadCollection {
            internalCollectionView?.reloadData()
        }
    }

    public func numberOfItems(inSection section: Int) -> Int {
        let pair = sections.first { (range, _) -> Bool in
            range.contains(section)
        }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Data source is not provided for section:\(section)")
            return .zero
        }

        let newSection = section - currentDataSourcePair.key.lowerBound
        return currentDataSourcePair.value.numberOfItems(inSection: newSection)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pair = sections.first { (range, _) -> Bool in
            range.contains(indexPath.section)
        }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Data source is not provided for section:\(indexPath.section)")
            return UICollectionViewCell()
        }

        let newIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - currentDataSourcePair.key.lowerBound)
        return currentDataSourcePair.value.collectionView(collectionView, cellForItemAt: newIndexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let pair = sections.merging(previousSections) { _, previousDataSource in
            previousDataSource
        }
            .first { (range, _) -> Bool in
                range.contains(indexPath.section)
            }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Data source is not provided for section:\(indexPath.section)")
            return
        }

        let newIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - currentDataSourcePair.key.lowerBound)
        currentDataSourcePair.value.collectionView(collectionView, didEndDisplaying: cell, forItemAt: newIndexPath)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let pair = sections.first { (range, _) -> Bool in
            range.contains(indexPath.section)
        }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Data source is not provided for section:\(indexPath.section)")
            return UICollectionReusableView()
        }

        let newIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - currentDataSourcePair.key.lowerBound)
        return currentDataSourcePair.value.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: newIndexPath)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let pair = sections.first { (range, _) -> Bool in
            range.contains(section)
        }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Data source is not provided for section:\(section)")
            return .zero
        }

        if currentDataSourcePair.value.headersForRegistration?.count == .zero {
            return .zero
        }

        let newSection = section - currentDataSourcePair.key.lowerBound
        return currentDataSourcePair.value.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: newSection)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pair = sections.first { (range, _) -> Bool in
            range.contains(indexPath.section)
        }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Data source is not provided for section:\(indexPath.section)")
            return
        }

        let newIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - currentDataSourcePair.key.lowerBound)
        currentDataSourcePair.value.collectionView(collectionView, didSelectItemAt: newIndexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let pair = sections.first { (range, _) -> Bool in
            range.contains(indexPath.section)
        }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Data source is not provided for section:\(indexPath.section)")
            return .zero
        }

        let newIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - currentDataSourcePair.key.lowerBound)
        return currentDataSourcePair.value.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: newIndexPath)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        let pair = sections.first { (range, _) -> Bool in
            range.contains(section)
        }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Data source is not provided for section:\(section)")
            return .zero
        }
        let newSection = section - currentDataSourcePair.key.lowerBound
        return currentDataSourcePair.value.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: newSection)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        let pair = sections.first { (range, _) -> Bool in
            range.contains(section)
        }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Data source is not provided for section:\(section)")
            return .zero
        }
        let newSection = section - currentDataSourcePair.key.lowerBound
        return currentDataSourcePair.value.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: newSection)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let pair = sections.first { (range, _) -> Bool in
            range.contains(section)
        }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Data source is not provided for section:\(section)")
            return .zero
        }
        let newSection = section - currentDataSourcePair.key.lowerBound
        return currentDataSourcePair.value.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: newSection)
    }

    public func startSection(forDataSource: CollectionViewDataSource) -> Int {
        let pair = sections.first { (_, dataSource: CollectionViewDataSource) -> Bool in
            dataSource === forDataSource
        }

        guard let currentDataSourcePair = pair else {
            assertionFailure("Section is not provided for data source:\(forDataSource)")
            return .zero
        }

        return currentDataSourcePair.key.lowerBound
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dataSources.forEach {
            $0.scrollViewDidScroll(scrollView)
        }
    }

    // MARK: - Private funcs
    private func registerCellsFor(collectionView: UICollectionView) {
        for cellType in cellsForRegistration ?? [] {
            collectionView.registerAnonimusReusableCellWithClass(cellType)
        }
    }

    private func registerHeadersFor(collectionView: UICollectionView) {
        for headerType in headersForRegistration ?? [] {
            collectionView.registerAnonimusHeaderViewWithClass(headerType)
        }
    }
}
