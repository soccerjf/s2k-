//
//  StandingsLayout.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-15.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit


class StandingsLayout: UICollectionViewLayout {

    var barHeight: CGFloat {
        let height = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return UINavigationController().navigationBar.frame.size.height + height
    }
    
    let cellHeight: CGFloat = 30
    var cellWidth: CGFloat = 40
    var cellPadding: CGFloat = 0
    var runningWidth: CGFloat = 0
    var cellAttributesDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    
    override var collectionViewContentSize: CGSize {
        get {
            return contentSize
        }
    }
    
    override func prepare() {
        
        if collectionView!.numberOfSections == 1 { /* no data yet */
            return
        }

        collectionView?.bounces = false
        for section in 0 ..< collectionView!.numberOfSections{
            runningWidth = 0
            let sectionAttributes = NSMutableArray()
            for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
                let cellIndexPath = IndexPath(item: item, section: section)
                switch item {
                case 0:
                    cellWidth = 200
                    cellPadding = 0
                case 1:
                    cellWidth = 50
                    cellPadding = 0
                case 10:
                    cellWidth = 130
                    cellPadding = 0
                default:
                    cellWidth = 45
                    cellPadding = 0
                }
                let xPos = runningWidth + cellPadding
                let yPos = CGFloat(section) * cellHeight
                runningWidth += cellWidth
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndexPath)
                cellAttributes.frame = CGRect(x: xPos, y: yPos, width: cellWidth, height: cellHeight)
                // We create the UICollectionViewLayoutAttributes object for each item and add it to our array.
                // We will use this later in layoutAttributesForItemAtIndexPath:
                if section == 0 && item == 0 {
                    cellAttributes.zIndex = 1024  // Set this value for the first item (Sec0Row0) in order to make it visible over first column and first row
                } else if section == 0 || item == 0 {
                    cellAttributes.zIndex = 1023  // Set this value for the first row or section in order to set visible over the rest of the items
                }
                if section == (collectionView!.numberOfSections)  && item == 0 {
                    cellAttributes.zIndex = 1
                    cellAttributes.frame = CGRect(x: 1, y: yPos, width: 200, height: cellHeight)
                    cellAttributesDictionary[cellIndexPath] = cellAttributes
                }
                if section != (collectionView!.numberOfSections)  {
                    cellAttributesDictionary[cellIndexPath] = cellAttributes
                }
                if item == 0 {
                    var frame = cellAttributes.frame
                    frame.origin.x = collectionView!.contentOffset.x
                    cellAttributes.frame = frame  // Stick to the left
                }
                sectionAttributes.add(cellAttributes)
            }
        }
        let contentHeight = CGFloat(collectionView!.numberOfSections) * cellHeight
        contentSize = CGSize(width: runningWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        for cellAttrs in cellAttributesDictionary.values {
            if rect.intersects(cellAttrs.frame) {
                attributesInRect.append(cellAttrs)
            }
        }
        return attributesInRect
    }
    
    // reloads prepare layout when scrolling -- to stick the headers
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
