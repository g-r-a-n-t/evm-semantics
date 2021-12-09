requires "edsl.md"

module VERIFICATION
    imports EDSL

    rule BA:ByteArray [ START .. WIDTH1 ] [ 0 .. WIDTH2 ] => BA [ START .. WIDTH2 ]
      requires 0 <=Int START
       andBool 0 <=Int WIDTH2
       andBool WIDTH2 <=Int WIDTH1
      [simplification]

    rule chop(chop(X) +Int Y) => chop(X +Int Y) [simplification]

    rule MU <=Int #memoryUsageUpdate(MU, START, WIDTH) => true requires 0 <=Int START andBool 0 <=Int WIDTH [simplification]

    rule 0 <=Int #memoryUsageUpdate(MU, START, WIDTH) => true requires 0 <=Int MU andBool 0 <=Int START andBool 0 <=Int WIDTH [simplification]

    rule Cmem(SCHED, MU1) <=Int Cmem(SCHED, MU2) => MU1 <=Int MU2 requires 0 <=Int MU1 andBool 0 <=Int MU2 [simplification]

    rule C <=Int X -Int Y +Int Z => false requires Z <=Int Y andBool X <Int C [simplification]

    rule I1 -Int I2 +Int I3 -Int I4 +Int I2 => I1 +Int I3 -Int I4 [simplification]

    rule C <=Int X +Int Z -Int Y => false requires Z <=Int Y andBool X <Int C [simplification]

endmodule
