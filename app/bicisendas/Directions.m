//
//  Directions.m
//  andaenbici
//
//  Created by Dario Miñones on 12/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Directions.h"

@implementation Directions

@synthesize delegate;

- (void) loadWithStartPoint:(NSString*)startPoint endPoint:(NSString*)sendPoint
{
    NSLog(sendPoint);
    //Pegarle a una url que me da ari
    //http://andaenbici.services.cactus.ws/?startpoint=-34.5999,-58.404134&finalpoint=-34.617416,-58.418251
    
    NSLog([NSString stringWithFormat: @"http://andaenbici.services.cactus.ws/?startpoint=%@&finalpoint=%@",startPoint,sendPoint]);
    NSURL *oRequestUrl = [NSURL URLWithString:[NSString stringWithFormat: @"http://andaenbici.services.cactus.ws/?startpoint=%@&finalpoint=%@",startPoint,sendPoint]];
    NSMutableURLRequest *oRequest = [[[NSMutableURLRequest alloc] init] autorelease];
    [oRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [oRequest setHTTPMethod:@"POST"];
    [oRequest setURL:oRequestUrl];
    NSError *oError = [[NSError alloc] init];
    NSHTTPURLResponse *oResponseCode = nil;
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:oRequest             returningResponse:oResponseCode error:oError];
    NSString * strResult = [[NSString alloc] initWithData:oResponseData             encoding:NSUTF8StringEncoding];
    NSArray * parsedData = [strResult JSONValue];
  
    [delegate didUpdateDirections:parsedData];
}

@end
