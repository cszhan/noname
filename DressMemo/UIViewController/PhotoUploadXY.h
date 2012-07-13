//
//  PhotoUploadXY.h
//  DressMemo
//
//  Created by  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef DressMemo_PhotoUploadXY_h
#define DressMemo_PhotoUploadXY_h

//for pickview 
#define kUploadPickViewTextColor HexRGB(134,134,134)

#define kUploadPhotoTextFont_SYS(x)             [UIFont systemFontOfSize:x]
#define kUploadPhotoTextFont_SYS_15             [UIFont systemFontOfSize:15]
#define kUploadPhotoTextFont_SYS_24             [UIFont systemFontOfSize:24]
#define kUploadProcessTextFont_SYS_20           [UIFont systemFontOfSize:20]


#define kPhotoUploadImageSizeX   640.f//627.f
//for photo upload
#define kPhotoUploadStartMaxPicCount        3

#define kUploadChooseX      
#define kUploadChooseY  

#define kUploadFromCameraX      0.f
#define kUpladFromCameraY       252/2-20.f

#define kUploadFromAlbumX      170.f
#define kUpladFromAlbumY       252/2-20.f

#define kPhotoUploadStartDefaultImageName   @"defaultpic.png"

#define kUploadNoChooseTextColor        [UIColor lightGrayColor]

#define kUploadChooseTextColor          HexRGB(70,70,70) //[UIColor blackColor]

//tag choose
#define kUploadTagChoosNavItemRightTextColor  HexRGB(202,48,48)

#define kPhotoUploadStartMaskImageY 124/2.f

#define kPhotoUploadStartImageX (20.f/2.f)//(30.f/2.f)
#define kPhotoUploadStartImageY (20.f/2.f)//(30.f/2.f)

#define kPhotoUploadStartImageW (320.f/2.f) //300.f/2.f
#define kPhotoUploadStartImageH (429.f/2.f )//454.f/2.f

#define kPhotoUploadScrollerPagePendingX (48.f/4.f)

#define kPhotoUploadStartScrollerW (368.f/2.f+(kPhotoUploadScrollerPagePendingX*2.f))
#define kPhotoUploadStartScrollerH (524.f/2.f)//(532.f/2.f)

#define kPhotoUploadStartImageBGX  ((320-kPhotoUploadStartScrollerW)/2)//140.f/2.f
#define kPhotoUploadStartImageBGY  224.f/2.f

#define kPhotoUploadStartImageBGW   368/2.f
#define kPhotouploadStartImageBGH   

#define kPhotoUploadMarkScrollerPagePendingX (50.f/4.f)

//for tag image 
#define kPhotoUploadMarkTagImageMaxW  (500/2.f)
#define kPhotoUploadMarkTagImageMaxH  (670/2.f)

#define kPhotoUploadMarkTagImageNomarlW (460/2.f)
#define kPhotoUploadMarkTagImageNomarlH (616/2.f)

#define kPhotoUploadMarkScrollerW (460.f/2.f+(kPhotoUploadMarkScrollerPagePendingX*2.f))
#define kPhotoUploadMarkScrollerH (616.f/2.f)//(532.f/2.f)

#define kPhotoUploadMarkTagImageBGX  ((320-kPhotoUploadMarkScrollerW)/2)



#define kPhotoUploadMarkTagImageScaleW (kPhotoUploadMarkTagImageMaxW/kPhotoUploadMarkTagImageNomarlW)
#define kPhotoUploadMarkTagImageScaleH (kPhotoUploadMarkTagImageMaxH/kPhotoUploadMarkTagImageNomarlH)


#define kPhtoUploadProcessBrandViewCenterY        358.f/2.f
#define kPhotoUploadProcessIndicatorRect    CGRectMake(0.f,0.f,260.f,30.f)

#define kPhotoUploadProcessIndicatorTextRect CGRectMake(0.f,0.f,0.f,0.f)


#define kPhotoUploadBrandChoosePendingX    40.f
#define kPhotoUploadBrandItemGapH          (38.f/2.f)

#define kPhotoUploadPointScaleX        kPhotoUploadImageSizeX/kPhotoUploadMarkTagImageMaxW


#endif
