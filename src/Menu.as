package
{
  import org.flixel.FlxG;
  import org.flixel.FlxSprite;
  import org.flixel.FlxState;
	/**
   * ...
   * @author Rafael Wenzel
   */
  public class Menu extends FlxState
  {

    public function Menu()
    {
      var background:FlxSprite = new FlxSprite( 0, 0, Globals.IMG_TITLE );
      this.add( background );
    }

    override public function update( ):void {
      if ( FlxG.keys.any( ) ) {
        FlxG.switchState( new Game );
      }
    }

  }

}