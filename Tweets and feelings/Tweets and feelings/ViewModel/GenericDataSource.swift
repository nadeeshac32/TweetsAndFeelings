//
//  GenericDataSource.swift
//  Tweets and feelings
//
//  Created by Nadeesha Lakmal on 5/20/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import Foundation

class GenericDataSource<T> : NSObject {
	var data            : DynamicValue<[T]> = DynamicValue([])
    var cellsIsOpen 	: [Bool]            = [Bool]()
	var selectedIndex   : IndexPath?    
}
