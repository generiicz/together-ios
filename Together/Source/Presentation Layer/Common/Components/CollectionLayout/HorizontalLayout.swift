//
//  HorizontalLayout.swift
//  Together
//
//  Created by Андрей Цай on 05.09.16.
//  Copyright © 2016 Андрей Цай. All rights reserved.
//

import UIKit

enum HorizontalPagingType {
    case truePaging
    case flexiblePaging
}

class HorizontalLayout: UICollectionViewLayout {
    
    var itemHeight: CGFloat = 10
    var itemWidth: CGFloat = 10
    var horizontalPadding: CGFloat = 8
    var verticalPadding: CGFloat = 8
    var horizontalMargin: CGFloat = 8
    var verticalMargin: CGFloat = 8
    var previousScrollPoint: CGPoint = CGPoint(x: 0, y: 0)
    var previousScrollRow: Int = 0
    var previousScrollSection: Int = 0
    var previousVelocitySignX: CGFloat = 0
    var pagingType: HorizontalPagingType = .flexiblePaging
    
    func setupLayout(
        _ itemHeight: CGFloat,
        itemWidth: CGFloat,
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat,
        horizontalMargin: CGFloat,
        verticalMargin: CGFloat,
        pagingType: HorizontalPagingType
        ) {
        self.itemHeight = itemHeight
        self.itemWidth = itemWidth
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.horizontalMargin = horizontalMargin
        self.verticalMargin = verticalMargin
        self.pagingType = pagingType
    }
    
    func calcItemFrame(_ section: Int, row: Int) -> CGRect {
        var res: CGRect!
        let floatSection = CGFloat(section)
        let floatRow = CGFloat(row)
        let yPos = self.verticalMargin + floatSection*self.verticalPadding + floatSection*self.itemHeight
        let xPos = self.horizontalMargin + floatRow*self.horizontalPadding + floatRow*self.itemWidth
        res = CGRect(x: xPos, y: yPos, width: self.itemWidth, height: self.itemHeight)
        return res
    }
    
    func createAttrForIndexPath (_ indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let res: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        res.bounds = CGRect(x: 0, y: 0, width: self.itemWidth, height: self.itemHeight)
        res.frame = self.calcItemFrame((indexPath as NSIndexPath).section, row: (indexPath as NSIndexPath).row)
        return res
    }
    
    override var collectionViewContentSize : CGSize {
        var res: CGSize = CGSize.zero
        let sections: Int = (self.collectionView?.numberOfSections)!
        var maxItems: Int = 0
        for section in 0...sections-1 {
            let itemsPerSection = (self.collectionView?.numberOfItems(inSection: section))!
            if itemsPerSection > maxItems {
                maxItems = itemsPerSection
            }
        }
        let floatSections = CGFloat(sections)
        let vSize = floatSections*itemHeight + verticalPadding*(floatSections-1) + verticalMargin*2
        let floatMaxItems = CGFloat(maxItems)
        let hSize = floatMaxItems*itemWidth + horizontalPadding*(floatMaxItems-1) + horizontalMargin*2
        res = CGSize(width: hSize, height: vSize)
        return res
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //print(rect)
        var res: [UICollectionViewLayoutAttributes]? = [UICollectionViewLayoutAttributes]()
        let numOfSections = (collectionView?.numberOfSections)!-1
        guard numOfSections >= 0 else { return res }
        for section in 0...numOfSections {
            let rowsInSection = (collectionView?.numberOfItems(inSection: section))!-1
            if rowsInSection >= 0 {
                let floatSection = CGFloat(section)
                let sectionY = self.verticalMargin + floatSection*self.verticalPadding + floatSection*self.itemHeight
                if sectionY > rect.origin.y + rect.size.height {
                    break
                }
                for row in 0...rowsInSection {
                    let frame = self.calcItemFrame(section, row: row)
                    if frame.origin.x > rect.origin.x + rect.size.width {
                        break
                    } else {
                        res?.append(self.createAttrForIndexPath(IndexPath(row: row, section: section)))
                    }
                }
            }
        }
        if res?.count == 0 {
            return nil
        }
        return res
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let res: UICollectionViewLayoutAttributes? = self.createAttrForIndexPath(indexPath)
        
        return res
    }
    
    func calcFlexiblePage ( _ proposedContentOffset: CGPoint,
                            velocity: CGPoint) -> CGPoint {
        var res: CGPoint = CGPoint.zero
        let screenX = (self.collectionView?.bounds.width)!
        let cSize = self.collectionViewContentSize
        var velocitySignX: CGFloat = velocity.x < 0 ? -1 : 1
        if velocity.x == 0 {
            velocitySignX = proposedContentOffset.x < previousScrollPoint.x ? -1 : 1
        }
        let destSection = 0 //(self.collectionView?.numberOfSections())! - 1
        let midWidth = self.itemWidth + self.horizontalPadding
        let numRows = CGFloat((self.collectionView?.numberOfItems(inSection: destSection))! - 1)
        let rawRow = proposedContentOffset.x > self.horizontalMargin ? (proposedContentOffset.x - self.horizontalMargin) / midWidth : 0.1
        
        let floorRawRow = floor(rawRow)
        let ceilRawRow = ceil(rawRow)
        let deltaX = (abs(proposedContentOffset.x - self.horizontalMargin) - midWidth*floorRawRow)
        let rowCorrection = midWidth - deltaX > midWidth / 3 ? 1 * velocitySignX : 0
        
        var metaRow = velocitySignX < 0 ? ceilRawRow + rowCorrection : floorRawRow + rowCorrection
        if ceilRawRow >= numRows && velocitySignX > 0 {
            metaRow = numRows
        } else if floorRawRow <= 0 && velocitySignX < 0 {
            metaRow = 0.0
        }
        let destRow = Int(metaRow)
        
        let destFrame = self.calcItemFrame(destSection, row: destRow)
        if destFrame.origin.x > cSize.width - screenX {
            res.x = cSize.width - screenX
        } else {
            res.x = destFrame.origin.x
        }
        res.y = destFrame.origin.y - self.verticalMargin
        self.previousScrollPoint = res
        self.previousScrollRow = destRow
        self.previousVelocitySignX = velocitySignX
        return res
    }
    
    func calcTruePage (_ proposedContentOffset: CGPoint,
                       velocity: CGPoint) -> CGPoint {
        //print(proposedContentOffset)
        //print(velocity.x)
        var res: CGPoint = CGPoint.zero
        let screenX = (self.collectionView?.bounds.width)!
        let cSize = self.collectionViewContentSize
        let alphaVelocity:CGFloat = 1.25
        //guard velocity.x != 0 else { return previousScrollPoint }
        var velocitySignX: Int = velocity.x < 0 ? -1 : 1
        var velocityX: CGFloat = abs(velocity.x)
        let midWidth = self.itemWidth + self.horizontalPadding
        let shiftX = abs(proposedContentOffset.x - self.horizontalMargin - CGFloat(previousScrollRow) * midWidth)
        if velocity.x == 0 {
            velocitySignX = proposedContentOffset.x < previousScrollPoint.x ? -1 : 1
            velocityX = shiftX > midWidth * 0.4 ? 0 : -alphaVelocity
        }
        let destSection = 0 //(self.collectionView?.numberOfSections())! - 1
        let deltaX = Int(floor((velocityX + alphaVelocity) / alphaVelocity))
        //print(velocitySignX)
        //print(deltaX)
        var destRow = self.previousScrollRow + velocitySignX * deltaX
        if destRow < 0 {
            destRow = 0
        }
        let maxRowNum = (self.collectionView?.numberOfItems(inSection: destSection))! - 1
        if destRow > maxRowNum {
            destRow = maxRowNum
        }
        let destFrame = self.calcItemFrame(destSection, row: destRow)
        if destFrame.origin.x > cSize.width - screenX {
            res.x = cSize.width - screenX
        } else {
            res.x = destFrame.origin.x
        }
        res.y = destFrame.origin.y - self.verticalMargin
        self.previousScrollPoint = res
        self.previousScrollRow = destRow
        return res
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                                              withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var res: CGPoint = CGPoint.zero
        switch self.pagingType {
        case .flexiblePaging:
            res = self.calcFlexiblePage(proposedContentOffset, velocity: velocity)
        case .truePaging:
            res = self.calcTruePage(proposedContentOffset, velocity: velocity)
        }
        return res
    }
}
