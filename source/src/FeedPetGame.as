package
{
	import com.jlq.dragon.AbstractApplication;
	import com.jlq.dragon.activities.ActivityManager;
	import com.jlq.game.activities.SponsorActivity;
	
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	[SWF(backgroundColor="0x000000",frameRate="24")]
	public class FeedPetGame extends AbstractApplication
	{	
		public function FeedPetGame()
		{
			//设置触碰模式
			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;
			
			//设置游戏开始界面
			super(new ActivityManager(),SponsorActivity);	
		}
	}
}