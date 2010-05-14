    //
//  ModalWebViewController.m
//  KATG Big
//
//  Created by Doug Russell on 5/6/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import "ModalWebViewController.h"
#import "ModalWebViewLogging.h"

@implementation ModalWebViewController
@synthesize request, webView, activityIndicator;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	[webView loadRequest:request];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
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
	[request release];
	[webView release];
	[activityIndicator release];
    [super dealloc];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"%@", error);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[activityIndicator stopAnimating];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[activityIndicator startAnimating];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
#if LogWebViewRequests
	NSLog(@"\nRequest: %@\nHeaders: %@\nBody: %@", 
		  request, 
		  [request allHTTPHeaderFields], 
		  [[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] autorelease]);	
#endif
	return YES;
}
- (IBAction)doneButtonPressed:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
