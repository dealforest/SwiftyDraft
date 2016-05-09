//
//  SwiftyDraft.swift
//  SwiftyDraft
//
//  Created by Atsushi Nagase on 5/2/16.
//
//

import UIKit

@IBDesignable public class SwiftyDraft: UIView {

    lazy var callbackToken: String = {
        var letters = Array("abcdefghijklmnopqrstuvwxyz".characters)
        let len = letters.count
        var randomString = ""

        while randomString.utf8.count < len {
            let idx = Int(arc4random_uniform(UInt32(letters.count)))
            randomString = "\(randomString)\(letters[idx])"
            letters.removeAtIndex(idx)
        }
        
        return randomString
    }()

    public lazy var webView: UIWebView = {
        let wv = UIWebView(frame: self.frame)
        self.addSubview(wv)
        return wv
    }()

    public lazy var editorToolbar: Toolbar = {
        let v = Toolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 44))
        v.editor = self
        return v
    }()

    public weak var scrollViewDelegate: UIScrollViewDelegate? {
        get { return self.webView.scrollView.delegate }
        set(value) { self.webView.scrollView.delegate = value }
    }

    public static var htmlURL: NSURL {
        return resourceBundle.URLForResource("index", withExtension: "html")!
    }

    public static var resourceBundle: NSBundle {
        let bundleURL = NSBundle(forClass: self).URLForResource("SwiftyDraft", withExtension: "bundle")!
        return NSBundle(URL: bundleURL)!
    }

    private func setup() {
        self.webView.scalesPageToFit = false
        self.webView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.webView.dataDetectorTypes = .None
        self.webView.backgroundColor = UIColor.whiteColor()
        self.webView.delegate = self
        self.webView.keyboardDisplayRequiresUserAction = false
        self.webView.cjw_inputAccessoryView = self.editorToolbar
        let req = NSURLRequest(URL: SwiftyDraft.htmlURL)
        self.webView.loadRequest(req)
    }

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        let b = self.bounds
        self.webView.frame = CGRect(origin: CGPointZero, size: b.size)
    }
}