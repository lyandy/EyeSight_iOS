//
//  AndyPlayInfoModel.m
//  EyeSight
//
//  Created by 李扬 on 15/10/21.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyPlayInfoModel.h"

@implementation AndyPlayInfoModel

- (void)setUrl:(NSString *)url
{
    _url = url;
    self.uniqueId = [AndyCommonFunction computeMD5:_url];
}

@end
