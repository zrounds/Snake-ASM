`define WholeLine  14   // x lies in [0..WholeLine-1]
`define WholeFrame 7    // y lies in [0..WholeFrame-1]

`define xbits $clog2(`WholeLine)    // how many bits are needed to count x?
`define ybits $clog2(`WholeFrame)   // how many bits are needed to count y?

`define hFrontPorch 1
`define hBackPorch 1
`define hSyncPulse 2
`define vFrontPorch 1
`define vBackPorch 1
`define vSyncPulse 1

`define hSyncPolarity 1'b1
`define vSyncPolarity 1'b1

`define hSyncStart (`WholeLine - `hBackPorch - `hSyncPulse)
`define hSyncEnd (`hSyncStart + `hSyncPulse - 1)
`define vSyncStart (`WholeFrame - `vBackPorch - `vSyncPulse)
`define vSyncEnd (`vSyncStart + `vSyncPulse - 1)

`define hVisible (`WholeLine  - `hFrontPorch - `hSyncPulse - `hBackPorch)
`define vVisible (`WholeFrame - `vFrontPorch - `vSyncPulse - `vBackPorch)