This folder contains the Delft3D-FM model (coupled with RTC). In this version the best is fixed.
I also included the .bat and .sh files to run the model on Windows and Linux, respectively.

The hydrodynamic model was calibrated using OpenDA using depth-averaged flow velocity measurements, while the sediment transport was calibrated using SSC samples.
The presence of invasive vegetation is modelled using the trachytope model with its distribution derived from Sentinel 2 MSI.

At the outlet, a weird with adjustable crest is used to regulate the water level in the reservoir (this configuration has the same effect of the gate, but was found more stable)