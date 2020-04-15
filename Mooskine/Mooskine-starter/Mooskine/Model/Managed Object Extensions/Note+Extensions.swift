//
//  Note+Extensions.swift
//  Mooskine
//
//  Created by Kittikawin Sontinarakul on 15/4/2563 BE.
//  Copyright © 2563 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Note {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
