`define WholeLine  1040   // x lies in [0..WholeLine-1]
`define WholeFrame 666   // y lies in [0..WholeFrame-1]

`define xbits $clog2(`WholeLine)  // how many bits needed to count x?
`define ybits $clog2(`WholeFrame) // how many bits needed to count y?

`define hFrontPorch 56
`define hBackPorch 64
`define hSyncPulse 120
`define vFrontPorch 37
`define vBackPorch 23
`define vSyncPulse 6

`define hSyncPolarity 1'b1
`define vSyncPolarity 1'b1

`define hSyncStart (`WholeLine - `hBackPorch - `hSyncPulse)
`define hSyncEnd (`hSyncStart + `hSyncPulse - 1)
`define vSyncStart (`WholeFrame - `vBackPorch - `vSyncPulse)
`define vSyncEnd (`vSyncStart + `vSyncPulse - 1)

`define hVisible (`WholeLine  - `hFrontPorch - `hSyncPulse - `hBackPorch)
`define vVisible (`WholeFrame - `vFrontPorch - `vSyncPulse - `vBackPorch)