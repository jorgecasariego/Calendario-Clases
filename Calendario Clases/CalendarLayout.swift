//
//  CalendarLayout.swift
//  Calendario Clases
//
//  Created by Jorge Casariego on 23/2/16.
//  Copyright © 2016 Jorge Casariego. All rights reserved.
//

import UIKit
import Sapporo

let DaysPerWeek         : CGFloat = 6
let HoursPerDay         : CGFloat = 29
let HorizontalSpacing   : CGFloat = 10
let HeightPerHour       : CGFloat = 60
let DayHeaderHeight     : CGFloat = 30
let HourHeaderWidth     : CGFloat = 100

class CalendarLayout: SALayout {
    override func collectionViewContentSize() -> CGSize {
        let contentWidth = collectionView!.bounds.size.width
        let contentHeight = CGFloat(DayHeaderHeight + (HeightPerHour * HoursPerDay))
        
        //print("contentWidth: \(contentWidth)")
        //print("contentHeight: \(contentHeight)")
        
        return CGSizeMake(contentWidth, contentHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Cells
        let visibleIndexPaths = indexPathsOfItemsInRect(rect)
        layoutAttributes += visibleIndexPaths.flatMap {
            self.layoutAttributesForItemAtIndexPath($0)
        }
        
        // Supplementary views
        let dayHeaderViewIndexPaths = indexPathsOfDayHeaderViewsInRect(rect)
        layoutAttributes += dayHeaderViewIndexPaths.flatMap {
            self.layoutAttributesForSupplementaryViewOfKind(CalendarHeaderType.Day.rawValue, atIndexPath: $0)
        }
        
        let hourHeaderViewIndexPaths = indexPathsOfHourHeaderViewsInRect(rect)
        layoutAttributes += hourHeaderViewIndexPaths.flatMap {
            self.layoutAttributesForSupplementaryViewOfKind(CalendarHeaderType.Hour.rawValue, atIndexPath: $0)
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        if let event = (getCellModel(indexPath) as? CalendarEventCellModel)?.event {
            attributes.frame = frameForEvent(event)
        }
        return attributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        
        let totalWidth = collectionViewContentSize().width
        
        if elementKind == CalendarHeaderType.Day.rawValue {
            let availableWidth = totalWidth - HourHeaderWidth
            let widthPerDay = availableWidth / DaysPerWeek
            attributes.frame = CGRectMake(HourHeaderWidth + (widthPerDay * CGFloat(indexPath.item)), 0, widthPerDay, DayHeaderHeight)
            attributes.zIndex = -10
            
            //print("availableWidth \(availableWidth)")
            //print("widthPerDay \(widthPerDay)")
            //print("Rectangulo: x: \(HourHeaderWidth + (widthPerDay * CGFloat(indexPath.item))) y: \(0)")
            
        } else if elementKind == CalendarHeaderType.Hour.rawValue {
            attributes.frame = CGRectMake(0, DayHeaderHeight + HeightPerHour * CGFloat(indexPath.item), HourHeaderWidth, HeightPerHour)
            attributes.zIndex = -10
            
            //print("Rectangulo: x: \(0) y: \(DayHeaderHeight + HeightPerHour * CGFloat(indexPath.item))")
            //print("Ancho: \(HourHeaderWidth) Alto: \(DayHeaderHeight)")
            
        }
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}

extension CalendarLayout {
    func indexPathsOfEventsBetweenMinDayIndex(minDayIndex: Int, maxDayIndex: Int, minStartHour: Int, maxStartHour: Int) -> [NSIndexPath] {
        var indexPaths = [NSIndexPath]()
        
        if let cellmodels = getCellModels(0) as? [CalendarEventCellModel] {
            for i in 0..<cellmodels.count {
                let event = cellmodels[i].event
                if event.dia >= minDayIndex && event.dia <= maxDayIndex && event.horaInicio >= minStartHour && event.horaInicio <= maxStartHour {
                    let indexPath = NSIndexPath(forItem: i, inSection: 0)
                    indexPaths.append(indexPath)
                }
            }
        }
        return indexPaths
    }
    
    func indexPathsOfItemsInRect(rect: CGRect) -> [NSIndexPath] {
        let minVisibleDay = dayIndexFromXCoordinate(CGRectGetMinX(rect))
        let maxVisibleDay = dayIndexFromXCoordinate(CGRectGetMaxX(rect))
        let minVisibleHour = hourIndexFromYCoordinate(CGRectGetMinY(rect))
        let maxVisibleHour = hourIndexFromYCoordinate(CGRectGetMaxY(rect))
        
        return indexPathsOfEventsBetweenMinDayIndex(minVisibleDay, maxDayIndex: maxVisibleDay, minStartHour: minVisibleHour, maxStartHour: maxVisibleHour)
    }
    
    func dayIndexFromXCoordinate(xPosition: CGFloat) -> Int {
        let contentWidth = collectionViewContentSize().width - HourHeaderWidth
        let widthPerDay = contentWidth / DaysPerWeek
        
        let dayIndex = max(0, Int((xPosition - HourHeaderWidth) / widthPerDay))
        return dayIndex
    }
    
    func hourIndexFromYCoordinate(yPosition: CGFloat) -> Int {
        let hourIndex = max(0, Int((yPosition - DayHeaderHeight) / HeightPerHour))
        return hourIndex
    }
    
    func indexPathsOfDayHeaderViewsInRect(rect: CGRect) -> [NSIndexPath] {
        if CGRectGetMinY(rect) > DayHeaderHeight {
            return []
        }
        
        let minDayIndex = dayIndexFromXCoordinate(CGRectGetMinX(rect))
        let maxDayIndex = dayIndexFromXCoordinate(CGRectGetMaxX(rect))
        
        return (minDayIndex...maxDayIndex).map { index -> NSIndexPath in
            NSIndexPath(forItem: index, inSection: 0)
        }
    }
    
    func indexPathsOfHourHeaderViewsInRect(rect: CGRect) -> [NSIndexPath] {
        if CGRectGetMinX(rect) > HourHeaderWidth {
            return []
        }
        
        let minHourIndex = hourIndexFromYCoordinate(CGRectGetMinY(rect))
        let maxHourIndex = hourIndexFromYCoordinate(CGRectGetMaxY(rect))
        
        return (minHourIndex...maxHourIndex).map { index -> NSIndexPath in
            NSIndexPath(forItem: index, inSection: 0)
        }
    }
    
    func frameForEvent(event: CalendarEvent) -> CGRect {
        let totalWidth = collectionViewContentSize().width - HourHeaderWidth
        let widthPerDay = totalWidth / DaysPerWeek
        
        var frame = CGRectZero
        frame.origin.x = HourHeaderWidth + widthPerDay * CGFloat(event.dia)
        frame.origin.y = DayHeaderHeight + HeightPerHour * CGFloat(event.horaInicio)
        frame.size.width = widthPerDay
        frame.size.height = CGFloat(event.duracionEnHoras) * HeightPerHour
        
        print("totalWidth: \(totalWidth)")
        print("widthPerDay: \(widthPerDay)")
        print("event.dia: \(event.dia)")
        print("event.horaInicio: \(event.horaInicio)")
        print("event.duracionEnHoras: \(event.duracionEnHoras)")
        
        print("x: \(frame.origin.x)")
        print("y: \(frame.origin.y)")
        print("w: \(frame.size.width)")
        print("h: \(frame.size.height)")
        print("")
        
        //frame = CGRectInset(frame, HorizontalSpacing/2.0, 0)
        return frame
    }
}