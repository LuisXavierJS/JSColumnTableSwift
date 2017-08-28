//
//  CGRect+Helpers.swift
//  ColumnTableView
//
//  Created by Jorge Luis on 28/08/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

enum CGRectAlignment {
    case verticallyCentralized
    case horizontallyCentralized
}

extension CGRect {
    func insetBy(lX: CGFloat = 0, rX: CGFloat = 0, tY: CGFloat = 0, bY: CGFloat = 0) -> CGRect {
        return self
            .with(x: self.origin.x + lX)
            .with(width: self.size.width - rX)
            .with(y: self.origin.y + tY)
            .with(height: self.size.height - bY)
    }
    func aligned(_ alignments: [CGRectAlignment], in rect: CGRect) -> CGRect {
        var aligned = self
        for align in alignments {
            switch align {
            case .verticallyCentralized:
                aligned = aligned.with(x: (rect.width/2) - (aligned.width/2))
            break
            case .horizontallyCentralized:
                aligned = aligned.with(y: (rect.height/2)-(aligned.height/2))
            break
            }
        }
        return aligned
    }
    func with(size delta: CGSize) -> CGRect {
        return self.with(width: delta.width).with(height: delta.height)
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
