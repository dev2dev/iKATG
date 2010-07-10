//
//  ScaleOperation.m
//  PartyCamera
//
//  Created by Doug Russell on 6/5/10.
//  Based in large part on sample code
//  provided by Apple at iPhone Tech Talk
//  Toronto in 2009
//

#import "ScaleOperation.h"
#import "ImageHelpers.h"
#import "PartyCameraDataModel.h"
#import "ConvertImage.h"

@interface ScaleOperation ()
- (void)scale;
- (void)doScale;
- (CGImageRef)newCGImageFromUIImage:(UIImage *)image scaled:(float)scaleFactor;
@end

@implementation ScaleOperation
@synthesize delegate = _delegate;
@synthesize originalImagePath = _originalImagePath;
@synthesize width = _width;
@synthesize height = _height;
@synthesize originalImage = _originalImage;
@synthesize scaledImage = _scaledImage;
@synthesize targetSize = _targetSize;
@synthesize scaledImagePath = _scaledImagePath;
@synthesize userInfo = _userInfo;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init])
	{
		_delegate = [PartyCameraDataModel sharedPartyCameraDataModel];
		_originalImagePath = [[aDecoder decodeObject] retain];
		_width = [aDecoder decodeFloatForKey:@"width"];
		_height = [aDecoder decodeFloatForKey:@"height"];
		_targetSize = [aDecoder decodeCGSizeForKey:@"targetSize"];
		_userInfo = [[aDecoder decodeObject] retain];
	}
	return self;
}
- (void)encodeWithCoder:(NSCoder *)coder 
{
    [coder encodeObject:_originalImagePath];
	[coder encodeFloat:_width forKey:@"width"];
	[coder encodeFloat:_height forKey:@"height"];
	[coder encodeCGSize:_targetSize forKey:@"targetSize"];
	[coder encodeObject:_userInfo];
}
- (id)initWithImage:(UIImage *)image forSize:(CGSize)size
{
	if (self = [super init])
	{
		[self setOriginalImage:image];
		[self setTargetSize:size];
	}
	return self;
}
- (id)initWithImagePath:(NSString *)path width:(CGFloat)width height:(CGFloat)height forSize:(CGSize)size
{
	if (self = [super init])
	{
		[self setOriginalImagePath:path];
		[self setTargetSize:size];
		[self setWidth:width];
		[self setHeight:height];
	}
	return self;
}
- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self scale];
	
	NSData *imageData = 
	UIImageJPEGRepresentation([self scaledImage], 0.8);
	//UIImagePNGRepresentation(scaledImage);
	
	[_scaledImage release]; _scaledImage = nil;
	
	// Write data to disk, return filename
	BOOL saved = NO;
	if (imageData)
	{
		NSString *fileName = [NSString stringWithFormat:@"%f.jpg", CFAbsoluteTimeGetCurrent()];
		if (fileName)
		{
			[self setScaledImagePath:fileName];
			NSString *path = [AppDirectoryCachePathAppended(self.scaledImagePath) retain];
			if (path)
			{
				// should move this to a C file handle
				saved = [imageData writeToFile:path atomically:YES];
			}
			[path release];
		}
	}
	
	[pool drain];
	
	if (!self.isCancelled && [self delegate] && saved)
		[[self delegate] scaleOperationFinished:[self scaledImagePath] userInfo:[self userInfo]];
}
- (void)scale
{
	if (!self.isCancelled && [self originalImage] != nil)
	{
		[self doScale];
	}
	else if (!self.isCancelled && [self originalImagePath] != nil)
	{
		UIImage *anImage = memory_mapped_image_read([self originalImagePath], [self width], [self height]);
		if (anImage)
		{
			[self setOriginalImage:anImage];
			[self doScale];
		}
	}
}
- (void)doScale
{
	CGImageRef cgImage	 = NULL;
	CGSize	   imageSize = [self originalImage].size;
	float	   scale	 = GetScaleForProportionalResize(imageSize, [self targetSize], true, false);
	
	if (!self.isCancelled)
	{
		cgImage = [self newCGImageFromUIImage:[self originalImage] scaled:scale];
		
		[_originalImage release]; _originalImage = nil;
		
		if (!self.isCancelled && cgImage)
		{
			if (!self.isCancelled) 
			{
				UIImage *anImage = [[UIImage alloc] initWithCGImage:cgImage];
				self.scaledImage = anImage;
				[anImage release];
			}
		}
		
		CGImageRelease(cgImage);
	}
}
- (CGImageRef)newCGImageFromUIImage:(UIImage *)image scaled:(float)scaleFactor
{
	CGImageRef			newImage		= NULL;
	CGContextRef		bmContext		= NULL;
	BOOL				mustTransform	= YES;
	CGAffineTransform	transform		= CGAffineTransformIdentity;
	UIImageOrientation	orientation		= image.imageOrientation;
	
	CGImageRef			srcCGImage		= CGImageRetain(image.CGImage);
	
	size_t width	= CGImageGetWidth(srcCGImage) * scaleFactor;
	size_t height	= CGImageGetHeight(srcCGImage) * scaleFactor;
	
	if (!self.isCancelled)
	{
		// These Orientations are rotated 0 or 180 degrees, so they retain the width/height of the image
		if((orientation == UIImageOrientationUp) || 
		   (orientation == UIImageOrientationDown) || 
		   (orientation == UIImageOrientationUpMirrored) || 
		   (orientation == UIImageOrientationDownMirrored))
		{	
			bmContext	= CreateCGBitmapContextForWidthAndHeight( width, height, NULL, kDefaultCGBitmapInfo );
		}
		else	// The other Orientations are rotated ±90 degrees, so they swap width & height.
		{	
			bmContext	= CreateCGBitmapContextForWidthAndHeight( height, width, NULL, kDefaultCGBitmapInfo );
		}
		
		//CGContextSetInterpolationQuality( bmContext, kCGInterpolationLow );
		CGContextSetBlendMode(bmContext, kCGBlendModeCopy);
		
		if (!self.isCancelled)
		{
			switch(orientation)
			{
				case UIImageOrientationDown:		// 0th row is at the bottom, and 0th column is on the right - Rotate 180 degrees
					transform	= CGAffineTransformMake(-1.0, 0.0, 0.0, -1.0, width, height);
					break;
					
				case UIImageOrientationLeft:		// 0th row is on the left, and 0th column is the bottom - Rotate -90 degrees
					transform	= CGAffineTransformMake(0.0, 1.0, -1.0, 0.0, height, 0.0);
					break;
					
				case UIImageOrientationRight:		// 0th row is on the right, and 0th column is the top - Rotate 90 degrees
					transform	= CGAffineTransformMake(0.0, -1.0, 1.0, 0.0, 0.0, width);
					break;
					
				case UIImageOrientationUpMirrored:	// 0th row is at the top, and 0th column is on the right - Flip Horizontal
					transform	= CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, width, 0.0);
					break;
					
				case UIImageOrientationDownMirrored:	// 0th row is at the bottom, and 0th column is on the left - Flip Vertical
					transform	= CGAffineTransformMake(1.0, 0.0, 0, -1.0, 0.0, height);
					break;
					
				case UIImageOrientationLeftMirrored:	// 0th row is on the left, and 0th column is the top - Rotate -90 degrees and Flip Vertical
					transform	= CGAffineTransformMake(0.0, -1.0, -1.0, 0.0, height, width);
					break;
					
				case UIImageOrientationRightMirrored:	// 0th row is on the right, and 0th column is the bottom - Rotate 90 degrees and Flip Vertical
					transform	= CGAffineTransformMake(0.0, 1.0, 1.0, 0.0, 0.0, 0.0);
					break;
					
				default:
					mustTransform	= NO;
					break;
			}
			
			if (mustTransform)	CGContextConcatCTM( bmContext, transform );
			
			if (!self.isCancelled)
			{
				CGContextDrawImage( bmContext, CGRectMake(0.0, 0.0, width, height), srcCGImage );
				newImage = CGBitmapContextCreateImage(bmContext);
			}
		}
		
		CFRelease(bmContext);
	}
	CGImageRelease(srcCGImage);
	
	return newImage;
}
- (void)dealloc
{
	_delegate = nil;
	[_originalImagePath release];
	[_originalImage release];
	[_scaledImage release];
	[_scaledImagePath release];
	[_userInfo release];
	[super dealloc];
}

@end
