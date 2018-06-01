# UIAnimationTest
基本常用核心动画

## 来源
本demo中的例子基本来源于喵神的[ios核心动画高级技巧](https://zsisme.gitbooks.io/ios-/content/)，记录下来以备以后用到时查阅。

### 阅读简单总结

1. Core Animation并不只是来做动画用的，他是UIKit及视图显示的基础。

2. UIView与CALayer的关系

   1. layer处理视图显示，UIResponder来处理事件响应。
   2. view的属性都由layer映射而来，view是layer的delegate。
   3. UIView禁用了layer隐式动画，layer样式修改会触发隐式动画。

3. UIView非常方便，layer存在的意义？

   layer可以处理一些view不能做的功能，如：

   1. 3D交换
   2. 阴影/圆角/边框
   3. mask
   4. 非线性动画

4. CALayer包含三层结构：

   1. presentLayer Tree(呈现树)—>动画
   2. modeLayer Tree(模型树)—>最终显示效果
   3. render Tree (渲染树)

5. CA的专有图层

   1. CAShapLayer 动态绘图
   2. Text 文本
   3. Transform 组变换
   4. Gradient 渐变色
   5. Replicator 图层复制
   6. Scroll 
   7. Tiled 大图加载
   8. Emitter 粒子效果
   9. EAGL
   10. Player 播放器

6. 动画


   1. CATransaction动画

      ```objective-c
      [CATransaction begin]; 
      [CATransaction setAnimationDuration:1.0];
      [CATransaction setCompletionBlock:{
        
      }]; 
      [CATransaction commit]; 

      //但view自带layer默认给关闭了动画响应
      //-actionForLayer:forKey返回值为nil

      //也可以手动关闭动画
      [CATransaction setDisableActions:YES];

      //自定义动作
      CATransition *transition = [CATransition animation];
      transition.type = kCATransitionPush;
      transition.subtype = kCATransitionFromLeft;
      self.colorLayer.actions = @{@"backgroundColor": transition};
      ```



   2. 属性动画

      ```objective-c
      CABasicAnimation *animation = [CABasicAnimation animation];
          animation.keyPath = @"backgroundColor";
          animation.toValue = (__bridge id)color.CGColor;
          animation.delegate = self;
      	animation.duration = 0.5;
          //apply animation to layer
          [self.colorLayer addAnimation:animation forKey:nil];

      - (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
        //动画完成调用
      }
      ```

