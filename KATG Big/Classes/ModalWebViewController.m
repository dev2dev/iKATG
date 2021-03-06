    //
//  ModalWebViewController.m
//  KATG Big
//
//  Created by Doug Russell on 5/6/10.
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

#import "ModalWebViewController.h"
#import "ModalWebViewLogging.h"

@implementation ModalWebViewController
@synthesize request, webView, activityIndicator, navToolbar;

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
	self.webView			=	nil;
	self.activityIndicator	=	nil;
	self.navToolbar			=	nil;
}
- (void)dealloc 
{
	[request release];
	[webView release];
	[activityIndicator release];
	[navToolbar release];
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
- (IBAction)openButtonPressed:(id)sender
{
	UIActionSheet	*	actionSheet	=
	[[UIActionSheet alloc] initWithTitle:@"Current Webpage :" 
								delegate:self 
					   cancelButtonTitle:@"Cancel" 
				  destructiveButtonTitle:@"In Safari" 
					   otherButtonTitles:@"Copy To Pasteboard", nil];
	[actionSheet showFromToolbar:self.navToolbar];
	[actionSheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		NSURL			*	URL			=	[[self.webView request] URL];
		if ([[UIApplication sharedApplication] canOpenURL:URL])
			[[UIApplication sharedApplication] openURL:URL];
		else {
			BasicAlert(@"URL Open Failed", 
					   @"System can not open URL", 
					   nil, 
					   @"Continue", 
					   nil);
		}

	}
	else if (buttonIndex == 1)
	{
		UIPasteboard	*	pasteboard	=	[UIPasteboard generalPasteboard];
		NSString		*	copyText	=	[[[self.webView request] URL] description];
		if (pasteboard && copyText)
			pasteboard.string = copyText;
	}
}

@end
