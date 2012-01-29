package
{
  import org.flixel.FlxG;
  import org.flixel.FlxObject;
  import org.flixel.FlxSprite;
	/**
   * ...
   * @author Rafael Wenzel
   */
  public class Player extends FlxSprite
  {

    private var wind_x:int;
    private var wind_y:int;

    private var touchingSnow:Boolean;
    private var snow_x:int;

    private var jump:Number;

    private var idleAnimationTimer:Number;
    private var idleAnimationPlaying:Boolean;

    public function Player()
    {
      this.jump = 0;
      this.wind_x = 0;
      this.wind_y = 0;

      this.idleAnimationTimer = 0;
      this.idleAnimationPlaying = false;

      this.touchingSnow = false;
      this.snow_x = 0;

      loadGraphic( Globals.IMG_PHIL, false, false, Globals.PLAYER_WIDTH, Globals.PLAYER_HEIGHT );

      drag.x = Globals.PLAYER_SPEED * 8;
      drag.y = Globals.PLAYER_SPEED * 8;
      maxVelocity.x = Globals.PLAYER_SPEED;
      maxVelocity.y = Globals.GAME_GRAVITY;
      acceleration.y = Globals.GAME_GRAVITY;

      this.addAnimation( 'idle_right', [ 8 ] );
      this.addAnimation( 'idle_left', [ 4 ] );
      this.addAnimation( 'jump_right', [ 1 ] );
      this.addAnimation( 'jump_left', [ 2 ] );
      this.addAnimation( 'run_left', [ 5, 6 ], Globals.PLAYER_ANIMATION_SPEED );
      this.addAnimation( 'run_right', [ 9, 10 ], Globals.PLAYER_ANIMATION_SPEED );
      this.addAnimation( 'idle_hat_right', [ 12, 13, 14, 15 ], Globals.PLAYER_ANIMATION_SPEED );
      this.addAnimation( 'idle_hat_left', [ 16, 17, 18, 19 ], Globals.PLAYER_ANIMATION_SPEED );
      this.addAnimation( 'idle_tail_right', [ 20, 21, 22, 23 ], Globals.PLAYER_ANIMATION_SPEED );
      this.addAnimation( 'idle_tail_left', [ 24, 25, 26, 27 ], Globals.PLAYER_ANIMATION_SPEED );

      this.play( 'idle_right' );
    }

    override public function update( ):void {

      velocity.x = this.wind_x + this.snow_x;

      this.handleMovement( );
      this.handleJump( );
      this.handleAnimation( );

      // do not fall off the cliff
      if ( this.x < 0 ) this.x = 0;

      super.update( );
    }

    public function handleMovement( ):void {
      if ( FlxG.keys.LEFT ) {
        if ( jump > 0 ) velocity.x = -Globals.PLAYER_SPEED_JUMP + this.wind_x + this.snow_x;
        else velocity.x = -Globals.PLAYER_SPEED + this.wind_x + this.snow_x;
        this.facing = FlxObject.LEFT;
        play( 'run_left' );
      }
      if ( FlxG.keys.RIGHT ) {
        if ( jump > 0 ) velocity.x = Globals.PLAYER_SPEED_JUMP + this.wind_x + this.snow_x;
        else velocity.x = Globals.PLAYER_SPEED + this.wind_x + this.snow_x;
        this.facing = FlxObject.RIGHT;
        play( 'run_right' );
      }

    }

    public function handleJump( ):void {
      // play jump sound
      if( FlxG.keys.justPressed( 'UP' ) || FlxG.keys.justPressed( 'X' ) ) FlxG.play( Globals.SND_JUMP, Globals.GAME_SOUND_VOLUME );

      if ( ( FlxG.keys.UP || FlxG.keys.X ) && jump >= 0 ) {
        jump += FlxG.elapsed;
        if ( jump > Globals.PLAYER_JUMP_MAX ) jump = -1;

      } else jump = -1;

      if ( jump > 0 ) {
        if ( this.facing == FlxObject.LEFT ) play( 'jump_left' );
        else if ( this.facing == FlxObject.RIGHT ) play( 'jump_right' );
        //else play( 'jump_center' );

        if ( jump < Globals.PLAYER_JUMP_MIN ) velocity.y = -Globals.PLAYER_JUMP + this.wind_y;
      } else if( !isTouching( FlxObject.FLOOR ) ) {
        velocity.y += Globals.GAME_GRAVITY + this.wind_y;
      }

      if ( isTouching( FlxObject.FLOOR ) ) {
        jump = 0;
      }
    }

    public function handleAnimation( ):void {

      this.idleAnimationTimer += FlxG.elapsed;

      if ( jump > 0 ) return;
      if ( this.facing == FlxObject.LEFT && this.velocity.x == 0 ) {
        this.play( 'idle_left' );
      }
      else if ( this.facing == FlxObject.RIGHT && this.velocity.x == 0 ) {
        this.play( 'idle_right' );
      }

      //if ( this.idleAnimationTimer >= Globals.PLAYER_IDLE_ANIMATION_TIME ) {
      //  this.idleAnimationPlaying = true;
      //  if ( this.facing == FlxObject.LEFT ) this.play( 'idle_tail_left', true );
      //  else if ( this.facing == FlxObject.RIGHT ) this.play( 'idle_tail_right', true );
      //}

    }

    public function applyWind( x:int, y:int ):void {
      this.wind_x = x;
      this.wind_y = y;
    }

    public function applySnow( ):void {

      this.touchingSnow = true;
      if ( this.facing == FlxObject.LEFT ) this.snow_x = -Globals.PLAYER_SPEED;
      else if( this.facing == FlxObject.RIGHT ) this.snow_x = Globals.PLAYER_SPEED;
    }

    public function stopSnow( ):void {
      this.touchingSnow = false;
      this.snow_x = 0;
    }

    public function isMoving( ):Boolean {
      if ( this.acceleration.x != 0 ) return true;
      if ( this.acceleration.y != 0 ) return true;
      if ( this.jump > 0 ) return true;

      return false;
    }

    public function isJumping( ):Boolean {
      if ( this.jump > 0 ) return true;
      return false;
    }

  }

}