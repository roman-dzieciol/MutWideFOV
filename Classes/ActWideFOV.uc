// ============================================================================
//  ActWideFOV.uc :: (C) 2003 Roman Switch` Dzieciol
// ============================================================================
class ActWideFOV extends Actor;

#exec obj load file=WideFovTX.utx package=MutWideFOV
#exec obj load file=WideFovSM.usx package=MutWideFOV

var() IntWideFOV Interaction;


simulated event RenderTexture( ScriptedTexture T )
{
    if( Interaction != None )
        Interaction.RenderTexture(T);
}

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'MutWideFOV.CamSqrt'
     bLightingVisibility=False
     bOnlyOwnerSee=True
     bAcceptsProjectors=False
     RemoteRole=ROLE_None
     Skins(0)=ScriptedTexture'MutWideFOV.CamLeft'
     Skins(1)=ScriptedTexture'MutWideFOV.CamRight'
     bUnlit=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     bIgnoreOutOfWorld=True
}
