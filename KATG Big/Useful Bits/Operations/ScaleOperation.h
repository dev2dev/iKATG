//
//  ScaleOperation.h
//  PartyCamera
//
//  Created by Doug Russell on 6/5/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScaleOperationDelegate;

@interface ScaleOperation : NSOperation 
{
	id<ScaleOperationDelegate> _delegate;
	NSString * _originalImagePath;
	CGFloat    _width;
	CGFloat    _height;
	UIImage  * _originalImage;
	UIImage	 * _scaledImage;
	CGSize	   _targetSize;
	NSString * _scaledImagePath;
	NSObject * _userInfo;
}

@property (nonatomic, assign) id<ScaleOperationDelegate> delegate;
@property (nonatomic, retain) NSString * originalImagePath;
@property (readwrite, assign) CGFloat    width;
@property (readwrite, assign) CGFloat    height;
@property (nonatomic, retain) UIImage  * originalImage;
@property (nonatomic, retain) UIImage  * scaledImage;
@property (readwrite, assign) CGSize     targetSize;
@property (nonatomic, retain) NSString * scaledImagePath;
@property (nonatomic, retain) NSObject * userInfo;

- (id)initWithImage:(UIImage *)image forSize:(CGSize)size;
- (id)initWithImagePath:(NSString *)path width:(CGFloat)width height:(CGFloat)height forSize:(CGSize)size;

@end

@protocol ScaleOperationDelegate
- (void)scaleOperationFinished:(NSString *)fileName userInfo:(id)object;
@end
