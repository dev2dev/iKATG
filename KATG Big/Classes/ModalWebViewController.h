//
//  ModalWebViewController.h
//  KATG Big
//
//  Created by Doug Russell on 5/6/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalWebViewController : UIViewController 
{
	NSURLRequest *request;
	UIWebView *webView;
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain)          NSURLRequest *request;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)doneButtonPressed:(id)sender;

@end
