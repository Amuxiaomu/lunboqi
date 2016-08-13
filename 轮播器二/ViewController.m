//
//  ViewController.m
//  轮播器二
//
//  Created by Amuxiaomu on 16/8/11.
//  Copyright © 2016年 Amuxiaomu. All rights reserved.
//

#import "ViewController.h"

#define RANDOMCOLOR [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0]
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#define Margin 5
#define MarginPageControl 30

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * collectioView;

@property (nonatomic, strong)UIPageControl * pageControl;

@property (nonatomic, strong)NSArray * dataArray;
// 记录上一次的index;  未实现
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)NSTimer * timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectioView.dataSource = self;
    self.collectioView.delegate = self;
    
    [self.collectioView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [self setupUI];
    
    [self setTimer];
    
    
     
}


- (void)setupUI{
    [self.view addSubview:self.collectioView];
    
    [self.view addSubview:self.pageControl];
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.dataArray.count;
    
    self.pageControl.center = CGPointMake(SCREENW/2, SCREENH - MarginPageControl);
}

- (void)setTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loopCollectionView) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)loopCollectionView{
    
    self.index += 1;
    NSInteger section = 1 + self.index/self.dataArray.count;
    self.index = self.index%self.dataArray.count;
    NSLog(@"%d,%d",section,self.index);
    [self.collectioView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:section] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

#pragma mark
#pragma mark - UICollectionViewDateSouurce -
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImage * image = [UIImage imageNamed:self.dataArray[indexPath.item]];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    //imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageView.frame = CGRectMake(0, 0, SCREENW, SCREENH);
    [cell addSubview:imageView];
    cell.backgroundColor = RANDOMCOLOR;
    
    return cell;
}

#pragma mark
#pragma mark - UICollectionViewDelegate -
// 滚动完成后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self dealToScallDidEnd];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
   [self dealToScallDidEnd];
}

- (void)dealToScallDidEnd{
    NSInteger index = self.collectioView.contentOffset.x / SCREENW;
    
    index = index%self.dataArray.count;
    
    self.index = index;
    
    self.pageControl.currentPage = self.index;
    
    [self.collectioView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:1] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setTimer];
}
#pragma mark
#pragma mark - 懒加载

- (UICollectionView * )collectioView{
    
    if (_collectioView == nil) {
        UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.itemSize = self.view.bounds.size;
        flowlayout.minimumLineSpacing = 0;
        flowlayout.minimumInteritemSpacing = 0;
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectioView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowlayout];
        
        _collectioView.pagingEnabled = YES;
        _collectioView.bounces = NO;
        _collectioView.showsVerticalScrollIndicator = NO;
        _collectioView.showsHorizontalScrollIndicator = YES;
        [_collectioView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    
    return _collectioView;
}
- (NSArray * )dataArray{
    if (_dataArray == nil) {
        _dataArray = @[@"btn_07.JPG",@"btn_08.JPG",@"btn_09.JPG",@"btn_10.JPG"];
    }
    return _dataArray;
}
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
    }
    return _pageControl;
}

@end
