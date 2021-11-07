//
//  CollectionViewDataSource.swift
//
//  Created by Vitalii Sosin on 22.10.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol CollectionViewDataSourceContainerDelegate: AnyObject {
	/// This function returns the index of the section selected from the datasource.
	///
	/// ```
	/// delegate?.startSection(forDataSource: self)
	/// ```
	///
	/// - Parameter dataSource: CollectionViewDataSource.
	/// - Returns: A index `section`.
	func startSection(forDataSource dataSource: CollectionViewDataSource) -> Int
	/// This function returns the internal CollectionView.
	///
	/// ```
	/// delegate?.getCollectionView()
	/// ```
	///
	/// - Returns: A internal `CollectionView`.
	func getCollectionView() -> UICollectionView?
	/// This function return CollectionViewContainer.
	///
	/// ```
	/// getContainer()
	/// ```
	///
	/// - Returns: `CollectionViewContainer`.
	func getContainer() -> CollectionViewContainer
}

protocol CollectionViewDataSource: AnyObject {
	/// The object that acts as the delegate of the collection view.
	///
	/// ```
	/// weak var delegate: CollectionViewDataSourceContainerDelegate? { get set }
	/// ```
	///
	var delegate: CollectionViewDataSourceContainerDelegate? { get set }
	/// A Boolean value that indicates whether the collection is enabled.
	///
	/// ```
	/// isEnabled = true
	/// ```
	///
	/// - Returns: `Bool`.
	var isEnabled: Bool { get }
	/// Variable that contains the cell array for the CollectionView.
	var cellsForRegistration: [AppCollectionViewCell.Type]? { get }
	/// Variable that contains headers cell array for the CollectionView.
	var headersForRegistration: [AppCollectionReusableView.Type]? { get }
	/// The number of sections displayed by the collection view.
	var numberOfSections: Int { get }
	/// Fetches the count of items in the specified section.
	///
	/// - Parameter inSection: The index of the section for which you want a count of the items..
	/// - Returns: The number of items in the specified `section`.
	func numberOfItems(inSection section: Int) -> Int
	/// This function returns the index of the current section.
	///
	/// ```
	/// getSection()
	/// ```
	/// - Returns: A index `section`.
	func getSection() -> Int?
	/// Asks your data source object for the cell that corresponds to the specified item in the collection view.
	///
	/// ```
	/// Your implementation of this method is responsible for creating, configuring, and returning the appropriate cell for the given item. You do this by calling the dequeueReusableCell(withReuseIdentifier:for:) method of the collection view and passing the reuse identifier that corresponds to the cell type you want. That method always returns a valid cell object. Upon receiving the cell, you should set any properties that correspond to the data of the corresponding item, perform any additional needed configuration, and return the cell.
	/// You do not need to set the location of the cell inside the collection view’s bounds. The collection view sets the location of each cell automatically using the layout attributes provided by its layout object.
	/// If isPrefetchingEnabled on the collection view is set to true then this method is called in advance of the cell appearing. Use the collectionView(_:willDisplay:forItemAt:) delegate method to make any changes to the appearance of the cell to reflect its visual state such as selection.
	///This method must always return a valid view object.
	/// ```
	///
	/// - Parameter collectionView: The collection view requesting this information.
	/// - Parameter indexPath: The index path that specifies the location of the item.
	/// - Returns: A configured cell object. You must not return nil from this `method`.
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	/// Tells the delegate that the item at the specified index path was selected.
	///
	/// ```
	/// The collection view calls this method when the user successfully selects an item in the collection view. It does not call this method when you programmatically set the selection.
	/// ```
	///
	/// - Parameter collectionView: The collection view object that is notifying you of the selection change.
	/// - Parameter indexPath:The index path of the cell that was selected.
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	/// Tells the delegate that the specified cell was removed from the collection view.
	///
	/// ```
	/// Use this method to detect when a cell is removed from a collection view, as opposed to monitoring the view itself to see when it disappears.
	/// ```
	///
	/// - Parameter collectionView: The collection view object that removed the cell.
	/// - Parameter cell: The cell object that was removed.
	/// - Parameter indexPath: The index path of the data item that the cell represented.
	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
	/// Asks your data source object to provide a supplementary view to display in the collection view.
	///
	/// ```
	/// Your implementation of this method is responsible for creating, configuring, and returning the appropriate supplementary view that is being requested. You do this by calling the dequeueReusableSupplementaryView(ofKind:withReuseIdentifier:for:) method of the collection view and passing the information that corresponds to the view you want. That method always returns a valid view object. Upon receiving the view, you should set any properties that correspond to the data you want to display, perform any additional needed configuration, and return the view.
	/// You do not need to set the location of the supplementary view inside the collection view’s bounds. The collection view sets the location of each view using the layout attributes provided by its layout object.
	/// This method must always return a valid view object. If you do not want a supplementary view in a particular case, your layout object should not create the attributes for that view. Alternatively, you can hide views by setting the isHidden property of the corresponding attributes to true or set the alpha property of the attributes to 0. To hide header and footer views in a flow layout, you can also set the width and height of those views to 0.
	/// ```
	///
	/// - Parameter collectionView: The collection view requesting this information.
	/// - Parameter kind: The kind of supplementary view to provide. The value of this string is defined by the layout object that supports the supplementary view.
	/// - Parameter indexPath: The index path that specifies the location of the new supplementary view.
	/// - Returns: A configured supplementary view object. You must not return nil from this `method`.
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
	/// Asks the delegate for the size of the header view in the specified section.
	///
	/// ```
	/// If you do not implement this method, the flow layout uses the value in its headerReferenceSize property to set the size of the header.
	/// During layout, only the size that corresponds to the appropriate scrolling direction is used. For example, for the vertical scrolling direction, the layout object uses the height value returned by your method. (In that instance, the width of the header would be set to the width of the collection view.) If the size in the appropriate scrolling dimension is 0, no header is added.
	/// ```
	///
	/// - Parameter collectionView: The collection view object displaying the flow layout.
	/// - Parameter collectionViewLayout: The layout object requesting the information.
	/// - Parameter section: The index of the section whose header size is being requested.
	/// - Returns: The size of the header. If you return a value of size (0, 0), no header is added.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize
	/// Asks the delegate for the size of the specified item’s cell.
	///
	/// ```
	/// If you do not implement this method, the flow layout uses the values in its itemSize property to set the size of items instead. Your implementation of this method can return a fixed set of sizes or dynamically adjust the sizes based on the cell’s content.
	/// The flow layout does not crop a cell’s bounds to make it fit into the grid. Therefore, the values you return must allow for the item to be displayed fully in the collection view. For example, in a vertically scrolling grid, the width of a single item must not exceed the width of the collection view (minus any section insets) itself. However, in the scrolling direction, items can be larger than the collection view because the remaining content can always be scrolled into view.
	/// ```
	///
	/// - Parameter collectionView: The collection view object displaying the flow layout.
	/// - Parameter collectionViewLayout: The layout object requesting the information.
	/// - Parameter indexPath: The index path of the item.
	/// - Returns: The width and height of the specified item. Both values must be greater than 0.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize
	/// Asks the delegate for the spacing between successive rows or columns of a section.
	///
	/// ```
	/// If you do not implement this method, the flow layout uses the value in its minimumLineSpacing property to set the space between lines instead. Your implementation of this method can return a fixed value or return different spacing values for each section.
	/// For a vertically scrolling grid, this value represents the minimum spacing between successive rows. For a horizontally scrolling grid, this value represents the minimum spacing between successive columns. This spacing is not applied to the space between the header and the first line or between the last line and the footer.
	/// ```
	///
	/// - Parameter collectionView: The collection view object displaying the flow layout.
	/// - Parameter collectionViewLayout: The layout object requesting the information.
	/// - Parameter section: The index number of the section whose line spacing is needed.
	/// - Returns: The minimum space (measured in points) to apply between successive lines in a section.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat
	/// Asks the delegate for the spacing between successive items in the rows or columns of a section.
	///
	/// ```
	/// If you do not implement this method, the flow layout uses the value in its minimumInteritemSpacing property to set the space between items instead. Your implementation of this method can return a fixed value or return different spacing values for each section.
	/// For a vertically scrolling grid, this value represents the minimum spacing between items in the same row. For a horizontally scrolling grid, this value represents the minimum spacing between items in the same column. This spacing is used to compute how many items can fit in a single line, but after the number of items is determined, the actual spacing may possibly be adjusted upward.
	/// ```
	///
	/// - Parameter collectionView: The collection view object displaying the flow layout.
	/// - Parameter collectionViewLayout: The layout object requesting the information.
	/// - Parameter section: The index number of the section whose inter-item spacing is needed.
	/// - Returns: The minimum space (measured in points) to apply between successive items in the lines of a section.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumInteritemSpacingForSectionAt section: Int
	) -> CGFloat
	/// Asks the delegate for the margins to apply to content in the specified section.
	///
	/// ```
	/// If you do not implement this method, the flow layout uses the value in its sectionInset property to set the margins instead. Your implementation of this method can return a fixed set of margin sizes or return different margin sizes for each section.
	/// Section insets are margins applied only to the items in the section. They represent the distance between the header view and the first line of items and between the last line of items and the footer view. They also indicate the spacing on either side of a single line of items. They do not affect the size of the headers or footers themselves.
	/// ```
	///
	/// - Parameter collectionView: The collection view object displaying the flow layout.
	/// - Parameter collectionViewLayout: The layout object requesting the information.
	/// - Parameter section: The index number of the section whose insets are needed.
	/// - Returns: The margins to apply to items in the section.
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets
	/// Tells the delegate when the user scrolls the content view within the receiver.
	///
	/// ```
	/// The delegate typically implements this method to obtain the change in content offset from scrollView and draw the affected portion of the content view.
	/// ```
	///
	/// - Parameter scrollView: The scroll-view object in which the scrolling occurred.
	func scrollViewDidScroll(_ scrollView: UIScrollView)
}

// MARK: - Default implementation
extension CollectionViewDataSource {
	var headersForRegistration: [AppCollectionReusableView.Type]? {
		return []
	}
	
	var collectionView: UICollectionView {
		guard let collectionView = delegate?.getCollectionView() else {
			assertionFailure("No collection view")
			return UICollectionView(
				frame: .zero,
				collectionViewLayout: UICollectionViewFlowLayout()
			)
		}
		return collectionView
	}
	
	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		return .zero
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {
		return UICollectionReusableView()
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		referenceSizeForHeaderInSection section: Int
	) -> CGSize {
		return .zero
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAt section: Int
	) -> CGFloat {
		return .zero
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumInteritemSpacingForSectionAt section: Int
	) -> CGFloat {
		return .zero
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {}
	
	func getSection() -> Int? {
		guard let startSection = delegate?.startSection(forDataSource: self) else {
			assertionFailure("No start section")
			return nil
		}
		return startSection
	}
	
	func reloadCurrentSectionIfLoaded() {
		guard isEnabled else {
			return
		}
		
		if let startSection = delegate?.startSection(forDataSource: self), let collectionView = delegate?.getCollectionView() {
			var reloadArray: [Int] = []
			for section in .zero..<numberOfSections {
				reloadArray.append(section + startSection)
			}
			collectionView.reloadSections(IndexSet(reloadArray))
		}
	}
}
