//
//  GODBlogModel.h
//  Blogger
//
//  Created by pipelining on 2019/1/15.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@interface GODBlogModel : NSObject
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *year;
@property(nonatomic, strong) NSString *summary;
@property(nonatomic, assign) NSInteger tag;
@end
