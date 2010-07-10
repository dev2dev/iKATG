//
//  LinkButton.m
//  PartyCamera
//
//  Created by Doug Russell on 6/22/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

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

#import "LinkButton.h"

@implementation LinkButton

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetStrokeColorWithColor(context, self.currentTitleColor.CGColor);
	
	// Draw them with a 2.0 stroke width.
	CGContextSetLineWidth(context, 2.0);
	
	// Work out line width
	NSString *text = self.titleLabel.text;
	CGSize sz = [text sizeWithFont:self.titleLabel.font forWidth:rect.size.width lineBreakMode:UILineBreakModeTailTruncation];
	CGFloat width = rect.size.width;
	CGFloat offset = (rect.size.width - sz.width) / 2;
	if (offset > 0 && offset < rect.size.width)
		width -= offset;
	else
		offset = 0.0;
	
	// Work out line spacing to put it just below text
	CGFloat baseline = rect.size.height + self.titleLabel.font.descender + 2;
	
	// Draw a single line from left to right
	CGContextMoveToPoint(context, offset, baseline);
	CGContextAddLineToPoint(context, width, baseline);
	CGContextStrokePath(context);
}

@end
