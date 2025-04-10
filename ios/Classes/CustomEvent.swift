//
//  CustomEvent.swift
//  Pods
//
//  Created by Marc Biosca on 2/4/25.
//

public class CustomEvent {
    var name: String
    var type: String
    var data: Dictionary<AnyHashable, Any>?
    
    init(name: String, type: String, data: Dictionary<AnyHashable, Any>?) {
        self.name = name
        self.type = type
        self.data = data
    }
}
