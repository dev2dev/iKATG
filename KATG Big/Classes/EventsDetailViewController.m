//
//  EventsDetailViewController.m
//  KATG Big
//
//  Created by Doug Russell on 5/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

#import "EventsDetailViewController.h"
#import "ModalWebViewController.h"
#import "NSString+Regex.h"
#import "Event.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventsDetailViewController
@synthesize webContainerView, webView;
@synthesize titleLabel, dateTimeLabel;
@synthesize event;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.webContainerView.layer.cornerRadius	=	10;
	[self makePage];
}
- (void)makePage
{
	NSString *htmlHeader = @"<html>\n<head>\n<style>\nbody {\nbackground-color: White;\npadding: 0px;\nfont-family: Helvetica; \nfont-size: 15pt;\ncolor: #707070;\nmargin: 0;\n}\na:link {\nword-wrap: break-word;\ncolor: #438a23;\ntext-decoration: underline;\n}\na:visited {\nword-wrap: break-word;\ncolor: #438a23;\ntext-decoration: underline;\n}\n</style>\n<meta name = \"viewport\" content = \"width = 280, initial-scale = 1.0, user-scalable = no\">\n</head>\n<body>\n";
	NSString *htmlFooter = @"</body></html>";
	NSString *htmlBody = [event Details];
	NSString *regex = @"style=\"[^\"]*\"";
	htmlBody = [htmlBody stringByReplacingOccurencesOfRegularExpressions:regex 
															  withString:@""];
	htmlBody = [htmlBody stringByReplacingOccurrencesOfString:@"http://www.keithandthegirl.com/Live/HowToListen.aspx" 
												   withString:@""];
	htmlBody = [htmlBody stringByReplacingOccurrencesOfString:@"../Live/HowToListen.aspx" 
												   withString:@""];
	htmlBody = [htmlBody stringByReplacingOccurrencesOfString:@"Here's how  to listen:"
												   withString:@""];
	htmlBody = [htmlBody stringByReplacingOccurrencesOfString:@"Here's how to listen:"
												   withString:@""];
	NSString *htmlString = [NSString stringWithFormat:@"%@%@%@",
							htmlHeader,
							htmlBody,
							htmlFooter];
	webView.backgroundColor = [UIColor clearColor];
	[webView loadHTMLString:htmlString 
					baseURL:[NSURL URLWithString:@"http://www.keithandthegirl.com/"]];
	NSString	*	title		=	[event Title];
	CGSize			titleSize	=	[title sizeWithFont:titleLabel.font 
						   constrainedToSize:titleLabel.bounds.size 
							   lineBreakMode:UILineBreakModeWordWrap];
	if (titleSize.height > titleLabel.frame.size.height)
	{
		titleLabel.font	=	[UIFont fontWithName:[titleLabel.font fontName] size:14];
	}
	[titleLabel setText:title];
	NSString	*	dateTime	=
	[NSString stringWithFormat:@"%@ %@ %@", 
	 [event Day], 
	 [event Date], 
	 [event Time]];
	[dateTimeLabel setText:dateTime];
}
- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}
- (void)viewDidUnload 
{
	[super viewDidUnload];
	self.webContainerView	=	nil;
	self.webView			=	nil;
	self.titleLabel			=	nil;
	self.dateTimeLabel		=	nil;
}
- (void)dealloc 
{
	[webView release];
	[titleLabel release];
	[dateTimeLabel release];
	[super dealloc];
}
- (BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType 
{
	if (navigationType == UIWebViewNavigationTypeOther) 
	{
		return YES;
	} 
	else if (navigationType == UIWebViewNavigationTypeLinkClicked)
	{
		[self modalWebViewController:request];
		return NO;
	}
	return YES;
}
- (void)modalWebViewController:(NSURLRequest *)request
{
	ModalWebViewController *modalWebViewController = 
	[[ModalWebViewController alloc] initWithNibName:@"ModalWebViewiPad" 
											 bundle:nil];
	[modalWebViewController setRequest:request];
	[modalWebViewController setModalPresentationStyle:UIModalPresentationFormSheet];
	[modalWebViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:modalWebViewController 
							animated:YES];
	[modalWebViewController release];
}

@end
