//
//  TagsData.m
//  piwigo
//
//  Created by Spencer Baker on 2/17/15.
//  Copyright (c) 2015 bakercrew. All rights reserved.
//

#import "TagsData.h"
#import "TagsService.h"
#import "PiwigoTagData.h"

@implementation TagsData

+(TagsData*)sharedInstance
{
	static TagsData *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
		
		instance.tagList = [NSArray new];
	});
	return instance;
}

-(void)clearCache
{
	self.tagList = [NSArray new];
}

-(void)addTagList:(NSArray*)newTags
{
	NSMutableArray *tags = [[NSMutableArray alloc] initWithArray:self.tagList];
	for(PiwigoTagData *tagData in newTags)
	{
		BOOL alreadyExists = NO;
		for(PiwigoTagData *existingData in tags)
		{
			if(existingData.tagId == tagData.tagId)
			{
				alreadyExists = YES;
				break;
			}
		}
		
		if(!alreadyExists)
		{
			[tags addObject:tagData];
		}
	}
	
	self.tagList = tags;
}

-(void)getTagsOnCompletion:(void (^)(NSArray *tags))completion
{
	[TagsService getTagsOnCompletion:^(NSURLSessionTask *task, NSDictionary *response) {
		if([[response objectForKey:@"stat"] isEqualToString:@"ok"])
		{
			NSArray *tags = [self parseTagsJson:response];
			[self addTagList:tags];
			if(completion)
			{
				completion(self.tagList);
			}
		}
	} onFailure:^(NSURLSessionTask *task, NSError *error) {
#if defined(DEBUG)
		NSLog(@"Failed to get Tags: %@", [error localizedDescription]);
#endif
    }];
}

-(NSArray*)parseTagsJson:(NSDictionary*)json
{
	NSMutableArray *tags = [NSMutableArray new];
	
	NSDictionary *tagsArray = [[json objectForKey:@"result"] objectForKey:@"tags"];
	
	for(NSDictionary *tagData in tagsArray)
	{
		PiwigoTagData *newTagData = [PiwigoTagData new];
		newTagData.tagId = [[tagData objectForKey:@"id"] integerValue];
		newTagData.tagName = [tagData objectForKey:@"name"];
        
        // Number of images not known if getAdminList called
		newTagData.numberOfImagesUnderTag = [[tagData objectForKey:@"counter"] integerValue];

        [tags addObject:newTagData];
	}
	
	return tags;
}

+(NSString*)getTagsStringFromList:(NSArray*)tagList
{
	NSString *tagListString = @"";
    if (tagList != nil) {
        if ([tagList count] > 0)
        {
            tagListString = [[tagList firstObject] tagName];
            for(NSInteger i = 1; i < tagList.count; i++)
            {
                PiwigoTagData *tagData = [tagList objectAtIndex:i];
                tagListString = [NSString stringWithFormat:@"%@, %@", tagListString, tagData.tagName];
            }
        }
	}
	return tagListString;
}

-(NSInteger)getIndexOfTag:(PiwigoTagData*)tag
{
	NSInteger count = 0;
	for(PiwigoTagData *tagData in self.tagList)
	{
		if(tagData.tagId == tag.tagId)
		{
			return count;
		}
		count++;
	}
	return count;
}

#pragma mark - debugging support -

-(NSString *)description {
    NSMutableArray * descriptionArray = [[NSMutableArray alloc] init];
    [descriptionArray addObject:[NSString stringWithFormat:@"<%@: 0x%lx> = {", [self class], (unsigned long)self]];
    
    [descriptionArray addObject:[NSString stringWithFormat:@"tagList [%ld]  = %@", (long)self.tagList.count, self.tagList]];
    [descriptionArray addObject:@"}"];
    
    return [descriptionArray componentsJoinedByString:@"\n"];
}
    
@end
