//
//  GlobalVariables.swift
//  TRAK3
//
//  Created by George Gogarten on 7/8/16.
//  Copyright © 2016 George Gogarten. All rights reserved.
//

import Foundation

class GlobalVariables {
    
    // These are the properties you can store in your singleton
    var profileFromMore: Bool = false
    
    var units = "Metric"
    
    var activitySport = "bike"
    
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}


