//
//  FeedWidgetViewController.swift
//  SAPJamSDK
//
//  Copyright © 2016 SAP SE. All rights reserved.
//

import UIKit
import WebKit

class FeedWidgetViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var content: UIView?
    var wkWebView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Wipe old web cache
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = NSDate(timeIntervalSince1970: 0)
        WKWebsiteDataStore.defaultDataStore().removeDataOfTypes(websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
        
        wkWebView = WKWebView()
        wkWebView?.frame = self.content!.bounds
        wkWebView?.autoresizingMask =  [.FlexibleHeight, .FlexibleWidth]
        wkWebView?.navigationDelegate = self
        content!.addSubview(wkWebView!)
        
        // Note that Apple Transport Security was turned off to allow download of assets

        loadFeedWidget()
    }
    
    
    private func loadFeedWidget() {
        JamAuthConfig.sharedInstance.getSingleUseToken(
            { (singleUseToken) -> Void in
                
                // Use the token to load the feed widget
                let urlStr = JamAuthConfig.sharedInstance.getServerUrl() + "/widget/v1/feed?single_use_token=" + singleUseToken
                let request = NSURLRequest(URL: NSURL(string: urlStr)!)
                self.wkWebView?.loadRequest(request)
            },
            failure: { error in
                print("An error occured and we cannot show the Feed Widget")
                print(error)
            }
        )
    }
    
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(WKNavigationResponsePolicy.Allow)
    }


}

