//
//  Notebook+Extensions.swift
//  Mooskine
//
//  Created by Kittikawin Sontinarakul on 15/4/2563 BE.
//  Copyright © 2563 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Notebook {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
