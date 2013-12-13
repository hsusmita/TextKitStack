//
//  ViewController.m
//  TextKit
//
//  Created by sah-fueled on 10/12/13.
//  Copyright (c) 2013 fueled.co. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSLayoutManagerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSLayoutManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

// [self.textView setText:@"[1] A. T. Velte, T. J. Velte and R. Elsenpeter, CloudComputing – A\nPractical Approach, Wiley Publishing,Inc. 2011.\n[2] B. Sosinsky, Cloud Computing Bible, McGraw-Hill Companies,2010.\n[3] (2011) The OpenNebula website [Online]. Available :http://www.opennebula.org/\n[4] (2011) OpenNebula VirtualBox driver plugin (OneVBox). [Online]. Available: http:// github.com/hsanjuan/OneVBox /\n[5] (2011) OpenNebula Workshop. [Online].Available: http://hpc.uamr.de/wissen/opennebula-workshop/OpenNebula workshop.\n[6] R.S. Montero, “Building Clouds with OpenNebula 1.4,” CESGA Santiago de Compostela, Spain, January 2010.\n[7] R.S. Montero,” Deployment of Private and Hybrid Clouds Using OpenNebula/ RESERVOIR”, Open Grid Forum 28, March 15-18, 2010.\n[8] M. A. Morsy, J. Grundy, and I. Miller, “An Analysis of The Cloud Computing Security Problem,” in Proc. APSEC, 2010 Cloud Workshop.\n[9] A.S. Ibrahim, J. Hamlyn-Harris, and J. Gurundy, “Emerging Security Challenges of Cloud Virtual Infrastructure,” in Proc. APSEC, 2010 Cloud Workshop.\n[10] T. Ristenpart, E. Tromer, H. Shacham, and S. Savage, “Hey, You, Get Off of My Cloud: Exploring Information Leakage in Third-Party Compute Clouds”, Proc. 16th ACM Conf. Computer and Communication Security (CCS 09), ACM Press, 2009, pp. 119- 212.doi: dx.doi.org/10.1145/1653662.1653687.\n[11] W. Dawoud, I. Takouna, and C. Meinel,” Infrastructure as a service security: Challenges and solutions,” The 7th International Conference on Informatics and Systems (INFOS), pp.1-8, March. 2010.\n[12] H. Tsai, M.Siebenhaar, A. Miede, Y. Huang, and R. Steinmetz, “Threat as a Service? Virtualization’s Impact on Cloud Security”, IT Professional,vol. 14, no. 1, pp.32-37.\n[13] F. Sabahi, “Cloud Computing Security Threats and Responses”, 3rd International Conference on Communication Software and Networks (ICCSN), IEEE,2011, pp.245-249.doi: dx.doi.org/10.1109/ICCSN.2011.6014715.\n[14] M. Zhou, R. Zhang, W. Xie, W. Qian, and A. Zhou,” Security and Privacy in Cloud Computing: A Survey,” The 6th International Conference on Semantics, Knowledge and Grid (SKG), Nov. 2010,pp.1 05-111.doi: dx.doi.org/10.1109/SKG.2010.19.\n [15] S. Horrow, S. Gupta, and A. Sardana, “Implementation of Private Cloud at IIT Roorkee: An Initial Experience”, in International Workshop on Cloud Computing & Identity Management (CloudID 2012). in press."];
  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapRecognized:)];
  singleTap.numberOfTapsRequired = 1;
  [self.textView addGestureRecognizer:singleTap];
//  [self showLetterPressEffect];
//  [self findLastCharacter];

}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
//  NSString *text = [self.textView text];
//  UIFont *font = [self.textView font];
//
//  CGRect rect = [text boundingRectWithSize:CGSizeMake(300.0, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:font.fontName size:(font.pointSize+2)],NSFontAttributeName, nil] context:nil];
//
//  NSLog(@"%f-%f, %f X %f",rect.origin.x, rect.origin.y,rect.size.width, rect.size.height);
//  rect.origin = self.textView.frame.origin;
//  [self.textView setFrame:rect];
//  self.textView.backgroundColor = [UIColor whiteColor];

}

- (void) singleTapRecognized:(UITapGestureRecognizer *) tap{
  CGFloat x = 1.0;
  CGPoint point = [tap locationInView:self.textView];
  point.x -= self.textView.textContainerInset.left;
  point.y -= self.textView.textContainerInset.top;

  NSLog(@"point: x = %f y = %f",point.x,point.y);
  int index = [self.textView.layoutManager characterIndexForPoint:point
                                                  inTextContainer:self.textView.textContainer
                         fractionOfDistanceBetweenInsertionPoints:&x];
  NSLog(@"Index = %d",index);
  NSLog(@"Index = %c", [ self.textView.text characterAtIndex:index]);
  NSRange range = NSMakeRange(index, 50);
  CGRect fragment = [self.textView.layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&range];
  NSLog(@"Fragment = %f %f %fx%f",fragment.origin.x,fragment.origin.y,fragment.size.width,fragment.size.height);
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) showLetterPressEffect{
  NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor greenColor],
                               NSBackgroundColorAttributeName : [UIColor whiteColor],
                               NSTextEffectAttributeName : NSTextEffectLetterpressStyle};
  NSAttributedString *string = [[NSAttributedString alloc]initWithString:@"Hello" attributes:attributes];
  [self.label setAttributedText:string];
  
}

- (void) findLastCharacter{
  NSLayoutManager *layoutManager = self.textView.layoutManager;
  NSUInteger characterIndex = self.textView.textStorage.length - 1;
  NSUInteger glyphIndex = [layoutManager glyphIndexForCharacterAtIndex:characterIndex];
  CGRect rect = [layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange:NULL];
  CGPoint glyphLocation = [layoutManager locationForGlyphAtIndex:glyphIndex];
  glyphLocation.x += CGRectGetMinX(rect);
  glyphLocation.y += CGRectGetMinY(rect);
  NSLog(@"position : x = %f y = %f",glyphLocation.x,glyphLocation.y);
}

@end
