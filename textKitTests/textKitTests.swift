//
//  textKitTests.swift
//  textKitTests
//
//  Created by LWX on 16/7/26.
//  Copyright © 2016年 LWX. All rights reserved.
//

import XCTest
@testable import textKit

class textKitTests: XCTestCase {
    

    
    func testPanString() {
        let fixtureFileUrl = NSBundle.mainBundle().URLForResource("Text.rtf", withExtension: nil)!
        let options = [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType]
        if let fixtureString = try? NSMutableAttributedString(URL: fixtureFileUrl, options: options, documentAttributes: nil) {
            var effectiveRange = NSRange()
            
            let vc : ViewController
            vc = ViewController()
            
            let textView = vc.textView
            textView.attributedText = fixtureString
            let pan = UIPanGestureRecognizer(target: self, action: #selector(vc.panned(_:)))
            
           textView.addGestureRecognizer(pan)
            
            let attribute = fixtureString.attributesAtIndex(0, effectiveRange: &effectiveRange)
            
            XCTAssertTrue(attribute.keys.contains(NSBackgroundColorAttributeName))
            
        }
  
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
