package
{
	import flash.display.Sprite;
	import flash.events.Event;
  import org.flixel.FlxGame;

	/**
	 * ...
	 * @author Rafael Wenzel
	 */
	//[Frame(factoryClass="Preloader")]
	public dynamic class Main extends FlxGame
	{

		public function Main():void
		{
      super( 640, 480, Game, 1 );
      addEventListener( Event.ADDED_TO_STAGE, init );
		}

		private function init(e:Event = null):void
		{
      stage.addChild( this );
		}

	}

}