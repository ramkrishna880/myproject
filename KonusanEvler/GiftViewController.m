//
//  GiftViewController.m
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 15/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "GiftViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HeaderFiles.h"
#import "imageUrls.h"
#import "DBCOnnectClass.h"
#import "HUD/HUD.h"

@interface GiftViewController (){
    int count;
    DBCOnnectClass *db;
    
    NSArray *images;
    NSString *dataPath;
}
//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GiftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    count=1;
    // Do any additional setup after loading the view from its nib.
    self.title=@"Hediyeler";
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)83/(CGFloat)255 green:(CGFloat)97/(CGFloat)255 blue:(CGFloat)166/(CGFloat)255 alpha:1.0];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    //self.navigationController.navigationBar.translucent = NO;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbarbutton.png"] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [backButton setTitle:@"Ana Menü" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    //_imageView.image=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://eksen2.sbtanaliz.com/keys/katalog/sayfa_1.jpg"]]];
    db=[[DBCOnnectClass alloc]init];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //mainpath=[defaults valueForKey:@"mainpath"];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",[defaults valueForKey:@"mainpath"],kGetimagesUrl,[defaults valueForKey:@"userId"]]]];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestFinishedLoading:)];
    [request startAsynchronous];
    
   
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *mydataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyFolder"];
    NSFileManager *manger=[NSFileManager defaultManager];
    BOOL available= [manger fileExistsAtPath:mydataPath];
    
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

-(void)requestFinishedLoading:(ASIHTTPRequest*)response{
    
    NSArray *imageurlsarr=[NSJSONSerialization JSONObjectWithData:[response responseData] options:NSJSONReadingMutableLeaves error:Nil];
    //************ new********************
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyFolder"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }//Create folder
    
    
    NSArray *checkDbForImages=[db getimageUrlsFromDatabase:[NSString stringWithFormat:@"select *from imageUrls"]];
    
    if (checkDbForImages.count==0) {
        for (int i=0; i<imageurlsarr.count; i++) {
            imageUrls *objCls=[[imageUrls alloc]init];
            objCls.imageName=[[imageurlsarr objectAtIndex:i] valueForKey:@"pageLink"];
            objCls.rowDate=[[imageurlsarr objectAtIndex:i] valueForKey:@"rowDate"];
            
            if ([db getimageUrlsFromDatabase:[NSString stringWithFormat:@"select * from imageUrls where pageLink='%@'",objCls.imageName]].count==0) {
                [db insertimages:objCls];
            }
        }
        
        images=[db getimageUrlsFromDatabase:[NSString stringWithFormat:@"select *from imageUrls"]];
        
        NSFileManager *manger=[NSFileManager defaultManager];
        NSString* imagePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konusanImage%d.jpeg",count]];
        BOOL available= [manger fileExistsAtPath:imagePath];
        
        if (available) {
            NSLog(@"file exists");
            NSData *imgData=[NSData dataWithContentsOfFile:imagePath];
            
            [[self imageView] setImage:[UIImage imageWithData:imgData]];
        }else{
            [HUD showUIBlockingIndicator];
            dispatch_async(
                           
                           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                               
                               imageUrls *imgUrl=[images objectAtIndex:count-1];
                               UIImage *img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrl.imageName]]]];
                               
                               dispatch_sync(dispatch_get_main_queue(), ^{
                                   
                                   NSData *imgData=UIImageJPEGRepresentation(img, 0.1);
                                   NSString *imagepath=[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konuImage%d.jpeg",count]];
                                   [imgData writeToFile:imagepath atomically:YES];
                                   [HUD hideUIBlockingIndicator];
                                   [[self imageView] setImage:img];
                                   
                               });
                           });
            
        }
        
    }else{
        
        images=[db getimageUrlsFromDatabase:@"select *from imageUrls"];
        imageUrls *i=(imageUrls *)[images objectAtIndex:0];
        NSLog(@"image name %@",i.imageName);
        NSString *rowdateFromWeb=[[imageurlsarr objectAtIndex:0] valueForKey:@"rowDate"];
        
        if (![rowdateFromWeb isEqualToString:i.rowDate]) {
            [db deleteimageUrls];
            NSFileManager *manager=[NSFileManager defaultManager];
            for (NSString *file in [manager contentsOfDirectoryAtPath:dataPath error:&error]) {
                NSString *ppath=[dataPath stringByAppendingPathComponent:file];
                BOOL success = [manager removeItemAtPath:ppath error:&error];
                NSLog(@"%@",[error localizedDescription]);
                if (success) {
                    NSLog(@"deleted");
                }
            }
            
            
            for (int i=0; i<imageurlsarr.count; i++) {
                imageUrls *objCls=[[imageUrls alloc]init];
                objCls.imageName=[[imageurlsarr objectAtIndex:i] valueForKey:@"pageLink"];
                objCls.rowDate=[[imageurlsarr objectAtIndex:i] valueForKey:@"rowDate"];
                
                if ([db getimageUrlsFromDatabase:[NSString stringWithFormat:@"select * from imageUrls where pageLink='%@'",objCls.imageName]].count==0) {
                    [db insertimages:objCls];
                }
            }
            
            images=[db getimageUrlsFromDatabase:[NSString stringWithFormat:@"select *from imageUrls"]];
            
            NSFileManager *manger=[NSFileManager defaultManager];
            NSString* imagePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konusanImage%d",count]];
            BOOL available= [manger fileExistsAtPath:imagePath];
            
            if (available) {
                NSLog(@"file exists");
                NSData *imgData=[NSData dataWithContentsOfFile:imagePath];
                
                [[self imageView] setImage:[UIImage imageWithData:imgData]];
            }else{
                [HUD showUIBlockingIndicator];
                dispatch_async(
                               
                               dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                   
                                   imageUrls *imgUrl=[images objectAtIndex:count-1];
                                   UIImage *img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrl.imageName]]]];
                                   
                                   dispatch_sync(dispatch_get_main_queue(), ^{
                                       
                                       NSData *imgData=UIImageJPEGRepresentation(img, 0.1);
                                       NSString *imagepath=[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konuImage%d.jpeg",count]];
                                       [imgData writeToFile:imagepath atomically:YES];
                                       [HUD hideUIBlockingIndicator];
                                       [[self imageView] setImage:img];
                                       
                                   });
                               });
            }
            
        }else{
           
            images=[db getimageUrlsFromDatabase:@"select *from imageUrls"];
            //imageUrls *i=(imageUrls *)[images objectAtIndex:count];
            
            NSFileManager *manger=[NSFileManager defaultManager];
            NSString* imagePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konusanImage%d.jpeg",count]];
            BOOL available= [manger fileExistsAtPath:imagePath];
            
            if (available) {
                NSLog(@"file exists");
                NSData *imgData=[NSData dataWithContentsOfFile:imagePath];
                
                [[self imageView] setImage:[UIImage imageWithData:imgData]];
            }else{
                [HUD showUIBlockingIndicator];
                dispatch_async(
                               
                               dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                   
                                   imageUrls *imgUrl=[images objectAtIndex:count-1];
                                   UIImage *img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrl.imageName]]]];
                                   
                                   dispatch_sync(dispatch_get_main_queue(), ^{
                                       
                                       NSData *imgData=UIImageJPEGRepresentation(img, 0.1);
                                       NSString *imagepath=[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konusanImage%d.jpeg",count]];
                                       [imgData writeToFile:imagepath atomically:YES];
                                       [HUD hideUIBlockingIndicator];
                                       [[self imageView] setImage:img];
                                       
                                   });
                               });
            }
        }
        
    }
    
    
    
    
    
    
    
    
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
//    dataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyFolder"];
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
//        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
//    }//Create folder
//    
//    
//    
//    NSArray *checkdbImages=[db getimageUrlsFromDatabase:[NSString stringWithFormat:@"select *from imageUrls"]];
//    if (checkdbImages.count==0) {
//        [HUD showUIBlockingIndicator];
//        
//        //        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        //        NSString* foofile = [documentsPath stringByAppendingPathComponent:@"images"];
//        //        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
//        //        NSLog(@"%hhd",fileExists);
//        
//        dispatch_async(
//                       
//                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                           
//                           
//                           
//                           for (int i=0; i<imageurlsarr.count; i++) {
//                               UIImage * img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[imageurlsarr objectAtIndex:i] valueForKey:@"pageLink"]]]]];
//                               if (img!=nil) {
//                                   
//                                   NSData *imgData=UIImageJPEGRepresentation(img, 0.1);
//                                   NSString *imagepath=[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konuImage%d.jpeg",i]];
//                                   [imgData writeToFile:imagepath atomically:YES];
//                                   
//                                   imageUrls *saveimagesTodb=[[imageUrls alloc]init];
//                                   saveimagesTodb.imageName=[NSString stringWithFormat:@"konuImage%d.jpeg",i];
//                                   saveimagesTodb.rowDate=[[imageurlsarr objectAtIndex:i] valueForKey:@"rowDate"];
//                                   [db insertimages:saveimagesTodb];
//                                   
//                               }
//                           }
//                           
//                           //UIImage *img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://eksen2.sbtanaliz.com/keys/katalog/sayfa_%d.jpg",count]]]];
//                           dispatch_sync(dispatch_get_main_queue(), ^{
//                               
//                               images=[db getimageUrlsFromDatabase:@"select *from imageUrls"];
//                               imageUrls *i=(imageUrls *)[images objectAtIndex:0];
//                               NSLog(@"image name %@",i.imageName);
//                               NSString *imagePath=[dataPath stringByAppendingPathComponent:i.imageName];
//                               NSData *imgData=[NSData dataWithContentsOfFile:imagePath];
//                               
//                               [[self imageView] setImage:[UIImage imageWithData:imgData]];
//                               [HUD hideUIBlockingIndicator];
//                           });
//                       });
//        
//        
//    }else{
//        
//        images=[db getimageUrlsFromDatabase:@"select *from imageUrls"];
//        imageUrls *i=(imageUrls *)[images objectAtIndex:0];
//        NSLog(@"image name %@",i.imageName);
//        NSString *rowdateFromWeb=[[imageurlsarr objectAtIndex:0] valueForKey:@"rowDate"];
//        
//        if (![rowdateFromWeb isEqualToString:i.rowDate]) {
//            [db deleteimageUrls];
//            NSFileManager *manager=[NSFileManager defaultManager];
//            for (NSString *file in [manager contentsOfDirectoryAtPath:dataPath error:&error]) {
//                NSString *ppath=[dataPath stringByAppendingPathComponent:file];
//                BOOL success = [manager removeItemAtPath:ppath error:&error];
//                NSLog(@"%@",[error localizedDescription]);
//                if (success) {
//                    NSLog(@"deleted");
//                }
//            }
//            //[self saveAllImageUrls];
//            
//            [HUD showUIBlockingIndicator];
//            //            NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//            //            NSString* foofile = [documentsPath stringByAppendingPathComponent:@"images"];
//            //            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
//            //            NSLog(@"%hhd",fileExists);
//            
//            dispatch_async(
//                           
//                           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                               
//                               for (int i=0; i<imageurlsarr.count; i++) {
//                                   UIImage * img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[imageurlsarr objectAtIndex:i] valueForKey:@"pageLink"]]]]];
//                                   if (img!=nil) {
//                                       
//                                       NSData *imgData=UIImageJPEGRepresentation(img, 0.1);
//                                       NSString *imagepath=[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konuImage%d.jpeg",i]];
//                                       [imgData writeToFile:imagepath atomically:YES];
//                                       
//                                       imageUrls *saveimagesTodb=[[imageUrls alloc]init];
//                                       saveimagesTodb.imageName=[NSString stringWithFormat:@"konuImage%d.jpeg",i];
//                                       saveimagesTodb.rowDate=[[imageurlsarr objectAtIndex:i] valueForKey:@"rowDate"];
//                                       [db insertimages:saveimagesTodb];
//                                       
//                                   }
//                               }
//                               
//                               //UIImage *img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://eksen2.sbtanaliz.com/keys/katalog/sayfa_%d.jpg",count]]]];
//                               dispatch_sync(dispatch_get_main_queue(), ^{
//                                   
//                                   images=[db getimageUrlsFromDatabase:@"select *from imageUrls"];
//                                   imageUrls *i=(imageUrls *)[images objectAtIndex:0];
//                                   NSLog(@"image name %@",i.imageName);
//                                   NSString *imagePath=[dataPath stringByAppendingPathComponent:i.imageName];
//                                   NSData *imgData=[NSData dataWithContentsOfFile:imagePath];
//                                   
//                                   [[self imageView] setImage:[UIImage imageWithData:imgData]];
//                                   [HUD hideUIBlockingIndicator];
//                               });
//                           });
//            
//        }else{
//            
//            NSString *imagePath=[dataPath stringByAppendingPathComponent:i.imageName];
//            NSData *imgData=[NSData dataWithContentsOfFile:imagePath];
//            
//            [[self imageView] setImage:[UIImage imageWithData:imgData]];
//        }
//    }
    
}



-(void)BackAction{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Clicked:(id)sender {
    [_scrollView setZoomScale:1.0];
    UIButton *button=(UIButton *)sender;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
//    NSString *mydataPath = [documentsDirectory stringByAppendingPathComponent:@"/MyFolder"];
    //  [self.scrollView zoomToRect:rectToZoomOutTo animated:NO];
    if (button.tag==1) {
        [nextButton setHidden:YES];
        if (count==1) {
            [privousButton setHidden:YES];
        }
        if (count>1){
            count--;
            
            NSFileManager *manger=[NSFileManager defaultManager];
            NSString* imagePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konusanImage%d.jpeg",count]];
            BOOL available= [manger fileExistsAtPath:imagePath];
            
            if (available) {
                NSLog(@"file exists");
                NSData *imgData=[NSData dataWithContentsOfFile:imagePath];
                
                [[self imageView] setImage:[UIImage imageWithData:imgData]];
            }else{
                [HUD showUIBlockingIndicator];
                dispatch_async(
                               
                               dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                   
                                   imageUrls *imgUrl=[images objectAtIndex:count-1];
                                   UIImage *img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrl.imageName]]]];
                                   
                                   dispatch_sync(dispatch_get_main_queue(), ^{
                                       
                                       NSData *imgData=UIImageJPEGRepresentation(img, 0.1);
                                       NSString *imagepath=[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konusanImage%d.jpeg",count]];
                                       [imgData writeToFile:imagepath atomically:YES];
                                       [HUD hideUIBlockingIndicator];
                                       [[self imageView] setImage:img];
                                       
                                   });
                               });
            }

            
//            imageUrls *i=(imageUrls *)[images objectAtIndex:count-1];
//            NSLog(@"image name %@",i.imageName);
//            NSString *imagePath=[dataPath stringByAppendingPathComponent:i.imageName];
//            NSData *imgData=[NSData dataWithContentsOfFile:imagePath];
//            
//            [[self imageView] setImage:[UIImage imageWithData:imgData]];
            
            
        }
    }else{
        [privousButton setHidden:NO];
        if (count<images.count) {
            
            count++;
            if (count==images.count) {
                [nextButton setHidden:YES];
            }
            
            NSFileManager *manger=[NSFileManager defaultManager];
            NSString* imagePath = [dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konusanImage%d.jpeg",count]];
            BOOL available= [manger fileExistsAtPath:imagePath];
            
            if (available) {
                NSLog(@"file exists");
                NSData *imgData=[NSData dataWithContentsOfFile:imagePath];
                
                [[self imageView] setImage:[UIImage imageWithData:imgData]];
            }else{
                [HUD showUIBlockingIndicator];
                dispatch_async(
                               
                               dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                   
                                   imageUrls *imgUrl=[images objectAtIndex:count-1];
                                   UIImage *img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgUrl.imageName]]]];
                                   
                                   dispatch_sync(dispatch_get_main_queue(), ^{
                                       
                                       NSData *imgData=UIImageJPEGRepresentation(img, 0.1);
                                       NSString *imagepath=[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"konusanImage%d.jpeg",count]];
                                       [imgData writeToFile:imagepath atomically:YES];
                                       [HUD hideUIBlockingIndicator];
                                       [[self imageView] setImage:img];
                                       
                                   });
                               });
            }

//            imageUrls *i=(imageUrls *)[images objectAtIndex:count-1];
//            NSLog(@"image name %@",i.imageName);
//            NSString *imagePath=[dataPath stringByAppendingPathComponent:i.imageName];
//            NSData *imgData=[NSData dataWithContentsOfFile:imagePath];
//            
//            [[self imageView] setImage:[UIImage imageWithData:imgData]];
        }
    }
    
    
}


/*//    [HUD showUIBlockingIndicator];
 //    dispatch_async(
 //
 //                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
 //                       UIImage * img = [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://eksen2.sbtanaliz.com/keys/katalog/sayfa_%d.jpg",count]]]];
 //                       dispatch_sync(dispatch_get_main_queue(), ^{
 //                           [[self imageView] setImage:img];
 //                           [HUD hideUIBlockingIndicator];
 //                       });
 //                   });
 */

@end
