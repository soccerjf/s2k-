//
//  TeamCell.swift
//  s2k+
//
//  Created by John Freihaut on 2020-01-14.
//  Copyright © 2020 8th Line Software. All rights reserved.
//

import UIKit

@IBDesignable
class TeamCell: UICollectionViewCell {
    @IBOutlet weak var anyLabel: UILabel!
// Mark: style the table with rounded headings and borders
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func prepareForReuse() {
        
    }
    
    func setup() {
        self.layer.borderWidth = 0.15
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 3.0
    }
}
