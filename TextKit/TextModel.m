//
//  TextModel.m
//  TextKit
//
//  Created by sah-fueled on 13/12/13.
//  Copyright (c) 2013 fueled.co. All rights reserved.
//

#import "TextModel.h"

#define kContainerCount 5

@interface TextModel() <NSLayoutManagerDelegate>

@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, assign) int numberOfContainers;
@property (nonatomic, assign) int selectedContainerIndex;
@property (nonatomic, assign) CGSize sizeOfContainer;


@end

static TextModel *sharedTextModel = nil;
@implementation TextModel

+ (TextModel *) sharedModel{
  if(sharedTextModel == nil){
    sharedTextModel = [[TextModel alloc] init];
  }
  return sharedTextModel;
}

- (TextModel *) init{
  self.layoutManager = [[NSLayoutManager alloc]init];
  self.numberOfContainers = kContainerCount;
  NSString *string = @"[1] A. T. Velte, T. J. Velte and R. Elsenpeter, CloudComputing – A Practical Approach, Wiley Publishing,Inc. 2011.\n[2] B. Sosinsky, Cloud Computing Bible, McGraw-Hill Companies,2010.\n[3] (2011) The OpenNebula website [Online]. Available :http://www.opennebula.org/\n[4] (2011) OpenNebula VirtualBox driver plugin (OneVBox). [Online]. Available: http:// github.com/hsanjuan/OneVBox /\n[5] (2011) OpenNebula Workshop. [Online].Available: http://hpc.uamr.de/wissen/opennebula-workshop/OpenNebula workshop.\n[6] R.S. Montero, “Building Clouds with OpenNebula 1.4,” CESGA Santiago de Compostela, Spain, January 2010.\n[7] R.S. Montero,” Deployment of Private and Hybrid Clouds Using OpenNebula/ RESERVOIR”, Open Grid Forum 28, March 15-18, 2010.\n[8] M. A. Morsy, J. Grundy, and I. Miller, “An Analysis of The Cloud Computing Security Problem,” in Proc. APSEC, 2010 Cloud Workshop.\n[9] A.S. Ibrahim, J. Hamlyn-Harris, and J. Gurundy, “Emerging Security Challenges of Cloud Virtual Infrastructure,” in Proc. APSEC, 2010 Cloud Workshop.\n[10] T. Ristenpart, E. Tromer, H. Shacham, and S. Savage, “Hey, You, Get Off of My Cloud: Exploring Information Leakage in Third-Party Compute Clouds”, Proc. 16th ACM Conf. Computer and Communication Security (CCS 09), ACM Press, 2009, pp. 119- 212.doi: dx.doi.org/10.1145/1653662.1653687.\n[11] W. Dawoud, I. Takouna, and C. Meinel,” Infrastructure as a service security: Challenges and solutions,” The 7th International Conference on Informatics and Systems (INFOS), pp.1-8, March. 2010.\n[12] H. Tsai, M.Siebenhaar, A. Miede, Y. Huang, and R. Steinmetz, “Threat as a Service? Virtualization’s Impact on Cloud Security”, IT Professional,vol. 14, no. 1, pp.32-37.\n[13] F. Sabahi, “Cloud Computing Security Threats and Responses”, 3rd International Conference on Communication Software and Networks (ICCSN), IEEE,2011, pp.245-249.doi: dx.doi.org/10.1109/ICCSN.2011.6014715.\n[14] M. Zhou, R. Zhang, W. Xie, W. Qian, and A. Zhou,” Security and Privacy in Cloud Computing: A Survey,” The 6th International Conference on Semantics, Knowledge and Grid (SKG), Nov. 2010,pp.1 05-111.doi: dx.doi.org/10.1109/SKG.2010.19.\n[15] S. Horrow, S. Gupta, and A. Sardana, “Implementation of Private Cloud at IIT Roorkee: An Initial Experience”, in International Workshop on Cloud Computing & Identity Management (CloudID 2012). in press.";
  self.textStorage = [[NSTextStorage alloc]initWithString:string];
  [self.textStorage addLayoutManager:self.layoutManager];
  self.layoutManager.delegate = self;
  self.selectedContainerIndex = 0;
  if(self.layoutManager.textContainers.count == 0){
    for(int i = 0 ; i < self.numberOfContainers ; i++){
      NSTextContainer *container = [[NSTextContainer alloc]init];
      [self.layoutManager addTextContainer:container];
    }
  }
  return self;
}

- (void) setContainerSize:(CGSize) size{
  self.sizeOfContainer = size;
  for(int i = 0 ; i < self.numberOfContainers ; i++){
    NSTextContainer *container = [self.layoutManager.textContainers objectAtIndex:i];
    [container setSize:self.sizeOfContainer];
  }
}

- (CGSize) getContainerSize{
  return self.sizeOfContainer;
}

- (NSTextContainer *) containerAtIndex:(int)index{
  return [[self.layoutManager textContainers]objectAtIndex:index];
}

- (NSTextContainer *) selectedContainer{
  return [[self.layoutManager textContainers]objectAtIndex:self.selectedContainerIndex];
}

- (void) setContainerSelectedAtIndex:(int)index{
  self.selectedContainerIndex = index;
}

- (int) containerCount{
  return [self.layoutManager.textContainers count];
}

#pragma mark - NSLayoutManagerDelegate methods

- (CGFloat) layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect{
  return 3.0;
}

- (CGFloat) layoutManager:(NSLayoutManager *)layoutManager paragraphSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect{
  return 5.0;
}

@end
