//
//  CGRect+Helpers.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 28/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

public enum CGRectAlignment {
    case verticallyCentralized(addendum: CGFloat)
    case horizontallyCentralized(addendum: CGFloat)
    case top(addendum: CGFloat)
    case bottom(addendum: CGFloat)
    case left(addendum: CGFloat)
    case right(addendum: CGFloat)
}

extension CGSize {
    func limitedTo(_ limitSize: CGSize) -> CGSize{
        return self
            .with(width: self.width > limitSize.width ? limitSize.width : self.width)
            .with(height: self.height > limitSize.height ? limitSize.height : self.height)
    }
    
    func with(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: self.height)
    }
    
    func with(height: CGFloat) -> CGSize {
        return CGSize(width: self.width, height: height)
    }
}

extension CGRect {
    
    func insetBy(left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) -> CGRect {
        return self
            .with(x: self.origin.x + left)
            .with(width: self.size.width - right)
            .with(y: self.origin.y + top)
            .with(height: self.size.height - bottom)
    }
    
    func aligned(_ alignments: [CGRectAlignment], in rect: CGRect) -> CGRect {
        var aligned = self
        for align in alignments {
            switch align {
            case let .verticallyCentralized(addendum):
                aligned = aligned.with(y: rect.origin.y + ((rect.height/2) - (aligned.height/2)) + addendum)
            case let .horizontallyCentralized(addendum):
                aligned = aligned.with(x: rect.origin.x + ((rect.width/2)-(aligned.width/2)) + addendum)
            case let .top(addendum):
                aligned = aligned.with(y: rect.origin.y + addendum)
            case let .bottom(addendum):
                aligned = aligned.with(y: rect.maxY - aligned.height + addendum)
            case let .left(addendum):
                aligned = aligned.with(x: rect.origin.x + addendum)
            case let .right(addendum):
                aligned = aligned.with(x: rect.maxX - aligned.width + addendum)
            }
        }
        return aligned
    }
    
    func with(size delta: CGSize) -> CGRect {
        return self.with(width: delta.width).with(height: delta.height)
    }
    
    func with(point delta: CGPoint) -> CGRect {
        return self.with(x: delta.x).with(y: delta.y)
    }
    
    func with(x delta: CGFloat) -> CGRect {
        return CGRect(x: delta, y: self.origin.y, width: self.size.width, height: self.size.height)
    }
    
    func with(y delta: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: delta, width: self.size.width, height: self.size.height)
    }
    
    func with(width delta: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: delta, height: self.size.height)
    }
    
    func with(height delta: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: self.size.width, height: delta)
    }
}
