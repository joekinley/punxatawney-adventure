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
    public static const GAME_BACKGROUND_SCROLL:Number = 0;
    public static const GAME_SOUND_VOLUME:Number = 0.8;

    public static const PLAYER_IDLE_ANIMATION_TIME:Number = 3;
    public static const PLAYER_ANIMATION_SPEED:int = 10;
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

    public static const TILE_ANIMATION_SPEED:Number = .125;
    public static const TILE_WEATHER_RESPAWN_TIME:Number = 5;

    public static const WEATHER_WIND_DURATION:Number = 2;
    public static const WEATHER_WIND_SPEED:int = 200;

    public static const WEATHER_RAIN_DURATION:Number = 2;
    public static const WEATHER_RAIN_OVERLAY_DURATION:Number = 5;
    public static const WEATHER_RAIN_SPEED:int = 1400;

    public static const WEATHER_SNOW_DURATION:Number = 2;
    public static const WEATHER_SNOW_OVERLAY_DURATION:Number = 5;

    // tile codes
    public static const TILE_CODES:Array = new Array(
      0xFFFFFF, // 0 - WHITE - nothing
      0x0000FF, // 1 - BLUE - player characters starting point
      0x111111, // 2 - BLACK - floor 1
      0x9393CD, // 3 - LIGHT BLUE TRANSPARENT - rain overlay
      0, // 4 - ICE overlay
      0, // 5 - GRASS 1
      0x222222, // 6 - PLAINS 1
      0x333333, // 7 - PLAINS 2
      0, // 8 - GRASS 2
      0, // 9 - GRASS 3
      0, // 10 - PLAINS 3
      0xFF7301, // 11 - DROP 1
      0, // 12 - DROP 2
      0, // 13 - DROP 3
      0xFF1501, // 14 - SUN 1
      0, // 15 - SUN 2
      0, // 16 - SUN 3
      0xFF1573, // 17 - CLOUD 1
      0, // 18 - CLOUD 2
      0, // 19 - CLOUD 3
      0xFF90BD, // 20 - SNOW 1
      0, // 21 - SNOW 2
      0, // 22 - SNOW 3
      0
    );

    public static const TILE_NOTHING:int = 0;
    public static const TILE_FLOOR_1:int = 2;

    public static const TILE_PLAINS_1:int = 6;
    public static const TILE_PLAINS_2:int = 7;

    public static const TILE_RAIN_OVERLAY:int = 3;
    public static const TILE_SNOW_OVERLAY:int = 4;

    public static const TILE_RAIN_1:int = 11;
    public static const TILE_RAIN_2:int = 12;
    public static const TILE_RAIN_3:int = 13;

    public static const TILE_SUN_1:int = 14;
    public static const TILE_SUN_2:int = 15;
    public static const TILE_SUN_3:int = 16;

    public static const TILE_CLOUD_1:int = 17;
    public static const TILE_CLOUD_2:int = 18;
    public static const TILE_CLOUD_3:int = 19;

    public static const TILE_SNOW_1:int = 20;
    public static const TILE_SNOW_2:int = 21;
    public static const TILE_SNOW_3:int = 22;

    public static const TILE_PLAYER_START:int = 1;

    // file assets
    //[Embed(source = '../assets/graphics/tiles.png')] public static const IMG_TILES:Class;
    [Embed(source = '../assets/graphics/boeden.png')] public static const IMG_TILES:Class;
    [Embed(source = '../assets/graphics/phil.png')] public static const IMG_PHIL:Class;
    [Embed(source = '../assets/graphics/level1.png')] public static const IMG_LEVEL1:Class;
    [Embed(source = '../assets/graphics/level2.png')] public static const IMG_LEVEL2:Class;
    [Embed(source = '../assets/graphics/stadt_bg9.png')] public static const IMG_BACKGROUND1:Class;
    [Embed(source = '../assets/graphics/Wald5.png')] public static const IMG_BACKGROUND2:Class;
    [Embed(source = '../assets/graphics/titel.png')] public static const IMG_TITLE:Class;

    [Embed(source = '../assets/sounds/jump.mp3')] public static const SND_JUMP:Class;
    [Embed(source = '../assets/sounds/rain.mp3')] public static const SND_RAIN:Class;
    [Embed(source = '../assets/sounds/wind.mp3')] public static const SND_WIND:Class;

    [Embed(source = '../assets/music/ggjmusic.mp3')] public static const MUS_GGJ:Class;

  }

}