//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Andrew Ardire on 8/16/17.
//  Copyright © 2017 Andrew F Ardire. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
