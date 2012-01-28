package
{
	/**
   * ...
   * @author Rafael Wenzel
   */
  public class Globals
  {

    public function Globals()
    {
    }

    public static const GAME_WIDTH:int = 640;
    public static const GAME_HEIGHT:int = 480;
    public static const GAME_GRAVITY:int = 200;

    public static const PLAYER_WIDTH:int = 64;
    public static const PLAYER_HEIGHT:int = 64;
    public static const PLAYER_SPEED:int = 225;
    public static const PLAYER_SPEED_JUMP:int = 280;
    public static const PLAYER_JUMP:int = 1500;
    public static const PLAYER_JUMP_MAX:Number = 0.30;
    public static const PLAYER_JUMP_MIN:Number = 0.0625;

    public static const TILE_WIDTH:int = 40;
    public static const TILE_HEIGHT:int = 40;
    public static const TILE_SOLID_START:int = 21;

    public static const WEATHER_WIND_DURATION:Number = 5;
    public static const WEATHER_WIND_SPEED:int = 200;

    public static const WEATHER_RAIN_DURATION:Number = 5;
    public static const WEATHER_RAIN_OVERLAY_DURATION:Number = 10;
    public static const WEATHER_RAIN_SPEED:int = 1400;

    public static const WEATHER_SNOW_DURATION:Number = 5;
    public static const WEATHER_SNOW_OVERLAY_DURATION:Number = 30;

    // tile codes
    public static const TILE_CODES:Array = new Array(
      0xFFFFFF, // 0 - WHITE - nothing
      0x0000FF, // 1 - BLUE - player characters starting point
      0x111111, // 2 - BLACK - floor 1
      0x9393CD, // 3 - LIGHT BLUE TRANSPARENT - rain overlay
      0
    );

    public static const TILE_NOTHING:int = 0;
    public static const TILE_FLOOR_1:int = 2;

    public static const TILE_RAIN_OVERLAY:int = 3;
    public static const TILE_SNOW_OVERLAY:int = 4;

    public static const TILE_PLAYER_START:int = 1;

    // file assets
    [Embed(source = '../assets/graphics/tiles.png')] public static const IMG_TILES:Class;
    [Embed(source = '../assets/graphics/phil1.png')] public static const IMG_PHIL:Class;
    [Embed(source = '../assets/graphics/level1.png')] public static const IMG_LEVEL1:Class;
    [Embed(source = '../assets/graphics/level2.png')] public static const IMG_LEVEL2:Class;
  }

}