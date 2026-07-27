

#import "KDAddressBooksManager.h"

@implementation KDAddressBooksManager

+ (NSArray<NSDictionary<NSString *, id> *> *)kd_getAddressBooks {
    NSMutableArray *tmpArray = [NSMutableArray new];
    
    CNContactStore *store = [[CNContactStore alloc] init];
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status != CNAuthorizationStatusAuthorized) {
        return tmpArray;
    }
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    if (!addressBook) return tmpArray;
    
    CFArrayRef trove = ABAddressBookCopyArrayOfAllPeople(addressBook);
    if (!trove) {
        CFRelease(addressBook);
        return tmpArray;
    }
    
    CFIndex count = CFArrayGetCount(trove);
    for (CFIndex i = 0; i < count; i++) {
        NSMutableDictionary *tmpMutDict = [NSMutableDictionary new];
        ABRecordRef recRef = (ABRecordRef)CFArrayGetValueAtIndex(trove, i);
        
        NSString *tmpStr1 = (__bridge_transfer NSString *)ABRecordCopyValue(recRef, kABPersonFirstNameProperty);
        NSString *tmpStr2 = (__bridge_transfer NSString *)ABRecordCopyValue(recRef, kABPersonLastNameProperty);
        tmpStr1 = tmpStr1 ?: @"";
        tmpStr2 = tmpStr2 ?: @"";
        
        tmpMutDict[@"galaxy"] = [[NSString stringWithFormat:@"%@ %@", tmpStr1, tmpStr2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSDate *tmpTimes = (__bridge_transfer NSDate *)ABRecordCopyValue(recRef, kABPersonModificationDateProperty);
        if (tmpTimes) {
            tmpMutDict[@"nebula"] = [NSString stringWithFormat:@"%0.f", tmpTimes.timeIntervalSince1970 * 1000];
        } else {
            tmpMutDict[@"nebula"] = @"0";
        }
        
        NSMutableArray *tmpMutableArray = [[NSMutableArray alloc] init];
        ABMultiValueRef weld = ABRecordCopyValue(recRef, kABPersonPhoneProperty);
        if (weld) {
            CFIndex phoneCount = ABMultiValueGetCount(weld);
            for (CFIndex j = 0; j < phoneCount; j++) {
                NSString *rawPhone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(weld, j);
                NSString *whip = [self _checkNumber:rawPhone];
                if (whip.length > 0) {
                    [tmpMutableArray addObject:whip];
                }
            }
            CFRelease(weld);
        }
        tmpMutDict[@"moon"] = tmpMutableArray;
        
        [tmpArray addObject:tmpMutDict];
    }
    
    CFRelease(trove);
    CFRelease(addressBook);
    
    return tmpArray;
}



- (NSString *)_checkNumber:(NSString *)want {
    if (!want) return @"";
    NSError *error = nil;
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:@"[^0-9]" options:0 error:&error];
    if (error) return @"";
    
    NSString *str = [exp stringByReplacingMatchesInString:want
                                                          options:0
                                                            range:NSMakeRange(0, want.length)
                                                     withTemplate:@""];
    return str;
}


@end
