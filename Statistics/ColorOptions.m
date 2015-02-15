//
//  ColorOptions.m
//  Statistics
//
//  Created by Alex Erf on 2/12/15.
//  Copyright (c) 2015 Orange. All rights reserved.
//

#import "ColorOptions.h"

@implementation ColorOptions

+(UIColor*)colorFromHex:(unsigned)hex {
    return [UIColor colorWithRed:((hex & 0xFF0000) >> 16) / 255.0 green:((hex & 0xFF00) >> 8) / 255.0 blue:((hex & 0xFF)) / 255.0 alpha:1.0];
}

+(UIColor *)mainRed {
    return [ColorOptions colorFromHex:0xDB4437]; // Alizarin
}

+(UIColor *)mainWhite {
    return [UIColor whiteColor]; // Plain White
}

+(UIColor *)secondaryGreen {
    return [ColorOptions colorFromHex:0x2ECC71]; // Emerald
}

@end
