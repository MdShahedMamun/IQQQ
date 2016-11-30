//
//  IQTest.swift
//  IQtEsT
//
//  Created by Mac air on 11/29/16.
//  Copyright © 2016 Mac air. All rights reserved.
//



import Foundation
import CoreData

class IQTest:NSManagedObject {
    @NSManaged var question:String;
    @NSManaged var correctAnswer:Int;
    @NSManaged var userAnswer:Int;
    @NSManaged var option1value:String;
    @NSManaged var option2value:String;
}

