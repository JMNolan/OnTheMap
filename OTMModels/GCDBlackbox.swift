//
//  GCDBlackbox.swift
//  On The Map
//
//  Created by John Nolan on 4/11/18.
//  Copyright © 2018 John Nolan. All rights reserved.
//

import Foundation

//use to update view after making visual changes in code
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
