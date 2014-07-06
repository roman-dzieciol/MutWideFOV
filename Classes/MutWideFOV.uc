// ============================================================================
//  MutWideFOV.uc :: (C) 2003 Roman Switch` Dzieciol
// ============================================================================
class MutWideFOV extends Mutator;

var PlayerController LastPlayer;
var IntWideFOV Interaction;

simulated function Tick(float DeltaTime)
{
    if( LastPlayer != None && Interaction != None )
    {
        Disable('Tick');
        return;
    }

    if( Interaction == None )
    {
        LastPlayer = Level.GetLocalPlayerController();
        if( LastPlayer != None )
        {
            Interaction = IntWideFOV(LastPlayer.Player.InteractionMaster.AddInteraction("MutWideFOV.IntWideFOV", LastPlayer.Player));
            //Log( "Added" @Interaction @"for" @LastPlayer, name );
        }
    }
}

defaultproperties
{
     bAddToServerPackages=True
     GroupName="Camera"
     FriendlyName="Wide FOV"
     Description="Enables 180x90 degrees camera."
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
