[SedimentFileInformation]
    FileCreatedBy         = Deltares, FM-Suite DFlowFM Model Version 4.16.0.7431, DFlow FM Version Deltares, D-Flow FM1.2.184.16121e1c11da6767019cb454759df52aec1670fe 
    FileCreationDate      = Wed Oct 08 2025, 19:46:56 
    FileVersion           = 02.00                  
[SedimentOverall]
    Cref                  = 1600                   [kg/m3]   Reference density for hindered settling calculations
[Sediment]
    Name                  = #sand#                           Name of sediment fraction
    SedTyp                = sand                             Must be "sand", "mud" or "bedload"
    IniSedThick           = #sand_IniSedThick.xyz# [m]       Initial sediment layer thickness at bed
    FacDss                = 1                      [-]       Factor for suspended sediment diameter
    RhoSol                = 2650                   [kg/m3]   Specific density
    TraFrm                = -1                               Integer selecting the transport formula
    CDryB                 = 1600                   [kg/m3]   Dry bed density
    SedDia                = 0.0003                 [m]       Median sediment diameter (D50)
    SedD10                = 0.000185               [m]       10 percentile sediment diameter (D10)
    SedD90                = 0.000505               [m]       90 percentile sediment diameter (D90)
    IopSus                = 0                                Option for determining suspended sediment diameter
    AksFac                = 1                      [-]       Calibration factor for Van Rijn’s reference height
    Rwave                 = 2                      [-]       Calibration factor wave roughness height
    RDC                   = 0.01                   [m]       Current related roughness ks
    RDW                   = 0.02                   [m]       Wave related roughness kw
    IopKCW                = 1                                Option for ks and kw
    EpsPar                = False                            Use Van Rijn's parabolic mixing coefficient
[Sediment]
    Name                  = #silt#                           Name of sediment fraction
    SedTyp                = mud                              Must be "sand", "mud" or "bedload"
    IniSedThick           = #silt_IniSedThick.xyz# [m]       Initial sediment layer thickness at bed
    FacDss                = 1                      [-]       Factor for suspended sediment diameter
    RhoSol                = 2650                   [kg/m3]   Specific density
    TraFrm                = -3                               Integer selecting the transport formula
    CDryB                 = 500                    [kg/m3]   Dry bed density
    SalMax                = 31                     [ppt]     Salinity for saline settling velocity
    WS0                   = 0.0001                 [m/s]     Settling velocity fresh water
    WSM                   = 0.0001                 [m/s]     Settling velocity saline water
    EroPar                = #silt_EroPar.xyz#      [kg/m²s]  Erosion parameter
    TcrSed                = 1                      [N/m²]    Critical stress for sedimentation
    TcrEro                = #silt_TcrEro.xyz#      [N/m²]    Critical stress for erosion
    TcrFluff              = 4.94065645841247E-324  [N/m²]    Critical stress for fluff layer erosion
[Sediment]
    Name                  = #clay#                           Name of sediment fraction
    SedTyp                = mud                              Must be "sand", "mud" or "bedload"
    IniSedThick           = #clay_IniSedThick.xyz# [m]       Initial sediment layer thickness at bed
    FacDss                = 1                      [-]       Factor for suspended sediment diameter
    RhoSol                = 2650                   [kg/m3]   Specific density
    TraFrm                = -3                               Integer selecting the transport formula
    CDryB                 = 500                    [kg/m3]   Dry bed density
    SalMax                = 31                     [ppt]     Salinity for saline settling velocity
    WS0                   = 1E-05                  [m/s]     Settling velocity fresh water
    WSM                   = 1E-05                  [m/s]     Settling velocity saline water
    EroPar                = 0.0001                 [kg/m²s]  Erosion parameter
    TcrSed                = 1                      [N/m²]    Critical stress for sedimentation
    TcrEro                = 0.05                   [N/m²]    Critical stress for erosion
    TcrFluff              = 4.94065645841247E-324  [N/m²]    Critical stress for fluff layer erosion
