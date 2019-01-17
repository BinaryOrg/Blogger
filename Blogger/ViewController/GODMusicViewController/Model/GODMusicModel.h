//
//  GODMusicModel.h
//  Blogger
//
//  Created by pipelining on 2019/1/16.
//  Copyright © 2019年 GodzzZZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@interface GODMusicModel : NSObject
@property(nonatomic, assign) BOOL isPlaying;
@property(nonatomic, assign) NSInteger id;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *artist;
@property(nonatomic, strong) NSString *summary;
@property(nonatomic, strong) NSString *lyrics;
@property(nonatomic, strong) NSString *thumb;
@property(nonatomic, strong) NSString *music_url;
@property(nonatomic, assign) NSInteger music_duration;
@end
