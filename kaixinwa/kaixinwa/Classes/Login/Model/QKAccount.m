//
//  QKAccount.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/1.
//

#import "QKAccount.h"

@implementation QKAccount
-(void)setLasttime:(NSString *)lasttime
{
    _lasttime = [lasttime copy];
    
    self.lasttime_date = [NSDate dateWithTimeIntervalSince1970:[_lasttime doubleValue]];
    
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.phoneNum = [decoder decodeObjectForKey:@"phoneNum"];
        self.created_time = [decoder decodeObjectForKey:@"created_time"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.upkey = [decoder decodeObjectForKey:@"upkey"];
        self.client_type = [decoder decodeObjectForKey:@"client_type"];
        self.user_type = [decoder decodeObjectForKey:@"user_type"];
        self.lasttime = [decoder decodeObjectForKey:@"lasttime"];
        self.lasttime_date = [decoder decodeObjectForKey:@"lasttime_date"];
        self.weixin = [decoder decodeObjectForKey:@"weixin"];
        self.school = [decoder decodeObjectForKey:@"school"];
        self.user_name = [decoder decodeObjectForKey:@"user_name"];
        self.signature = [decoder decodeObjectForKey:@"signature"];
        self.address = [decoder decodeObjectForKey:@"address"];
        self.qq = [decoder decodeObjectForKey:@"qq"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.header = [decoder decodeObjectForKey:@"header"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.phoneNum forKey:@"phoneNum"];
    [encoder encodeObject:self.created_time forKey:@"created_time"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.upkey forKey:@"upkey"];
    [encoder encodeObject:self.client_type forKey:@"client_type"];
    [encoder encodeObject:self.user_type forKey:@"user_type"];
    [encoder encodeObject:self.lasttime forKey:@"lasttime"];
    [encoder encodeObject:self.lasttime_date forKey:@"lasttime_date"];
    [encoder encodeObject:self.weixin forKey:@"weixin"];
    [encoder encodeObject:self.school forKey:@"school"];
    [encoder encodeObject:self.user_name forKey:@"user_name"];
    [encoder encodeObject:self.signature forKey:@"signature"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.qq forKey:@"qq"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.header forKey:@"header"];
    
}
@end
