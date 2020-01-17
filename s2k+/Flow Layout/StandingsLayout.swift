//
//  StandingsLayout.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-15.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

class StandingsLayout: UICollectionViewFlowLayout {

//    var barHeight: CGFloat {
//        let height = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//        return UINavigationController().navigationBar.frame.size.height + height
//    }
    
    var stickyRowsCount = 0 {
        didSet {
            invalidateLayout()
        }
    }

    var stickyColumnsCount = 0 {
        didSet {
            invalidateLayout()
        }
    }

    private var allAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var contentSize = CGSize.zero

    // MARK: - Collection view flow layout methods

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func prepare() {
        
        if collectionView!.numberOfSections == 1 { /* no data yet */
            return
        }
        setupAttributes()
        updateStickyItemsPositions()

        let lastItemFrame = allAttributes.last?.last?.frame ?? .zero
        contentSize = CGSize(width: lastItemFrame.maxX, height: lastItemFrame.maxY)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for rowAttrs in allAttributes {
            for itemAttrs in rowAttrs where rect.intersects(itemAttrs.frame) {
                layoutAttributes.append(itemAttrs)
            }
        }

        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

// MARK: - actual layout controls

    private func setupAttributes() {
        allAttributes = []

        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        for row in 0..<rowsCount {
            var rowAttrs: [UICollectionViewLayoutAttributes] = []
            xOffset = 0

            for col in 0..<columnsCount(in: row) {
                let itemSize = size(forRow: row, column: col)
                let indexPath = IndexPath(row: row, column: col)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral

                rowAttrs.append(attributes)

                xOffset += itemSize.width
            }

            yOffset += rowAttrs.last?.frame.height ?? 0.0
            allAttributes.append(rowAttrs)
        }
    }

    private func updateStickyItemsPositions() {
        for row in 0..<rowsCount {
            for col in 0..<columnsCount(in: row) {
                let attributes = allAttributes[row][col]

                if row < stickyRowsCount {
                    var frame = attributes.frame
                    frame.origin.y += collectionView!.contentOffset.y
                    attributes.frame = frame
                }

                if col < stickyColumnsCount {
                    var frame = attributes.frame
                    frame.origin.x += collectionView!.contentOffset.x
                    attributes.frame = frame
                }

                attributes.zIndex = zIndex(forRow: row, column: col)
            }
        }
    }

    private func zIndex(forRow row: Int, column col: Int) -> Int {
        if row < stickyRowsCount && col < stickyColumnsCount {
            return ZOrder.staticStickyItem
        } else if row < stickyRowsCount || col < stickyColumnsCount {
            return ZOrder.stickyItem
        } else {
            return ZOrder.commonItem
        }
    }

// MARK: - Sizing

    private var rowsCount: Int {
        return collectionView!.numberOfSections
    }

    private func columnsCount(in row: Int) -> Int {
        return collectionView!.numberOfItems(inSection: row)
    }

    private func size(forRow row: Int, column: Int) -> CGSize {
        var cellWidth = 0
        switch column {
        case 0:
            cellWidth = 200
        case 1:
            cellWidth = 50
        case 10:
            cellWidth = 130
        default:
            cellWidth = 45
        }
        return CGSize(width: cellWidth, height: 35)
    }
}

// MARK: - IndexPath

    private extension IndexPath {
        init(row: Int, column: Int) {
            self = IndexPath(item: column, section: row)
        }
    }

// MARK: - ZOrder

    private enum ZOrder {
        static let commonItem = 0
        static let stickyItem = 1
        static let staticStickyItem = 2
    }
