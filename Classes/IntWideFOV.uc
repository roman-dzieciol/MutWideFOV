// ============================================================================
//  IntWideFOV.uc :: (C) 2003 Roman Switch` Dzieciol
// ============================================================================
class IntWideFOV extends Interaction;

#exec obj load file=WideFovTX.utx package=MutWideFOV

var vector			Offset;
var vector			AdjustLoc;
var vector			CamLoc;

var ScriptedTexture	CamLeft;
var ScriptedTexture	CamRight;

var rotator			CamLeftRot;
var rotator			CamRightRot;

var() rotator		CamLeftDir;
var() rotator		CamRightDir;


var() Material		TBlack;
var() Material		TMask;
var float			TMaskX;
var float			TMaskY;

var float			ClipXLast;
var float			ClipYLast;

var ActWideFOV      Actor;


event NotifyLevelChange()
{
    if( Actor != None )
    {
        Actor.Interaction = None;
        Actor.Destroy();
    }
    Actor = None;

	CamLeft.Client = None;
	CamRight.Client = None;

    Master.RemoveInteraction(self);
}


event RenderTexture( ScriptedTexture T )
{
    Actor.SetDrawType( DT_None );

	if( T == CamLeft)
        T.DrawPortal(0, 0, T.USize, T.VSize, ViewportOwner.Actor, CamLoc, CamLeftRot, 90);
	else if( T == CamRight)
        T.DrawPortal(0, 0, T.USize, T.VSize, ViewportOwner.Actor, CamLoc, CamRightRot, 90);

    Actor.SetDrawType( DT_StaticMesh );
}

function SetResolution( float X, float Y )
{
	CamLeft.SetSize(X,Y);
	CamRight.SetSize(X,Y);
}

function PreRender( Canvas C )
{
	local vector	CamPos;
	local rotator	CamRot;
	local vector MeshLoc,LX,LY,LZ,GX,GY,GZ;
	local rotator MeshRot;
	local PlayerController PC;

	PC = ViewportOwner.Actor;

	if( PC == None
    ||  PC.DesiredFOV != PC.DefaultFOV )
        return;

    //Log( "PreRender", name );

    if( Actor != None )
    {
//    	if( ClipXLast != C.ClipX && ClipYLast != C.ClipY )
//    	{
//    		ClipXLast = C.ClipX;
//    		ClipYLast = C.ClipY;
//    		if( ClipYLast >= 1024 || ClipXLast >= 1024 )	SetResolution(1024, 1024);
//    		else											SetResolution(512, 512);
//    	}

    	C.bRenderLevel = False;
    	C.SetDrawColor(255,255,255,255);
    	C.SetPos(0,0);
    	C.DrawTileStretched( TBlack, C.ClipX, C.ClipY );

    	C.GetCameraLocation(CamPos, CamRot);


    	GetAxes(CamRot,GX,GY,GZ);
    	AdjustLoc = 127*GX;
    	MeshLoc = CamPos + (127*GX);
    	MeshRot = OrthoRotation(-GX,-GY,GZ);		// look at me!

    	GetAxes(CamLeftDir,GX,GY,GZ);
    	LX = GX >> CamRot;
    	LY = GY >> CamRot;
    	LZ = GZ >> CamRot;
    	CamLeftRot = OrthoRotation(LX,LY,LZ);

    	GetAxes(CamRightDir,GX,GY,GZ);
    	LX = GX >> CamRot;
    	LY = GY >> CamRot;
    	LZ = GZ >> CamRot;
    	CamRightRot = OrthoRotation(LX,LY,LZ);

    	Actor.SetLocation( MeshLoc );
    	Actor.SetRotation( MeshRot );
    	CamLoc = CamPos;

    	CamLeft.Revision++;
    	CamRight.Revision++;

    	C.DrawActor(Actor, false, true, 90);

    	C.SetPos(0,0);
    	C.Style = 5; // Alpha
    	C.DrawTile( TMask, C.ClipX, C.ClipY, 0, 0, TMaskX, TMaskY );
    }
    else
    {
        SpawnActor(PC);
    }
}

function SpawnActor( PlayerController PC )
{
    Actor = PC.Spawn(class'ActWideFOV',PC);
    if( Actor == None )
        return;

    //Log( "Spawned FOV Actor" @Actor, name );

    Actor.Interaction = self;

	TMaskX = TMask.MaterialUSize();
	TMaskY = TMask.MaterialVSize();

	CamLeft = ScriptedTexture(Actor.Skins[0]);
	CamRight = ScriptedTexture(Actor.Skins[1]);

	CamLeft.Client = Actor;
	CamRight.Client = Actor;

	SetResolution(512, 512);
}

defaultproperties
{
     CamLeftDir=(Yaw=-8192)
     CamRightDir=(Yaw=8192)
     TBlack=Texture'Engine.BlackTexture'
     TMask=Texture'MutWideFOV.CamSqrtMask'
     bVisible=True
}
