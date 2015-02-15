//
//  ColorOptions.h
//  Statistics
//
//  Created by Alex Erf on 2/12/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorOptions : NSObject

+(UIColor *)colorFromHex:(unsigned)hex;

+(UIColor *)mainRed;
+(UIColor *)mainWhite;
+(UIColor *)secondaryGreen;

@end
