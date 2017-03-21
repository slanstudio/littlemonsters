package com.jlq.game.activities
{
	import com.greensock.TweenLite;
	import com.jlq.dragon.activities.IActivityManager;
	import com.jlq.game.core.Food;
	import com.jlq.game.core.Monster;
	import com.jlq.game.factories.FoodFactory;
	import com.jlq.game.utils.BitmapHitTestPlus;
	import com.jlq.game.view.AdView;
	import com.jlq.game.view.LoseView;
	import com.jlq.game.view.WinView;
	import com.jlq.nativeExtensions.android.nativeAds.youmi.YoumiAd;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.drm.AddToDeviceGroupSetting;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	public class NewGameActivity extends PetGameActivity
	{
		[Embed(source="../../../../../build/assets/game_bg.png")]
		private var bgAsset:Class;
		//[Embed(source="../../../../../build/assets/assets_current_score.png")]
		//private var currentScoreAsset:Class;
		//[Embed(source="../../../../../build/assets/assets_max_score.png")]
		//private var maxScoreAsset:Class;
		[Embed(source="../../../../../build/assets/10.png")]
		private var tenScoreAsset:Class;
		[Embed(source="../../../../../build/assets/100.png")]
		private var hunScoreAsset:Class;
		
		private var player:String="player";			//当前玩家
		private var difficult:int;			//关卡难度
		private var levelScore:Number;		//通关所需分数
		private var totalScore:Number;		//总得分
		private var currentScore:Number;	//当前得分
		private var missCount:int;			//失误次数
		private var maxScore:Number;		//游戏最高分数
		
		private var controlPoints:Array;		//控制点数组
		private var points:Array;			//路径点数组
		
		private var defaultXFrom:Number;	//默认X
		private var defaultYFrom:Number;	//默认Y
		private var defaultXTo:Number;		//默认X
		private var defaultYTo:Number;		//默认Y
		
		private var foodTimer:Timer;		//产生Food的计时器
		private var foodDelay:Number;		//产生Food延时
		private var foodMoveTimer:Timer;	//移动Food的计时器
		private var foodMoveSpeed:int;	//移动Food速度计时
		private var speed:Number;		//移动速度
		private var foodArr:Array;			//存放食物的数组
		private var foodsContainer:Sprite;	//装在食物的容器
		private var currentFood:Food;		//当前选中的食物
		private var currentMonster:Monster;	//当前碰撞的怪兽
		private var monstersArr:Array;		//存储怪兽的数组
		
		private var winView:WinView;	//胜利界面
		private var loseView:LoseView;	//失败界面
		
		private var currentScoreTxt:TextField;	//即时分数文本框
		private var maxScoreTxt:TextField;		//最高分数文本框
		private var defaultTextFormat:TextFormat;	//文本格式
		
		private var adANE:YoumiAd;
		
		public function NewGameActivity(activityManager:IActivityManager, data:*=null)
		{
			super(activityManager, data);
		}
		
		override protected function onCreate():void
		{	
			super.onCreate();
		}
		
		override public function onStart():void
		{
			//添加背景
			var bgImage:Bitmap=addChild(Bitmap(new bgAsset())) as Bitmap;
			
			//添加广告
			//adANE = new YoumiAd();
			//adANE.initAd("17eba847a8ae2a06","cd157826f5aef8c8",30,true);
			//adANE.showAd(0,0,400,38);
			
//			//添加即时分数和最高分数
//			var currentScoreImage:Bitmap=addChild(Bitmap(new currentScoreAsset())) as Bitmap;
//			var maxScoreImage:Bitmap=addChild(Bitmap(new maxScoreAsset())) as Bitmap;
//			currentScoreImage.x=maxScoreImage.x=30;
//			currentScoreImage.y=30;
//			maxScoreImage.y=currentScoreImage.height+30;
			
			//默认文本格式
			defaultTextFormat=new TextFormat();
			defaultTextFormat.align=TextFormatAlign.CENTER;
			defaultTextFormat.bold=true;
			defaultTextFormat.size=18;
			
			//即时分数文本框
			currentScoreTxt=addChild(new TextField()) as TextField;
			currentScoreTxt.width=67;
			currentScoreTxt.height=26;
			currentScoreTxt.x=45;
			currentScoreTxt.y=70;
			currentScoreTxt.defaultTextFormat=defaultTextFormat;
			currentScoreTxt.text="0";
			//currentScoreTxt.background=true;
			//currentScoreTxt.backgroundColor=0x0000ff;
			
			//最高分数文本框
			maxScoreTxt=addChild(new TextField()) as TextField;
			maxScoreTxt.width=67;
			maxScoreTxt.height=26;
			maxScoreTxt.x=45;
			maxScoreTxt.y=140;
			maxScoreTxt.defaultTextFormat=defaultTextFormat;
			//maxScoreTxt.background=true;
			//maxScoreTxt.backgroundColor=0x0000ff;
			
			//初始化变量
			initVars();
			//创建运动路径点
			createPoints();
			//创建怪兽
			createMonsters();
			//装在食物的容器
			foodsContainer=addChild(new Sprite()) as Sprite;
			//foodsContainer.x=fullSizeWidth/2;
			//foodsContainer.y=fullSizeHeight/2;
			
			//广告
			//var ad:AdView=addChild(new AdView()) as AdView;
			//ad.y=(fullSizeHeight-ad.height);
			
			super.onStart();
		}
		
		/**
		 * 创建怪兽
		 * */
		private function createMonsters():void
		{
			for(var i:int=0;i<4;i++)
			{
				var monster:Monster=new Monster(i);
				addChild(monster);
				if(i==0){
					monster.x=120;
				}else{
					monster.x=monstersArr[i-1].x +monstersArr[i-1].width +70;
				}
				monster.y=fullSizeHeight-monster.height/2;
				monster.setState(0);
				monstersArr.push(monster);
			}
		}
		
		/**
		 * 初始化变量
		 * */
		private function initVars():void
		{
			defaultXFrom=-35;
			defaultYFrom=342;
			defaultXTo=fullSizeWidth+50;
			defaultYTo=182;
			
			//控制点数组
			controlPoints=new Array();
			//路径点数组
			points=new Array();
			
			//速度
			speed=5;
			
			//食物数组
			foodArr=new Array();
			//怪兽数组
			monstersArr=new Array();
			
			//difficult=activeState.difficult;
			difficult=1;
			totalScore=activeState.totalScore;
			maxScore=getMaxScore();
			maxScoreTxt.text=String(maxScore);
			initLevelScore();
			initFoodTimer();
			
		}
		
		private function createPoints():void
		{
			//起点
			controlPoints.push(new Point(defaultXFrom,defaultYFrom));
			
			//控制点
			controlPoints.push(new Point(585,342));
			controlPoints.push(new Point(585,263));
			controlPoints.push(new Point(164,263));
			controlPoints.push(new Point(164,defaultYTo));
			
			//终点
			controlPoints.push(new Point(defaultXTo,defaultYTo));
			//路径点起点
			points.push(controlPoints[0]);
			//计算下一点
			nextPoint();
		}
		
		private function nextPoint():void
		{
			var len:int=points.length;
			var p:Point=points[len-1];
			var p1:Point=new Point();
			
			//第一段直线
			if(p.y==controlPoints[1].y&&(p.x<controlPoints[1].x||p.x>=controlPoints[0].x))
			{
				p1.x=p.x+speed;
				p1.y=controlPoints[1].y;
				if(p1.x>=controlPoints[1].x){
					p1.x=controlPoints[1].x;
				}
			}
			
			//第二段直线
			if(p.x==controlPoints[2].x&&(p.y>controlPoints[2].y||p.y<=controlPoints[1].y))
			{
				p1.y=p.y-speed;
				p1.x=controlPoints[2].x;
				if(p1.y<=controlPoints[2].y)
				{
					p1.y=controlPoints[2].y;
				}
			}
			
			//第三段直线
			if(p.y==controlPoints[3].y&&(p.x>controlPoints[3].x||p.x<controlPoints[2].x))
			{
				p1.x=p.x - speed;
				p1.y=controlPoints[3].y;
				if(p1.x<=controlPoints[3].x)
				{
					p1.x=controlPoints[3].x;
				}
			}
			
			//第四段直线
			if(p.x==controlPoints[4].x&&(p.y>controlPoints[4].y||p.y<controlPoints[3].y))
			{
				p1.x=controlPoints[4].x;
				p1.y=p.y - speed;
				if(p1.y<=controlPoints[4].y)
				{
					p1.y=controlPoints[4].y;
				}
			}
			
			//第五段直线
			if(p.y==controlPoints[5].y&&(p.x<controlPoints[5].x||p.x>controlPoints[4].x))
			{
				p1.x=p.x+speed;
				p1.y=controlPoints[5].y;
				if(p1.x>=controlPoints[5].x)
				{
					p1.x=controlPoints[5].x;
				}
			}
			
			points.push(p1);
			//是终点
			if(points[points.length-1].y==controlPoints[5].y&&points[points.length-1].x==controlPoints[5].x){
				//开始游戏
				startGame();
			}else{
				//不是终点继续下一点
				nextPoint();
			}
		}
		
		/**
		 * 开始游戏
		 * */
		private function startGame():void
		{	
			//产生食物
			foodTimer=new Timer(foodDelay,0);
			foodTimer.addEventListener(TimerEvent.TIMER,produceFoods);
			foodTimer.start();
			
			//移动食物
			foodMoveTimer=new Timer(50,0);
			foodMoveTimer.addEventListener(TimerEvent.TIMER,moveFoods);
			foodMoveTimer.start();
		}
		
		/**
		 * 定时移动所有食物
		 * */
		private function moveFoods(e:TimerEvent):void
		{
			if(foodArr==null||foodArr.length==0){
				return;
			}
			//移动所有食物
			for(var i:int=0;i<foodArr.length;i++)
			{
				var food:Food=foodArr[i] as Food;
				food.x=points[food.currentPointIndex].x;
				food.y=points[food.currentPointIndex].y;
				food.currentPointIndex++;
				
				//边界检测
				if(food.x>=fullSizeWidth+food.width/2){
					destroy(food);
				}
			}
		}
		
		/**
		 * 暂停游戏
		 * */
		private function pauseGame():void
		{	
			foodTimer.stop();
			foodMoveTimer.stop();
		}
		
		/**
		 * 结束游戏
		 * */
		private function endGame():void
		{
			//停止产生食物
			foodTimer.stop();
			foodTimer=null;
			
			//停止移动食物
			foodMoveTimer.stop();
			foodMoveTimer=null;
			
			//显示闯关失败界面
			loseView=new LoseView();
			addChild(loseView);
			loseView.x=(fullSizeWidth-loseView.width)/2;
			loseView.y=(fullSizeHeight-loseView.height)/2;
			loseView.addEventListener("saveGame",saveGame);
			loseView.addEventListener("restart",restart);
			
			//清除所有食物
			clearAllFoods();
		}
		
		/**
		 * 保存游戏按钮事件处理函数
		 * */
		private function saveGame(e:Event):void
		{
			trace("保存游戏");
			//移除LoseView事件监听
			loseView.removeEventListener("saveGame",saveGame);
			loseView.removeEventListener("restart",restart);
			//移除LoseView
			removeChild(loseView);
			
			//保存游戏
			save();
			
			//退出到游戏菜单界面
			startNextActivityTimer(StartActivity,1);
		}
		
		/**
		 * 重新开始游戏按钮事件处理函数
		 * */
		private function restart(e:Event):void
		{
			trace("重新挑战");
			//移除LoseView事件监听
			loseView.removeEventListener("saveGame",saveGame);
			loseView.removeEventListener("restart",restart);
			//移除LoseView
			removeChild(loseView);
			
			//重置失误次数
			missCount=0;
			//添加装在食物的容器
			foodsContainer=addChild(new Sprite()) as Sprite;
			
			if(difficult!=1){
				//在分数栏显示总得分
				currentScoreTxt.text=String(totalScore-currentScore);
			}
			//当前得分清零
			currentScore=0;
			//开始游戏
			startGame();
		}
		
		/**
		 * 生产食物
		 * */
		private function produceFoods(e:TimerEvent):void
		{
			var kind:int=Math.floor(Math.random()*4);
			var food:Food=new Food(FoodFactory.produceFood(kind),kind);
			food.addEventListener(MouseEvent.MOUSE_UP,stopDragFood);
			food.addEventListener(MouseEvent.MOUSE_DOWN,startDragFood);
			foodsContainer.addChild(food);
			food.x=defaultXFrom;
			food.y=defaultYFrom;
			foodArr.push(food);
		}
		
		/**
		 * 自行销毁
		 * */
		private function destroy(food:Food):void
		{
			//移除食物
			removeFood(food);
			//失误次数加1
			missCount ++;
			//检测失误
			checkMiss();
		}
		
		/**
		 * 开始拖动食物
		 * */
		private function startDragFood(e:MouseEvent):void
		{
			currentFood=e.target as Food;
			
			//停止该食物移动
			//在数组当中找到这个元素索引，然后移除掉该元素
			var index:int=foodArr.indexOf(currentFood);
			if(index<0){
				return;
			}
			foodArr.splice(index,1);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,moveCurrentFood);
		}
		
		/**
		 * 检测失误
		 * */
		private function checkMiss():void
		{
			trace("missCount=",missCount);
			if(missCount>=5){
				endGame();
			}
		}
		
		/**
		 * 停止拖动食物
		 * */
		private function stopDragFood(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveCurrentFood);
			if(currentMonster==null){
				//将自己返回到原来数组当中去
				removeFood(currentFood);	//移除食物
				//增加一次失误
				missCount++;
				//检测失误
				checkMiss();
			}else{
				//如果匹配
				if(currentMonster.checkFood(currentFood)){
					currentScore += 100;	//加分
					updateScore(100);		//更新分数
				}else{
					currentScore += 10;	//加分
					updateScore(10);		//更新分数
				}
				currentMonster.setState(2);
				removeFood(currentFood);	//移除食物
			}
		}
		
		/**
		 * 移动食物
		 * */
		private function moveCurrentFood(e:MouseEvent):void
		{
			currentFood.x=mouseX-currentFood.width/2;
			currentFood.y=mouseY-currentFood.height/2;
			
			//检测碰撞
			checkHit();
		}
		
		/**
		 * 碰撞检测
		 * */
		private function checkHit():void
		{
			if(currentFood!=null){
				for(var j:int=monstersArr.length-1;j>=0;j--)
				{
					if(BitmapHitTestPlus.complexHitTestObject(currentFood,monstersArr[j] as Monster)){
						//trace("碰撞了");
						//设置当前碰撞怪兽
						currentMonster=monstersArr[j] as Monster;
						//更改怪兽状态
						currentMonster.setState(1);
						break;
					}else{
						currentMonster=null;
					}
				}
			}
		}
		
		/**
		 * 移除Food
		 * */
		private function removeFood(food:Food):void
		{
			var index:int=foodArr.indexOf(food);
			if(index>=0){
				foodArr.splice(index,index+1);
			}
			food.removeEventListener(MouseEvent.MOUSE_DOWN,startDragFood);
			food.removeEventListener(MouseEvent.MOUSE_UP,stopDragFood);
			foodsContainer.removeChild(food);
			//trace("len=",foodArr.length);
		}
		
		/**
		 * 查询数据库获取最大得分数
		 * */
		private function getMaxScore():Number
		{
			var sql:String="select max(score) as score from records_tb";
			var obj:Object=sqlUtil.getMaxScore(sql);
			return obj.score;
		}
		
		/**
		 * 更新分数
		 * */
		private function updateScore(curScore:Number):void
		{
			if(curScore==10)
			{
				//显示10分
				var tenImage:Bitmap=addChild(Bitmap(new tenScoreAsset())) as Bitmap;
				showScoreTip(tenImage);
			}else if(curScore==100)
			{
				//显示100分
				var hunImage:Bitmap=addChild(Bitmap(new hunScoreAsset())) as Bitmap;
				showScoreTip(hunImage);
				trace("得100分");
			}
			//修改总分
			totalScore += curScore;
			trace("totalScore=",totalScore);
			//在分数栏显示总得分
			currentScoreTxt.text=String(totalScore);
			//检测分数
			if(totalScore>=levelScore){
				winGame();
			}
			
			if(totalScore>maxScore){
				//改变最高分数显示,但不保存到本地数据库
				maxScore=totalScore;
				maxScoreTxt.text=String(maxScore);
			}
		}
		
		/**
		 * 显示分数提示
		 * */
		private function showScoreTip(bmp:Bitmap):void
		{
			var xFrom:Number=currentMonster.x+currentMonster.width/2;
			var yFrom:Number=currentMonster.y;
			var xTo:Number=currentMonster.x+currentMonster.width/2;
			var yTo:Number=currentMonster.y-20;
			
			bmp.x=xFrom;
			bmp.y=yFrom;
			
			TweenLite.to(bmp,2,{alpha:0,x:xTo,y:yTo});
			
		}
		
		/**
		 * 清除所有食物
		 * */
		private function clearAllFoods():void
		{
			removeChild(foodsContainer);
			foodArr.splice(0,foodArr.length);
			trace("length=",foodArr.length);
		}
		
		/**
		 * 游戏胜利
		 * */
		private function winGame():void
		{
			//暂停游戏
			pauseGame();
			
			foodTimer=null;
			foodMoveTimer=null;
			
			//弹出游戏胜利框
			winView=new WinView();
			addChild(winView);
			winView.x=(fullSizeWidth-winView.width)/2;
			winView.y=(fullSizeHeight-winView.height)/2;
			winView.addEventListener("nextLevel",nextLevel);
			winView.addEventListener("cancel",cancel);
			//清除食物
			clearAllFoods();
		}
		
		/**
		 * 取消下一关
		 * */
		private function cancel(e:Event):void
		{
			trace("取消下一关");
			//移除事件监听
			winView.removeEventListener("cancel",cancel);
			winView.removeEventListener("nextLevel",nextLevel);
			//移除胜利视图
			removeChild(winView);
			//返回上一界面
			startNextActivityTimer(StartActivity,1);
		}
		
		/**
		 * 下一关
		 * */
		private function nextLevel(e:Event):void
		{
			//移除事件监听
			winView.removeEventListener("cancel",cancel);
			winView.removeEventListener("nextLevel",nextLevel);
			//移除胜利视图
			removeChild(winView);
			
			//装在食物的容器
			foodsContainer=addChild(new Sprite()) as Sprite;
			
			//下一关计数
			difficult ++;
			//当前得分清零
			currentScore=0;
			//初始化产生Food的计时器
			initFoodTimer();
			//初始化通关分数
			initLevelScore();
			//开始游戏
			startGame();
		}
		
		/**
		 * 初始化产生食物计时
		 * */
		private function initFoodTimer():void
		{
			if(difficult>=1&&difficult<10){
				//前10关
				//减幅稍小
			}else if(difficult<20){
				//10-20关
				//减幅稍稍增大
			}else{
				//20关以上
				//减幅再增大
			}
			foodDelay=2000-30*(difficult-1);
			foodMoveSpeed=foodDelay/10;
			trace("foodDelay=",foodDelay);
			trace("foodMoveSpeed=",foodMoveSpeed);
		}
		
		/**
		 * 初始化通关分数
		 * */
		private function initLevelScore():void
		{
			levelScore=1000 + 300 * difficult;
			trace("levelScore=",levelScore);
		}
		
		/**
		 * 保存游戏
		 * */
		private function save():void
		{
			//保存到共享对象
			activeState.totalScore=totalScore;	//保存分数
			activeState.difficult=difficult;	//保存关卡
			trace("difficult=",activeState.difficult);
			//保存到本地数据库
			//游戏玩家，得分
			var sql:String="insert into records_tb(player,score) values ("	+
				"'"	+ player + "'," + "'" + totalScore + "'" +
				")";
			trace(sql);
			sqlUtil.insertRecord(sql);
		}
		
		/**
		 * 
		 * */
		override public function onPause():void
		{
			foodTimer.stop();
			foodMoveTimer.stop();
			
			super.onPause();
		}
		
		override public function reStart():void
		{
			startOn();
			super.reStart();
		}
		
		private function startOn():void
		{
			foodTimer.start();
			foodMoveTimer.start();
		}
		
		override public function onStop():void
		{
			super.onStop();
			//adANE.removeAd();
		}
	}
}