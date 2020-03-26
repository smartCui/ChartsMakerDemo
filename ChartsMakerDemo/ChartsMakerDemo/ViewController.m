//
//  ViewController.m
//  ChartsMakerDemo
//
//  Created by cui on 2020/3/26.
//  Copyright © 2020 ZhiBan. All rights reserved.
//

#import "ViewController.h"
#import <Charts/Charts-Swift.h>
#import "CustomerMarkerVIew.h"

@interface ViewController ()<ChartViewDelegate>

@property (nonatomic, strong) LineChartView *lineChartView;
@property (nonatomic, strong) CustomerMarkerVIew *customMarkerView;

@end

@implementation ViewController

//屏幕宽度 & 高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lineChartView = [[LineChartView alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 300)];
    [self.view addSubview:self.lineChartView];
    //-------------------------------折线图的配置-----------------------------------------
    // 设置代理
    // ChartViewDelegate,IChartAxisValueFormatter
    _lineChartView.delegate = self;
    
    // 距离边缘的间隙
    [_lineChartView setExtraOffsetsWithLeft:30 top:0 right:30 bottom:10];
    
    // noDataText 没有数据的时候的展示
    _lineChartView.noDataText = @"暂无客户跟进分析数据";
    _lineChartView.noDataFont = [UIFont systemFontOfSize:15];
    _lineChartView.noDataTextColor = [UIColor blackColor];
    
    // 是否开启描述label
    _lineChartView.chartDescription.enabled = YES;
    
    //   取消XY轴缩放
    _lineChartView.scaleYEnabled = YES;
    _lineChartView.scaleXEnabled = YES;
    
    // 取消双击缩放
    _lineChartView.doubleTapToZoomEnabled = NO;
    // 启用拖拽
    _lineChartView.dragEnabled = YES;
    // 拖拽后是否有惯性效果
    _lineChartView.dragDecelerationEnabled = YES;
    // 是否显示图例
    _lineChartView.legend.enabled = YES;
    // 拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    _lineChartView.dragDecelerationFrictionCoef = 0.9;
    
    //------------------ Y轴设置----------------
    // 是否绘制右边轴
    _lineChartView.rightAxis.enabled = NO;
    
    // 获取左边Y轴
    ChartYAxis *leftAxis = _lineChartView.leftAxis;
    
    // Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    leftAxis.labelCount=4;
    // 是否强制绘制指定数量的labe
    leftAxis.forceLabelsEnabled = YES;
    // 设置y轴线宽
    leftAxis.axisLineWidth=0;
    //  设置y轴颜色
    leftAxis.axisLineColor=[UIColor blackColor];
    // 设置Y轴的最小最大值
    leftAxis.axisMaximum=100;
    leftAxis.axisMinimum=0;
    
    //调整label位置
    leftAxis.labelXOffset = 0;
    leftAxis.labelAlignment = NSTextAlignmentCenter;
    // 是否将Y轴进行上下翻转
    leftAxis.inverted=NO;
    // label位置（像里像外 枚举类型）
    leftAxis.labelPosition = 0;
    // Y轴label文字颜色
    leftAxis.labelTextColor= [UIColor blackColor];
    // Y轴label字体
    leftAxis.labelFont = [UIFont systemFontOfSize:12];
    // 设置虚线样式的网格线
    //    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];
    // 网格线颜色
    leftAxis.gridColor = [UIColor blackColor];
    leftAxis.gridLineWidth = 2;
    // 开启抗锯齿
    leftAxis.gridAntialiasEnabled = YES;
    
    //不显示ZeroLine
    leftAxis.drawZeroLineEnabled = NO;
    
    //------------------------配置X轴------------------------
    // 获取X轴
    ChartXAxis *xAxis = _lineChartView.xAxis;
    // X轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
    xAxis.labelCount=7;
    // 是否强制绘制指定数量的labe
    xAxis.forceLabelsEnabled = YES;
    // 设置X轴线宽
    xAxis.axisLineWidth= 0;
    // 设置X轴颜色
    xAxis.axisLineColor= [UIColor blackColor];
    // 设置X轴的最小最大值
    xAxis.axisMaximum=6;
    xAxis.axisMinimum=0;
    
    // label位置（像里像外 枚举类型）
    xAxis.labelPosition = 1;
    // X轴label文字颜色
    xAxis.labelTextColor= [UIColor blackColor];
    // X轴label字体
    xAxis.labelFont = [UIFont systemFontOfSize:12];
    
    //不设置网格
    xAxis.drawGridLinesEnabled = NO;
    xAxis.gridAntialiasEnabled = NO;
    // 设置虚线样式的网格线
    xAxis.gridLineDashLengths = @[@3.0f, @3.0f];
    // 网格线颜色
    xAxis.gridColor = [UIColor whiteColor];
    
    // 开启抗锯齿
    xAxis.gridAntialiasEnabled = YES;
    
    //----------------------配置图例----------------------
    // 是否开启图例
    _lineChartView.legend.enabled = NO;
    //----------------------配置折现图上面的浮层--------------
    // 设置浮层
    _lineChartView.drawMarkers = YES;
    ChartMarkerView * makerView = [[ChartMarkerView alloc]init];
    makerView.offset = CGPointMake(-self.customMarkerView.frame.size.width/2,-self.customMarkerView.frame.size.height);
    makerView.chartView = _lineChartView;
    _lineChartView.marker = makerView;
    [makerView addSubview:self.customMarkerView];
    
    LineChartData *lineData = [self setLineChartViewDataSet];
    xAxis.axisMinimum = xAxis.axisMinimum - 0.5f;
    xAxis.axisMaximum = xAxis.axisMaximum + 0.5f;
    [self.lineChartView setData:lineData];
    
    // 设置动画
    [self.lineChartView animateWithXAxisDuration:1.0f];
    [self.lineChartView animateWithYAxisDuration:1.0f];
}

#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight{
    NSLog(@"chartValueSelected");
    //将点击的数据滑动到中间
    //    [_lineView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_lineView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
    [self.customMarkerView setMarkerViewWithX:(NSInteger)entry.x y:(NSInteger)entry.y];
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView{
    NSLog(@"chartValueNothingSelected");
}



- (LineChartData *)setLineChartViewDataSet{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++){
        double y = (arc4random()%100)+1;
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:y]];
    }
    
    LineChartDataSet *lineSet = nil;
    if (_lineChartView.data.dataSetCount > 0){
        lineSet = (LineChartDataSet *)_lineChartView.data.dataSets[0];
        [lineSet replaceEntries: values];
        [_lineChartView.data notifyDataChanged];
        [_lineChartView notifyDataSetChanged];
        
    }else{
        // 初始化折线对象
        lineSet = [[LineChartDataSet alloc] initWithEntries:values label:@""];
        //---------------------------设置折线对象的属性-------------------
        // 设置折线对象的类型（枚举）
        lineSet.mode=0;
        // 折线本身的颜色
        [lineSet setColor:UIColor.redColor];
        
        // 折线上的数值的颜色
        lineSet.valueColors=@[UIColor.redColor];
        // 不显示折线点的数值
        lineSet.drawValuesEnabled = NO;
        
        // 折线图上是否带圆
        lineSet.drawCirclesEnabled = YES;
        // 是否填充颜色
        lineSet.drawFilledEnabled = YES;
        // 圆的半径
        lineSet.circleRadius=6.0f;
        // 是否画空心圆
        lineSet.drawCircleHoleEnabled = YES;
        // 空心圆的半径
        lineSet.circleHoleRadius = 3;
        // 空心圆的颜色
        lineSet.circleHoleColor = UIColor.redColor;
        
        // 拐点颜色
        [lineSet setCircleColor:[UIColor whiteColor]];
        // 是否绘制拐点
        lineSet.drawCirclesEnabled = YES;
        
        // 设置折线下方的渐变色
        NSArray *gradientColors = @[
            (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
            (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor];
        
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        lineSet.fillAlpha = 1.f;
        lineSet.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        lineSet.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        //-------------------------------十字线的配置-----------------------------
        // 选中拐点,是否开启高亮效果(显示十字线)
        lineSet.highlightEnabled = YES;
        // 点击选中拐点的十字线的颜色
        lineSet.highlightColor= UIColor.redColor;
        // 十字线宽度
        lineSet.highlightLineWidth = 0.5;
        // 设置十字线的虚线宽度
        lineSet.highlightLineDashLengths = @[@5,@5];
    }
    //---------------------------------设置数据----------------------------
    LineChartData *lineData = [[LineChartData alloc] initWithDataSet:lineSet];
    return lineData;
}




-(CustomerMarkerVIew *)customMarkerView{
    if (!_customMarkerView) {
        _customMarkerView = [[CustomerMarkerVIew alloc] initWithFrame:CGRectMake(0, 0, 130, 56)];
    }
    return _customMarkerView;
}

@end
