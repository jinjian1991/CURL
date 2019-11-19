//
//  NodeRunner.m
//  SenseStudy
//
//  Created by Mac on 2019/8/1.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#include "NodeRunner.h"

#if TARGET_OS_IPHONE
    #include <NodeMobile/NodeMobile.h>
#endif

#if TARGET_IPHONE_SIMULATOR

#endif

#include <string>

@implementation NodeRunner

//node's libUV requires all arguments being on contiguous memory.
+ (void) startEngineWithArguments:(NSArray*)arguments
{
    int c_arguments_size=0;
    
    //Compute byte size need for all arguments in contiguous memory.
    for (id argElement in arguments)
    {
        c_arguments_size+=strlen([argElement UTF8String]);
        c_arguments_size++; // for '\0'
    }
    
    //Stores arguments in contiguous memory.
    char* args_buffer=(char*)calloc(c_arguments_size, sizeof(char));
    
    //argv to pass into node.
    char* argv[[arguments count]];
    
    //To iterate through the expected start position of each argument in args_buffer.
    char* current_args_position=args_buffer;
    
    //Argc
    int argument_count=0;
    
    //Populate the args_buffer and argv.
    for (id argElement in arguments)
    {
        const char* current_argument=[argElement UTF8String];
        
        //Copy current argument to its expected position in args_buffer
        strncpy(current_args_position, current_argument, strlen(current_argument));
        
        //Save current argument start position in argv and increment argc.
        argv[argument_count]=current_args_position;
        argument_count++;
        
        //Increment to the next argument's expected position.
        current_args_position+=strlen(current_args_position)+1;
    }
    
    // Start node, with argc and argv.
    
    printf("=== %d \n", argument_count);
    printf("=== %s \n", argv[0]);
    printf("=== %s \n", argv[1]);


#if TARGET_OS_IPHONE
    node_start(argument_count,argv);
#endif
    free(args_buffer);
}
@end
