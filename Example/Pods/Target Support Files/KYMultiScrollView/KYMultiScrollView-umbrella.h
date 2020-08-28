#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KYHeaderRefreshMultiViewController.h"
#import "KYMultiHeader.h"
#import "KYMultiHeadView.h"
#import "KYMultiScrollView.h"
#import "KYMultiViewController.h"
#import "KYScrollVcProtocol.h"
#import "KYTopRefreshMultiViewController.h"

FOUNDATION_EXPORT double KYMultiScrollViewVersionNumber;
FOUNDATION_EXPORT const unsigned char KYMultiScrollViewVersionString[];

