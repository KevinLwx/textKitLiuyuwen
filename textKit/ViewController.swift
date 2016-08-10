//
//  ViewController.swift
//  textKit
//
//  Created by LWX on 16/7/26.
//  Copyright © 2016年 LWX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let str = loadContent("Text.rtf")
        let nsstr: NSString = str!.string
        let attr = NSMutableAttributedString(string: nsstr as String)
        
        nsstr.enumerateSubstringsInRange(NSMakeRange(0, nsstr.length), options: [NSStringEnumerationOptions.ByWords]) { (text, range, r2, cont) in
            if text != nil {
                let x = [NSForegroundColorAttributeName: UIColor.blackColor().colorWithAlphaComponent(0.4), "MYRANGE_WORD": "\(range)"]
                 attr.addAttributes(x, range: range)
                
            }
        }
        
        textView.textContainerInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        textView.attributedText = attr
        textView.editable = false
        textView.selectable = false
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned(_:)))
       textView.addGestureRecognizer(pan)
    }

    func loadContent(fileName: String) -> NSAttributedString? {
        let fixtureFileURL = NSBundle.mainBundle().URLForResource(fileName, withExtension: nil)!
        let options = [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType]
        return try? NSAttributedString(URL: fixtureFileURL, options: options, documentAttributes: nil)
    }
    
    
    
    var startPoint: CGPoint?
    var highlightingRange: NSRange?
    var highlightRectView: UIView?
    
    func panned(pan: UIPanGestureRecognizer) {
        
        
        switch pan.state {
            
        case .Began:
            startPoint = pan.locationInView(textView)
//            startPoint = CGPoint(x: 0, y: 0)
        case .Ended:
            startPoint = nil
            
//            if let range = highlightingRange {
//                textView.textStorage.removeAttribute(NSBackgroundColorAttributeName, range: range)
//                highlightingRange = nil
//            }
            
        case .Changed:
            if let startPoint = startPoint {
                let curPoint = pan.locationInView(textView)
                
                let startIndex = textView.layoutManager.characterIndexForPoint(startPoint,
                                                                               inTextContainer: textView.textContainer,
                                                                               fractionOfDistanceBetweenInsertionPoints: nil)
                
                let currentIndex = textView.layoutManager.characterIndexForPoint(curPoint,
                                                                                 inTextContainer: textView.textContainer,
                                                                                 fractionOfDistanceBetweenInsertionPoints: nil)
                
                var attribute = textView.attributedText.attributesAtIndex(Int(startIndex), effectiveRange: nil)
                guard attribute.keys.contains("MYRANGE_WORD") else { return }
                
                let startRange = NSRangeFromString(attribute["MYRANGE_WORD"] as! String)
                
                attribute = textView.attributedText.attributesAtIndex(Int(currentIndex), effectiveRange: nil)
                guard attribute.keys.contains("MYRANGE_WORD") else { return }
                
                let currentRange = NSRangeFromString(attribute["MYRANGE_WORD"] as! String)
                
                
                let minLocation = min(startRange.location, currentRange.location)
                let maxLocation = max(startRange.location+startRange.length, currentRange.location+currentRange.length)
                let currentHighlightingRange = NSMakeRange(minLocation, maxLocation - minLocation + 1)
  
                
                if highlightingRange != nil {
                    textView.textStorage.removeAttribute(NSBackgroundColorAttributeName, range: highlightingRange!)
                }
                
                
                highlightingRange = currentHighlightingRange
                
                textView.textStorage.addAttribute(NSBackgroundColorAttributeName, value: UIColor.blackColor().colorWithAlphaComponent(0.4), range: currentHighlightingRange)
                
                
                
//                let r = textView.layoutManager.boundingRectForGlyphRange(currentHighlightingRange, inTextContainer: textView.textContainer)
//                
//                if let highlightRect = highlightRectView {
//                    UIView.animateWithDuration(0.5, animations: {
//                        highlightRect.frame = r
//                    })
//                }
//                else {
//                    let rectView = UIView(frame: CGRect(origin: startPoint, size: CGSize(width: 0, height: 20)))
//                    rectView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
//                    rectView.layer.cornerRadius = 5
//                    
//                    textView.addSubview(rectView)
//                    
//                    highlightRectView = rectView
//                }
//                
            }

                
            
        default: return
            
     }
        
  }


}

