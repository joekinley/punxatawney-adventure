package
{
  import flash.display.BitmapData;
  import org.flixel.FlxSprite;
  import org.flixel.FlxTilemap;
	/**
   * ...
   * @author Rafael Wenzel
   */
  public class Levels
  {

    public function Levels()
    {
    }

    public static function level1( ):String {

      var levelPixels:BitmapData = new FlxSprite( 0, 0, Globals.IMG_LEVEL1 ).pixels;
      var levelString:String = FlxTilemap.bitmapToCSV( levelPixels, false, 1, Globals.TILE_CODES );
      return levelString;
    }

    public static function level2( ):String {

      var levelPixels:BitmapData = new FlxSprite( 0, 0, Globals.IMG_LEVEL2 ).pixels;
      var levelString:String = FlxTilemap.bitmapToCSV( levelPixels, false, 1, Globals.TILE_CODES );
      return levelString;
    }

  }

}