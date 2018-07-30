//
//  Thread+Extension.swift
//  Foody2
//
//  Created by Sebastian Strus on 2018-07-30.
//  Copyright © 2018 Sebastian Strus. All rights reserved.
//

import Foundation

extension Thread {
    class func printCurrent() {
        print("\r⚡️: \(Thread.current)\r" + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}
