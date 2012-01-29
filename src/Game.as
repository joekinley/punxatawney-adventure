package
{

  import flash.geom.Rectangle;
  import org.flixel.FlxCamera;
  import org.flixel.FlxG;
  import org.flixel.FlxGroup;
  import org.flixel.FlxObject;
  import org.flixel.FlxPoint;
  import org.flixel.FlxRect;
  import org.flixel.FlxSprite;
  import org.flixel.FlxState;
  import org.flixel.FlxTilemap;
  import org.flixel.system.FlxTile;
	/**
   * ...
   * @author Rafael Wenzel
   */
  public class Game extends FlxState
  {

    private var layer_back:FlxGroup;
    private var layer_objects:FlxGroup;
    private var layer_player:FlxGroup;

    private var tilemap:FlxTilemap;
    private var overlays:FlxTilemap;
    private var player:Player;

    // wind weather acceleration
    private var isWindy:Boolean;
    private var windTimer:Number;
    private var wind_x:int;
    private var wind_y:int;

    // rain
    private var isRaining:Boolean;
    private var rainTimer:Number;
    private var rainOverlayTimer:Number;

    // snow
    private var isSnowing:Boolean;
    private var snowTimer:Number;
    private var snowOverlayTimer:Number;

    // collectible animation
    private var collectibleAnimationTimer:Number;
    private var collectibleRespawn:Array;
    private var collectibleIndicator:Array;

    public function Game()
    {
      wind_x = 0;
      wind_y = 0;
      windTimer = 0;
      isWindy = false;

      isRaining = false;
      rainTimer = 0;
      rainOverlayTimer = 0;

      isSnowing = false;
      snowTimer = 0;
      snowOverlayTimer = 0;

      collectibleAnimationTimer = 0;
    }

    override public function create( ):void {

      this.layer_back = new FlxGroup;
      this.layer_objects = new FlxGroup;
      this.layer_player = new FlxGroup;

      // background
      this.addBackground( Globals.IMG_BACKGROUND1 );
      this.addBackground( Globals.IMG_BACKGROUND1 );
      this.addBackground( Globals.IMG_BACKGROUND2 );

      // main level tilemap
      this.tilemap = new FlxTilemap;
      this.tilemap.loadMap( Levels.level2( ), Globals.IMG_TILES, Globals.TILE_WIDTH, Globals.TILE_HEIGHT, 0, 0, 1, Globals.TILE_SOLID_START );
      this.tilemap.setTileProperties( Globals.TILE_FLOOR_1, FlxObject.ANY, this.playerConcreteCollision, Player );
      this.tilemap.setTileProperties( Globals.TILE_RAIN_1, FlxObject.NONE, this.playerCollect, Player, 12 );
      this.tilemap.setTileProperties( Globals.TILE_PLAINS_1, FlxObject.ANY, null, null, 2 );
      this.layer_objects.add( this.tilemap );

      // overlay tilemap
      this.overlays = new FlxTilemap;
      var overlayArray:Array = new Array( this.tilemap.totalTiles );
      for ( var i:int = 0; i < overlayArray.length; i++ ) {
        overlayArray[ i ] = 0;
      }
      this.overlays.loadMap( FlxTilemap.arrayToCSV( overlayArray, tilemap.widthInTiles ), Globals.IMG_TILES, Globals.TILE_WIDTH, Globals.TILE_HEIGHT );
      this.overlays.setTileProperties( Globals.TILE_SNOW_OVERLAY, FlxObject.NONE, this.playerSnowCollision, Player );
      this.layer_objects.add( this.overlays );

      this.collectibleRespawn = new Array;
      this.collectibleIndicator = new Array;
      for ( i = 0; i < this.tilemap.totalTiles; i++ ) {
        this.collectibleRespawn[ i ] = -1;
        this.collectibleIndicator[ i ] = 0;
      }

      this.player = new Player;
      this.layer_player.add( this.player );
      this.determinePlayerPosition( );

      // add layer
      this.add( this.layer_back );
      this.add( this.layer_objects );
      this.add( this.layer_player );

      // camera handling
      FlxG.camera.follow( this.player );
      FlxG.camera.setBounds( 0, 0, tilemap.width, tilemap.height );
      FlxG.worldBounds = new FlxRect( 0, 0, tilemap.width, tilemap.height );

      FlxG.playMusic( Globals.MUS_GGJ );
    }

    override public function update( ):void {

      this.debug( );
      // events
      //this.handleWeatherAction( );

      this.handleWind( );
      this.handleRain( );
      this.handleSnow( );

      // apply wind to player
      this.player.applyWind( this.wind_x, this.wind_y );

      // collide player with objects
      FlxG.collide( this.layer_objects, this.player );

      this.handleAnimation( );

      super.update( );
    }

    private function determinePlayerPosition( ):void {
      var startPoint:FlxPoint = this.tilemap.getTileCoords( Globals.TILE_PLAYER_START, false )[ 0 ];
      this.player.x = startPoint.x;
      this.player.y = startPoint.y;

      this.tilemap.setTile( startPoint.x / Globals.TILE_WIDTH, startPoint.y / Globals.TILE_HEIGHT, 0 );
    }

    private function setWind( ):void {

      FlxG.play( Globals.SND_WIND, Globals.GAME_SOUND_VOLUME );

      // determine direction (either player movement direction; or player facing)
      if ( this.player.isJumping( ) ) {
        this.wind_y = -Globals.WEATHER_WIND_SPEED;
      } else if ( this.player.isMoving( ) ) {
        if ( this.player.facing == FlxObject.LEFT ) {
          this.wind_x = -Globals.WEATHER_WIND_SPEED;
        } else if ( this.player.facing == FlxObject.RIGHT ) {
          this.wind_x = Globals.WEATHER_WIND_SPEED;
        }
      }

      this.windTimer = 0;
      this.isWindy = true;
    }

    private function setRain( ):void {

      FlxG.play( Globals.SND_RAIN, Globals.GAME_SOUND_VOLUME );

      var cur:int;
      this.isRaining = true;
      this.rainTimer = 0;
      this.rainOverlayTimer = 0;
      this.wind_y = Globals.WEATHER_RAIN_SPEED;

      // set rain overlay
      for ( var i:int = 0; i < this.tilemap.totalTiles; i++ ) {
        cur = this.tilemap.getTileByIndex( i );

        if ( cur == Globals.TILE_FLOOR_1 || cur == Globals.TILE_PLAINS_1 || cur == Globals.TILE_PLAINS_2 ) {
          this.overlays.setTileByIndex( i, Globals.TILE_RAIN_OVERLAY );
        }
      }
    }

    private function setSnow( ):void {

      var cur:int;
      this.isSnowing = true;
      this.snowTimer = 0;

      for ( var i:int = 0; i < this.overlays.totalTiles; i++ ) {
        cur = this.overlays.getTileByIndex( i );

        if ( cur == Globals.TILE_RAIN_OVERLAY ) {
          this.overlays.setTileByIndex( i, Globals.TILE_SNOW_OVERLAY );
        }
      }
    }

    private function setSun( ):void {

      var cur:int;

      for ( var i:int = 0; i < this.overlays.totalTiles; i++ ) {
        cur = this.overlays.getTileByIndex( i );

        if ( cur == Globals.TILE_SNOW_OVERLAY ) {
          this.overlays.setTileByIndex( i, Globals.TILE_RAIN_OVERLAY );
        }
      }
      this.rainOverlayTimer = Globals.WEATHER_RAIN_DURATION;
    }

    private function handleAnimation( ):void {
      this.collectibleAnimationTimer += FlxG.elapsed;

      for ( var j:int = 0; j < this.tilemap.totalTiles; j++ ) {
        if ( this.collectibleRespawn[ j ] >= 0 ) {
          this.collectibleRespawn[ j ] += FlxG.elapsed;

          if ( this.collectibleRespawn[ j ] >= Globals.TILE_WEATHER_RESPAWN_TIME ) {
            this.collectibleRespawn[ j ] = -1;
            this.tilemap.setTileByIndex( j, this.collectibleIndicator[ j ] );
          }
        }
      }

      if ( this.collectibleAnimationTimer >= Globals.TILE_ANIMATION_SPEED ) {

        var cur:int = 0;
        for ( var i:int = 0; i < this.tilemap.totalTiles; i++ ) {
          cur = this.tilemap.getTileByIndex( i );

          switch( cur ) {
            case Globals.TILE_CLOUD_1:
            case Globals.TILE_CLOUD_2:
            case Globals.TILE_RAIN_1:
            case Globals.TILE_RAIN_2:
            case Globals.TILE_SNOW_1:
            case Globals.TILE_SNOW_2:
            case Globals.TILE_SUN_1:
            case Globals.TILE_SUN_2:
              this.tilemap.setTileByIndex( i, cur + 1 );
              break;

            case Globals.TILE_RAIN_3:
              this.tilemap.setTileByIndex( i, Globals.TILE_RAIN_1 );
              break;

            case Globals.TILE_CLOUD_3:
              this.tilemap.setTileByIndex( i, Globals.TILE_CLOUD_1 );
              break;

            case Globals.TILE_SNOW_3:
              this.tilemap.setTileByIndex( i, Globals.TILE_SNOW_1 );
              break;

            case Globals.TILE_SUN_3:
              this.tilemap.setTileByIndex( i, Globals.TILE_SUN_1 );
              break;

          }
        }
        this.collectibleAnimationTimer = 0;
      }
    }

    private function handleWeatherAction( action:String ):void {

      if ( this.isWindy ) return;
      if ( this.isRaining ) return;

      // wind
      if ( action == 'A' ) this.setWind( );
      if ( action == 'S' ) this.setRain( );
      if ( action == 'D' ) this.setSnow( );
      if ( action == 'F' ) this.setSun( );

    }

    private function handleWind( ):void {

      if ( !this.isWindy ) return;

      this.windTimer += FlxG.elapsed;

      if ( this.windTimer >= Globals.WEATHER_WIND_DURATION ) {
        this.isWindy = false;
        this.wind_x = 0;
        this.wind_y = 0;
      }
    }

    private function handleRain( ):void {

      if ( this.isRaining ) {

        this.rainTimer += FlxG.elapsed;
        this.rainOverlayTimer += FlxG.elapsed;

        if ( this.rainTimer >= Globals.WEATHER_RAIN_DURATION ) {
          this.isRaining = false;
          this.wind_y = 0;
        }
      } else if( this.rainOverlayTimer > 0 ) {
        this.rainOverlayTimer += FlxG.elapsed;

        if ( this.rainOverlayTimer >= Globals.WEATHER_RAIN_OVERLAY_DURATION ) {
          for ( var i:int = 0; i < this.overlays.totalTiles; i++ ) {
            if( this.overlays.getTileByIndex( i ) == Globals.TILE_RAIN_OVERLAY ) {
              this.overlays.setTileByIndex( i, 0 );
            }
          }
          this.rainOverlayTimer = 0;
        }
      }
    }

    private function handleSnow( ):void {

      if ( this.isSnowing ) {
        this.snowTimer += FlxG.elapsed;
        this.snowOverlayTimer += FlxG.elapsed;

        if ( this.snowTimer >= Globals.WEATHER_SNOW_DURATION ) {
          this.isSnowing = false;
        }
      } else if ( this.snowOverlayTimer > 0 ) {
        this.snowOverlayTimer += FlxG.elapsed;

        if ( this.snowOverlayTimer >= Globals.WEATHER_SNOW_OVERLAY_DURATION ) {
          for ( var i:int = 0; i < this.overlays.totalTiles; i++ ) {
            if( this.overlays.getTileByIndex( i ) == Globals.TILE_SNOW_OVERLAY ) {
              this.overlays.setTileByIndex( i, 0 );
            }
          }
          this.snowOverlayTimer = 0;
        }
      }
    }

    private function addBackground( back:Class ):void {

      var background:FlxSprite = new FlxSprite;
      background.loadGraphic( back, false, false, 0, 0, true );// ( 0, 0, Globals.IMG_BACKGROUND1 );
      background.scrollFactor.x = .5;

      if ( this.layer_back.length > 0 ) {

        var last:FlxSprite = this.layer_back.members[ this.layer_back.members.length - 1 ];
        background.x = last.x + last.width;
      }
      this.layer_back.add( background );
    }

    private function playerSnowCollision( tile:FlxTile, player:Player ):void {
      this.player.applySnow( );
    }

    private function playerConcreteCollision( tile:FlxTile, player:Player ):void {
      this.player.stopSnow( );
    }

    private function playerCollect( tile:FlxTile, player:Player ):void {

      if ( tile.index == Globals.TILE_RAIN_1 || tile.index == Globals.TILE_RAIN_2 || tile.index == Globals.TILE_RAIN_3 ) {

        this.handleWeatherAction( "S" );
        this.collectibleIndicator[ tile.mapIndex ] = Globals.TILE_RAIN_1;
      } else if ( tile.index == Globals.TILE_SUN_1 || tile.index == Globals.TILE_SUN_2 || tile.index == Globals.TILE_SUN_3 ) {

        this.handleWeatherAction( "F" );
        this.collectibleIndicator[ tile.mapIndex ] = Globals.TILE_SUN_1;
      } else if ( tile.index == Globals.TILE_CLOUD_1 || tile.index == Globals.TILE_CLOUD_2 || tile.index == Globals.TILE_CLOUD_3 ) {

        this.handleWeatherAction( "A" );
        this.collectibleIndicator[ tile.mapIndex ] = Globals.TILE_CLOUD_1;
      } else if ( tile.index == Globals.TILE_SNOW_1 || tile.index == Globals.TILE_SNOW_2 || tile.index == Globals.TILE_SNOW_3 ) {

        this.handleWeatherAction( "D" );
        this.collectibleIndicator[ tile.mapIndex ] = Globals.TILE_SNOW_1;
      }

      this.tilemap.setTileByIndex( tile.mapIndex, 0 );
      this.collectibleRespawn[ tile.mapIndex ] = 0;
    }

    private function debug( ):void {

    }

  }

}