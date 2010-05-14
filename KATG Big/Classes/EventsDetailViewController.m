//
//  EventsDetailViewController.m
//  KATG Big
//
//  Created by Doug Russell on 5/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "EventsDetailViewController.h"
#import "ModalWebViewController.h"
#import "NSString+Regex.h"

@implementation EventsDetailViewController
@synthesize webView;
@synthesize titleLabel;
@synthesize dayLabel;
@synthesize dateLabel;
@synthesize timeLabel;
@synthesize event;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	NSString *htmlHeader = @"<html><head><style>\nbody \n{\npadding: 0px;\nfont-family: Helvetica; \nfont-size: 18px;\nmargin: 0;\n}\n</style></head><body>";
	NSString *htmlFooter = @"</body></html>";
	NSString *htmlBody = [event objectForKey:@"Details"];
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
	[titleLabel setText:[event objectForKey:@"Title"]];
	[dayLabel setText:[event objectForKey:@"Day"]];
	[dateLabel setText:[event objectForKey:@"Date"]];
	[timeLabel setText:[event objectForKey:@"Time"]];
}
- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}
- (void)viewDidUnload 
{
	[super viewDidUnload];
}
- (void)dealloc 
{
	[webView release];
	[event release];
	[titleLabel release];
	[dayLabel release];
	[dateLabel release];
	[timeLabel release];
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
		ModalWebViewController *modalWebViewController = 
		[[ModalWebViewController alloc] initWithNibName:@"ModalWebViewiPad" 
												 bundle:nil];
		[modalWebViewController setRequest:request];
		[modalWebViewController setModalPresentationStyle:UIModalPresentationFormSheet];
		[modalWebViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
		[self presentModalViewController:modalWebViewController 
								animated:YES];
		[modalWebViewController release];
		return NO;
	}
	return YES;
}

@end
