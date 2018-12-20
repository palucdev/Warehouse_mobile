# Product quantity synchronization strategy

|   Action   |   Mobile A <br>(global quantity) <br>[local delta]   |   Mobile B <br>(global quantity) <br>[local delta]   |   Backend<br>[starting quantity, delta A, delta B, real quantity]    |   Real state  |
|---------------------------------------------------------------------|:-------------:|:------------:|:------------------:|:-----:|
|Initial state                                                        | (27)<br>[0]   | (27)<br>[0]  | [27, 0, 0, 27]     | 27    |
|Mobile A adds 5 items locally                                        | (27)<br>[-5]  | (27)<br>[0]  | [27, 0, 0, 27]     | 22    |
|__Mobile A sync__                                                    | (27)<br>[-5]  | (27)<br>[0]  | [27, -5, 0, 22]    | 22 (+)|
|Mobile B adds 3 items locally                                        | (27)<br>[-5]  | (27)<br>[+3] | [27, -5, 0, 22]    | 25    |
|__Mobile B sync__                                                    | (27)<br>[-5]  | (22)<br>[+3] | [27, -5, +3, 25]   | 25 (+)|
|Mobile A removes 14 items locally                                    | (27)<br>[-19] | (22)<br>[+3] | [27, -5, +3, 25]   | 11    |
|__Mobile A sync__                                                    | (30)<br>[-19] | (22)<br>[+3] | [27, -19, +3, 11]  | 11 (+)|
|__Mobile B sync__                                                    | (30)<br>[-19] | (8)<br>[+3]  | [27, -19, +3, 11]  | 11 (+)|
|Mobile A adds 7 items locally                                        | (30)<br>[-12] | (8)<br>[+3]  | [27, -19, +3, 11]  | 18    |
|__Mobile A sync (failed to contact backend)__                        | (30)<br>[-12] | (8)<br>[+3]  | [27, -19, +3, 11]  | 18 (-)|
|Mobile B adds 4 items and sync                                       | (30)<br>[-12] | (8)<br>[+7]  | [27, -19, +7, 15]  | 22 (-)|
|__Mobile A sync__                                                    | (34)<br>[-12] | (8)<br>[+7]  | [27, -12, +7, 22]  | 22 (+)|
|Mobile B adds 9 items                                                | (34)<br>[-12] | (8)<br>[+16] | [27, -12, +7, 22]  | 31    |
|__Mobile B sync (backend contact success, return from backend lost)__| (34)<br>[-12] | (8)<br>[+16] | [27, -12, +16, 31] | 31 (+)|
|__Mobile A sync__                                                    | (43)<br>[-12] | (8)<br>[+16] | [27, -12, +16, 31] | 31 (+)|
|__Mobile B sync__                                                    | (43)<br>[-12] | (15)<br>[+16]| [27, -12, +16, 31] | 31 (+)|

### Legend
global quantity = sum(mobile_deltas) - local_delta for given device
starting quantity = const value
(+) -> backend real quantity equals real state after sync
(-) -> backend real quantity differs from real state after sync