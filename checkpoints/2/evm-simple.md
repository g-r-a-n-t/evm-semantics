```k
requires "krypto.md"
requires "json.md"

module EVM
    imports STRING
    imports EVM-DATA

    configuration
      <kevm>
        <k> $PGM:EthereumSimulation </k>
        <ethereum>
          <evm>
            <callState> // KEEP 
              <program> .ByteArray </program> // KEEP
              <jumpDests> .Set </jumpDests> // KEEP
              <pc>          0          </pc>                  // \mu_pc
            </callState>
          </evm>
          <network>
            <accounts> // KEEP
              <account multiplicity="*" type="Map">
                <storage>     .Map                   </storage> // KEEP
              </account>
            </accounts>
          </network>
        </ethereum>
      </kevm>

  syntax EthereumSimulation

  syntax AccountCode ::= ByteArray

  // kept simplifications for these:

// [#] #computeValidJumpDests
  syntax Set ::= #computeValidJumpDests( ByteArray )            [function, memo]
               | #computeValidJumpDests( ByteArray , Int , List ) [function, klabel(#computeValidJumpDestsAux)]
// ---------------------------------------------------------------------------------------------------------
  rule #computeValidJumpDests(PGM) => #computeValidJumpDests(PGM, 0, .List)

  syntax Set ::= #computeValidJumpDestsWithinBound(ByteArray, Int, List) [function]
// ---------------------------------------------------------------------------------
  rule #computeValidJumpDests(PGM, I, RESULT) => List2Set(RESULT) requires I >=Int #sizeByteArray(PGM)
  rule #computeValidJumpDests(PGM, I, RESULT) => #computeValidJumpDestsWithinBound(PGM, I, RESULT) requires I <Int #sizeByteArray(PGM)

  rule #computeValidJumpDestsWithinBound(PGM, I, RESULT) => #computeValidJumpDests(PGM, I +Int 1, RESULT ListItem(I)) requires PGM [ I ] ==Int 91
  rule #computeValidJumpDestsWithinBound(PGM, I, RESULT) => #computeValidJumpDests(PGM, I +Int #widthOpCode(PGM [ I ]), RESULT) requires notBool PGM [ I ] ==Int 91


// [#] #widthOpCode
    syntax Int ::= #widthOpCode(Int) [function]
 // -------------------------------------------
    rule #widthOpCode(W) => W -Int 94 requires W >=Int 96 andBool W <=Int 127
    rule #widthOpCode(_) => 1 [owise]

endmodule


module EVM-DATA
    imports EVM-TYPES
    imports SERIALIZATION
    imports STRING-BUFFER
    imports MAP-SYMBOLIC
    imports COLLECTIONS
endmodule

module ETHEREUM-SIMULATION
    imports EVM
endmodule

module EVM-TYPES
    imports INT
    imports STRING
    imports COLLECTIONS
    imports BYTES

    syntax Int ::= "pow256" /* 2 ^Int 256 */
                 | "pow255" /* 2 ^Int 255 */
                 | "pow224" /* 2 ^Int 224 */
                 | "pow208" /* 2 ^Int 208 */
                 | "pow168" /* 2 ^Int 168 */
                 | "pow160" /* 2 ^Int 160 */
                 | "pow128" /* 2 ^Int 128 */
                 | "pow96"  /* 2 ^Int 96  */
                 | "pow48"  /* 2 ^Int 48  */
                 | "pow16"  /* 2 ^Int 16  */
 // ----------------------------------------
    rule pow256 => 115792089237316195423570985008687907853269984665640564039457584007913129639936 [macro]
    rule pow255 => 57896044618658097711785492504343953926634992332820282019728792003956564819968  [macro]
    rule pow224 => 26959946667150639794667015087019630673637144422540572481103610249216           [macro]
    rule pow208 => 411376139330301510538742295639337626245683966408394965837152256                [macro]
    rule pow168 => 374144419156711147060143317175368453031918731001856                            [macro]
    rule pow160 => 1461501637330902918203684832716283019655932542976                              [macro]
    rule pow128 => 340282366920938463463374607431768211456                                        [macro]
    rule pow96  => 79228162514264337593543950336                                                  [macro]
    rule pow48  => 281474976710656                                                                [macro]
    rule pow16  => 65536                                                                          [macro]

    syntax Int ::= "minSInt128"
                 | "maxSInt128"
                 | "minUInt8"
                 | "maxUInt8"
                 | "minUInt16"
                 | "maxUInt16"
                 | "minUInt48"
                 | "maxUInt48"
                 | "minUInt96"
                 | "maxUInt96"
                 | "minUInt128"
                 | "maxUInt128"
                 | "minUInt160"
                 | "maxUInt160"
                 | "minUInt168"
                 | "maxUInt168"
                 | "minUInt208"
                 | "maxUInt208"
                 | "minUInt224"
                 | "maxUInt224"
                 | "minSInt256"
                 | "maxSInt256"
                 | "minUInt256"
                 | "maxUInt256"
                 | "minSFixed128x10"
                 | "maxSFixed128x10"
                 | "minUFixed128x10"
                 | "maxUFixed128x10"
 // --------------------------------
    rule minSInt128      => -170141183460469231731687303715884105728                                        [macro]  /*  -2^127      */
    rule maxSInt128      =>  170141183460469231731687303715884105727                                        [macro]  /*   2^127 - 1  */
    rule minSFixed128x10 => -1701411834604692317316873037158841057280000000000                              [macro]  /* (-2^127    ) * 10^10 */
    rule maxSFixed128x10 =>  1701411834604692317316873037158841057270000000000                              [macro]  /* ( 2^127 - 1) * 10^10 */
    rule minSInt256      => -57896044618658097711785492504343953926634992332820282019728792003956564819968  [macro]  /*  -2^255      */
    rule maxSInt256      =>  57896044618658097711785492504343953926634992332820282019728792003956564819967  [macro]  /*   2^255 - 1  */

    rule minUInt8        =>  0                                                                              [macro]
    rule maxUInt8        =>  255                                                                            [macro]
    rule minUInt16       =>  0                                                                              [macro]
    rule maxUInt16       =>  65535                                                                          [macro]  /*   2^16 -  1  */
    rule minUInt48       =>  0                                                                              [macro]
    rule maxUInt48       =>  281474976710655                                                                [macro]  /*   2^48 -  1  */
    rule minUInt96       =>  0                                                                              [macro]
    rule maxUInt96       =>  79228162514264337593543950335                                                  [macro]  /*   2^96 -  1  */
    rule minUInt128      =>  0                                                                              [macro]
    rule maxUInt128      =>  340282366920938463463374607431768211455                                        [macro]  /*   2^128 - 1  */
    rule minUFixed128x10 =>  0                                                                              [macro]
    rule maxUFixed128x10 =>  3402823669209384634633746074317682114550000000000                              [macro]  /* ( 2^128 - 1) * 10^10 */
    rule minUInt160      =>  0                                                                              [macro]
    rule maxUInt160      =>  1461501637330902918203684832716283019655932542975                              [macro]  /*   2^160 - 1  */
    rule minUInt168      =>  0                                                                              [macro]
    rule maxUInt168      =>  374144419156711147060143317175368453031918731001855                            [macro]  /*   2^168 - 1  */
    rule minUInt208      =>  0                                                                              [macro]
    rule maxUInt208      =>  411376139330301510538742295639337626245683966408394965837152255                [macro]  /*   2^208 - 1  */
    rule minUInt224      =>  0                                                                              [macro]
    rule maxUInt224      =>  26959946667150639794667015087019630673637144422540572481103610249215           [macro]  /*   2^224 - 1  */
    rule minUInt256      =>  0                                                                              [macro]
    rule maxUInt256      =>  115792089237316195423570985008687907853269984665640564039457584007913129639935 [macro]  /*   2^256 - 1  */

    syntax Int ::= "eth"
 // --------------------
    rule eth => 1000000000000000000 [macro]

    syntax Bool ::= #rangeBool    ( Int )
                  | #rangeSInt    ( Int , Int )
                  | #rangeUInt    ( Int , Int )
                  | #rangeSFixed  ( Int , Int , Int )
                  | #rangeUFixed  ( Int , Int , Int )
                  | #rangeAddress ( Int )
                  | #rangeBytes   ( Int , Int )
 // -------------------------------------------
    rule #rangeBool    (            X ) => X ==Int 0 orBool X ==Int 1                         [macro]
    rule #rangeSInt    ( 128 ,      X ) => #range ( minSInt128      <= X <= maxSInt128      ) [macro]
    rule #rangeSInt    ( 256 ,      X ) => #range ( minSInt256      <= X <= maxSInt256      ) [macro]
    rule #rangeUInt    (   8 ,      X ) => #range ( minUInt8        <= X <  256             ) [macro]
    rule #rangeUInt    (  16 ,      X ) => #range ( minUInt16       <= X <  pow16           ) [macro]
    rule #rangeUInt    (  48 ,      X ) => #range ( minUInt48       <= X <  pow48           ) [macro]
    rule #rangeUInt    (  96 ,      X ) => #range ( minUInt96       <= X <  pow96           ) [macro]
    rule #rangeUInt    ( 128 ,      X ) => #range ( minUInt128      <= X <  pow128          ) [macro]
    rule #rangeUInt    ( 160 ,      X ) => #range ( minUInt160      <= X <  pow160          ) [macro]
    rule #rangeUInt    ( 168 ,      X ) => #range ( minUInt168      <= X <  pow168          ) [macro]
    rule #rangeUInt    ( 208 ,      X ) => #range ( minUInt208      <= X <  pow208          ) [macro]
    rule #rangeUInt    ( 224 ,      X ) => #range ( minUInt224      <= X <  pow224          ) [macro]
    rule #rangeUInt    ( 256 ,      X ) => #range ( minUInt256      <= X <  pow256          ) [macro]
    rule #rangeSFixed  ( 128 , 10 , X ) => #range ( minSFixed128x10 <= X <= maxSFixed128x10 ) [macro]
    rule #rangeUFixed  ( 128 , 10 , X ) => #range ( minUFixed128x10 <= X <= maxUFixed128x10 ) [macro]
    rule #rangeAddress (            X ) => #range ( minUInt160      <= X <  pow160          ) [macro]
    rule #rangeBytes   (   N ,      X ) => #range ( 0               <= X <  1 <<Byte N      ) [macro]

    syntax Bool ::= "#range" "(" Int "<"  Int "<"  Int ")"
                  | "#range" "(" Int "<"  Int "<=" Int ")"
                  | "#range" "(" Int "<=" Int "<"  Int ")"
                  | "#range" "(" Int "<=" Int "<=" Int ")"
 // ------------------------------------------------------
    rule #range ( LB <  X <  UB ) => LB  <Int X andBool X  <Int UB [macro]
    rule #range ( LB <  X <= UB ) => LB  <Int X andBool X <=Int UB [macro]
    rule #range ( LB <= X <  UB ) => LB <=Int X andBool X  <Int UB [macro]
    rule #range ( LB <= X <= UB ) => LB <=Int X andBool X <=Int UB [macro]

    syntax Int ::= chop ( Int ) [function, functional, smtlib(chop)]
 // ----------------------------------------------------------------
    rule chop ( I:Int ) => I modInt pow256 [concrete, smt-lemma]

    syntax Int ::= Int "up/Int" Int [function, functional, smtlib(upDivInt)]
    syntax Int ::= log256Int ( Int ) [function]
    syntax Int ::= Int "+Word" Int [function, functional]
                    | Int "*Word" Int [function, functional]
                    | Int "-Word" Int [function, functional]
                    | Int "/Word" Int [function, functional]
                    | Int "%Word" Int [function, functional]
    syntax Int ::= Int "^Word" Int       [function]
    syntax Int ::= powmod(Int, Int, Int) [function, functional]
    syntax Int ::= Int "/sWord" Int [function]
                    | Int "%sWord" Int [function]
    syntax Int ::= Int "<Word"  Int [function, functional]
                    | Int ">Word"  Int [function, functional]
                    | Int "<=Word" Int [function, functional]
                    | Int ">=Word" Int [function, functional]
                    | Int "==Word" Int [function, functional]
    syntax Int ::= Int "s<Word" Int [function, functional]
    syntax Int ::= "~Word" Int       [function, functional]
                    | Int "|Word"   Int [function, functional]
                    | Int "&Word"   Int [function, functional]
                    | Int "xorWord" Int [function, functional]
                    | Int "<<Word"  Int [function]
                    | Int ">>Word"  Int [function]
                    | Int ">>sWord" Int [function]
    syntax Int ::= bit  ( Int , Int ) [function]
                    | byte ( Int , Int ) [function]
    syntax Int ::= #nBits  ( Int )  [function]
                    | #nBytes ( Int )  [function]
                    | Int "<<Byte" Int [function]
                    | Int ">>Byte" Int [function]
    syntax Int ::= signextend( Int , Int ) [function, functional]

    syntax WordStack [flatPredicate]
    syntax WordStack ::= ".WordStack"      [smtlib(_dotWS)]
                       | Int ":" WordStack [klabel(_:_WS), smtlib(_WS_)]
 // --------------------------------------------------------------------

    syntax Bytes ::= Int ":" Bytes [function]
 // -----------------------------------------
    rule I : BS => Int2Bytes(1, I, BE) ++ BS requires I <Int 256

    syntax WordStack ::= #take ( Int , WordStack ) [klabel(takeWordStack), function, functional]
 // --------------------------------------------------------------------------------------------
    rule [#take.base]:      #take(N, _WS)                => .WordStack                      requires notBool N >Int 0
    rule [#take.zero-pad]:  #take(N, .WordStack)         => 0 : #take(N -Int 1, .WordStack) requires N >Int 0
    rule [#take.recursive]: #take(N, (W : WS):WordStack) => W : #take(N -Int 1, WS)         requires N >Int 0

    syntax WordStack ::= #drop ( Int , WordStack ) [klabel(dropWordStack), function, functional]
 // --------------------------------------------------------------------------------------------
    rule #drop(N, WS:WordStack)       => WS                                  requires notBool N >Int 0
    rule #drop(N, .WordStack)         => .WordStack                          requires         N >Int 0
    rule #drop(N, (W : WS):WordStack) => #drop(1, #drop(N -Int 1, (W : WS))) requires         N >Int 1
    rule #drop(1, (_ : WS):WordStack) => WS

    syntax Bytes ::= #take ( Int , Bytes ) [klabel(takeBytes), function, functional]
 // --------------------------------------------------------------------------------
    rule #take(N, _BS:Bytes) => .Bytes                                      requires                                        notBool N >Int 0
    rule #take(N,  BS:Bytes) => #padRightToWidth(N, .Bytes)                 requires notBool lengthBytes(BS) >Int 0 andBool         N >Int 0
    rule #take(N,  BS:Bytes) => BS ++ #take(N -Int lengthBytes(BS), .Bytes) requires         lengthBytes(BS) >Int 0 andBool notBool N >Int lengthBytes(BS)
    rule #take(N,  BS:Bytes) => BS [ 0 .. N ]                               requires         lengthBytes(BS) >Int 0 andBool         N >Int lengthBytes(BS)

    syntax Bytes ::= #drop ( Int , Bytes ) [klabel(dropBytes), function, functional]
 // --------------------------------------------------------------------------------
    rule #drop(N, BS:Bytes) => BS                                  requires                                        notBool N >Int 0
    rule #drop(N, BS:Bytes) => .Bytes                              requires notBool lengthBytes(BS) >Int 0 andBool         N >Int 0
    rule #drop(N, BS:Bytes) => .Bytes                              requires         lengthBytes(BS) >Int 0 andBool         N >Int lengthBytes(BS)
    rule #drop(N, BS:Bytes) => substrBytes(BS, N, lengthBytes(BS)) requires         lengthBytes(BS) >Int 0 andBool notBool N >Int lengthBytes(BS)

    syntax Int ::= WordStack "[" Int "]" [function, functional]
 // -----------------------------------------------------------
    rule (W : _):WordStack [ N ] => W                  requires N ==Int 0
    rule WS:WordStack      [ N ] => #drop(N, WS) [ 0 ] requires N  >Int 0
    rule  _:WordStack      [ N ] => 0                  requires N  <Int 0

    syntax WordStack ::= WordStack "[" Int ":=" Int "]" [function, functional]
 // --------------------------------------------------------------------------
    rule (_W0 : WS):WordStack [ N := W ] => W  : WS                     requires N ==Int 0
    rule ( W0 : WS):WordStack [ N := W ] => W0 : (WS [ N -Int 1 := W ]) requires N  >Int 0
    rule        WS :WordStack [ N := _ ] => WS                          requires N  <Int 0
    rule .WordStack           [ N := W ] => (0 : .WordStack) [ N := W ]

    syntax Int ::= #sizeWordStack ( WordStack )       [function, functional, smtlib(sizeWordStack)]
                 | #sizeWordStack ( WordStack , Int ) [function, functional, klabel(sizeWordStackAux), smtlib(sizeWordStackAux)]
 // ----------------------------------------------------------------------------------------------------------------------------
    rule #sizeWordStack ( WS ) => #sizeWordStack(WS, 0)
    rule #sizeWordStack ( .WordStack, SIZE ) => SIZE
    rule #sizeWordStack ( _ : WS, SIZE )     => #sizeWordStack(WS, SIZE +Int 1)

    syntax Bool ::= Int "in" WordStack [function]
 // ---------------------------------------------
    rule _ in .WordStack => false
    rule W in (W' : WS)  => (W ==K W') orElseBool (W in WS)

    syntax WordStack ::= #replicate    ( Int, Int )            [function, functional]
                       | #replicateAux ( Int, Int, WordStack ) [function, functional]
 // ---------------------------------------------------------------------------------
    rule #replicate   ( N,  A )     => #replicateAux(N, A, .WordStack)
    rule #replicateAux( N,  A, WS ) => #replicateAux(N -Int 1, A, A : WS) requires         N >Int 0
    rule #replicateAux( N, _A, WS ) => WS                                 requires notBool N >Int 0

    syntax List ::= WordStack2List ( WordStack ) [function, functional]
 // -------------------------------------------------------------------
    rule WordStack2List(.WordStack) => .List
    rule WordStack2List(W : WS) => ListItem(W) WordStack2List(WS)

    syntax Memory = Bytes
    syntax Memory ::= Memory "[" Int ":=" ByteArray "]" [function, functional, klabel(mapWriteBytes)]
 // -------------------------------------------------------------------------------------------------
    rule WS [ START := WS' ] => replaceAtBytes(padRightBytes(WS, START +Int #sizeByteArray(WS'), 0), START, WS') requires START >=Int 0  [concrete]
    rule  _ [ START := _:ByteArray ] => .Memory                                                                  requires START  <Int 0  [concrete]

    syntax ByteArray ::= #range ( Memory , Int , Int ) [function, functional]
 // -------------------------------------------------------------------------
    rule #range(LM, START, WIDTH) => LM [ START .. WIDTH ] [concrete]

    syntax Memory ::= ".Memory"
 // ---------------------------
    rule .Memory => .Bytes [macro]

    syntax Memory ::= Memory "[" Int ":=" Int "]" [function]
 // --------------------------------------------------------
    rule WM [ IDX := VAL ] => padRightBytes(WM, IDX +Int 1, 0) [ IDX <- VAL ]

    syntax ByteArray = Bytes
    syntax ByteArray ::= ".ByteArray"
 // ---------------------------------
    rule .ByteArray => .Bytes [macro]

    syntax Int ::= #asWord ( ByteArray ) [function, functional, smtlib(asWord)]
 // ---------------------------------------------------------------------------
    rule #asWord(WS) => chop(Bytes2Int(WS, BE, Unsigned)) [concrete]

    syntax Int ::= #asInteger ( ByteArray ) [function, functional]
 // --------------------------------------------------------------
    rule #asInteger(WS) => Bytes2Int(WS, BE, Unsigned) [concrete]

    syntax Account ::= #asAccount ( ByteArray ) [function]
 // ------------------------------------------------------
    rule #asAccount(BS) => .Account    requires lengthBytes(BS) ==Int 0
    rule #asAccount(BS) => #asWord(BS) [owise]

    syntax ByteArray ::= #asByteStack ( Int ) [function, functional]
 // ----------------------------------------------------------------
    rule #asByteStack(W) => Int2Bytes(W, BE, Unsigned) [concrete]

    syntax ByteArray ::= ByteArray "++" ByteArray [function, functional, right, klabel(_++_WS), smtlib(_plusWS_)]
 // -------------------------------------------------------------------------------------------------------------
    rule WS ++ WS' => WS +Bytes WS' [concrete]

    syntax ByteArray ::= ByteArray "[" Int ".." Int "]" [function, functional]
 // --------------------------------------------------------------------------
    rule                 _ [ START .. WIDTH ] => .ByteArray                      requires notBool (WIDTH >=Int 0 andBool START >=Int 0)
    rule [bytesRange] : WS [ START .. WIDTH ] => substrBytes(padRightBytes(WS, START +Int WIDTH, 0), START, START +Int WIDTH)
      requires WIDTH >=Int 0 andBool START >=Int 0 andBool START <Int #sizeByteArray(WS)
    rule                 _ [ _     .. WIDTH ] => padRightBytes(.Bytes, WIDTH, 0) [owise]

    syntax Int ::= #sizeByteArray ( ByteArray ) [function, functional, klabel(sizeByteArray), smtlib(sizeByteArray)]
 // ----------------------------------------------------------------------------------------------------------------
    rule #sizeByteArray ( WS ) => lengthBytes(WS) [concrete]

    syntax ByteArray ::= #padToWidth      ( Int , ByteArray ) [function, functional]
                       | #padRightToWidth ( Int , ByteArray ) [function, functional]
 // --------------------------------------------------------------------------------
    rule                        #padToWidth(N, BS)      =>               BS        requires notBool (N >=Int 0)
    rule [padToWidthNonEmpty] : #padToWidth(N, BS)      =>  padLeftBytes(BS, N, 0) requires          N >=Int 0
    rule                        #padRightToWidth(N, BS) =>               BS        requires notBool (N >=Int 0)
    rule                        #padRightToWidth(N, BS) => padRightBytes(BS, N, 0) requires          N >=Int 0

    syntax Account ::= ".Account" | Int
 // -----------------------------------

    syntax Int ::= #addr ( Int ) [function]
 // ---------------------------------------
    rule #addr(W) => W %Word pow160

    syntax Int ::= #lookup        ( Map , Int ) [function, functional, smtlib(lookup)]
                 | #lookupMemory  ( Map , Int ) [function, functional, smtlib(lookupMemory)]
 // ----------------------------------------------------------------------------------------
    rule [#lookup.some]:         #lookup(       (KEY |-> VAL:Int) _M, KEY ) => VAL modInt pow256
    rule [#lookup.none]:         #lookup(                          M, KEY ) => 0                 requires notBool KEY in_keys(M)
    //Impossible case, for completeness
    rule [#lookup.notInt]:       #lookup(       (KEY |-> VAL    ) _M, KEY ) => 0                 requires notBool isInt(VAL)

    rule [#lookupMemory.some]:   #lookupMemory( (KEY |-> VAL:Int) _M, KEY ) => VAL modInt 256
    rule [#lookupMemory.none]:   #lookupMemory(                    M, KEY ) => 0                 requires notBool KEY in_keys(M)
    //Impossible case, for completeness
    rule [#lookupMemory.notInt]: #lookupMemory( (KEY |-> VAL    ) _M, KEY ) => 0                 requires notBool isInt(VAL)

    syntax SubstateLogEntry ::= "{" Int "|" List "|" ByteArray "}" [klabel(logEntry)]
 // ---------------------------------------------------------------------------------

endmodule

module SERIALIZATION
    imports KRYPTO
    imports EVM-TYPES
    imports STRING-BUFFER

    syntax Int ::= keccak ( ByteArray ) [function, functional, smtlib(smt_keccak)]
 // ------------------------------------------------------------------------------
    rule [keccak]: keccak(WS) => #parseHexWord(Keccak256(#unparseByteStack(WS)))

    syntax Int ::= #parseHexWord ( String ) [function]
                 | #parseWord    ( String ) [function]
 // --------------------------------------------------
    rule #parseHexWord("")   => 0
    rule #parseHexWord("0x") => 0
    rule #parseHexWord(S)    => String2Base(replaceAll(S, "0x", ""), 16) requires (S =/=String "") andBool (S =/=String "0x")

    rule #parseWord("") => 0
    rule #parseWord(S)  => #parseHexWord(S) requires lengthString(S) >=Int 2 andBool substrString(S, 0, 2) ==String "0x"
    rule #parseWord(S)  => String2Int(S) [owise]

    syntax String ::= #alignHexString ( String ) [function, functional]
 // -------------------------------------------------------------------
    rule #alignHexString(S) => S             requires         lengthString(S) modInt 2 ==Int 0
    rule #alignHexString(S) => "0" +String S requires notBool lengthString(S) modInt 2 ==Int 0

    syntax ByteArray ::= #parseHexBytes     ( String ) [function]
                       | #parseHexBytesAux  ( String ) [function]
                       | #parseByteStack    ( String ) [function, memo]
                       | #parseByteStackRaw ( String ) [function]
 // -------------------------------------------------------------------
    rule #parseByteStack(S) => #parseHexBytes(replaceAll(S, "0x", ""))

    rule #parseHexBytes(S)  => #parseHexBytesAux(#alignHexString(S))
    rule #parseHexBytesAux("") => .ByteArray
    rule #parseHexBytesAux(S)  => Int2Bytes(lengthString(S) /Int 2, String2Base(S, 16), BE)
      requires lengthString(S) >=Int 2

    rule #parseByteStackRaw(S) => String2Bytes(S)

    syntax Int ::= #parseAddr ( String ) [function]
 // -----------------------------------------------
    rule #parseAddr(S) => #addr(#parseHexWord(S))

    syntax String ::= #unparseByteStack ( ByteArray ) [function, klabel(unparseByteStack), symbol]
 // ----------------------------------------------------------------------------------------------
    rule #unparseByteStack(WS) => Bytes2String(WS)

    syntax String ::= #padByte( String ) [function]
 // -----------------------------------------------
    rule #padByte( S ) => S             requires lengthString(S) ==K 2
    rule #padByte( S ) => "0" +String S requires lengthString(S) ==K 1

    syntax String ::= #unparseQuantity( Int ) [function]
 // ----------------------------------------------------
    rule #unparseQuantity( I ) => "0x" +String Base2String(I, 16)

    syntax String ::= #unparseData          ( Int, Int  ) [function]
                    | #unparseDataByteArray ( ByteArray ) [function]
 // ----------------------------------------------------------------
    rule #unparseData( DATA, LENGTH ) => #unparseDataByteArray(#padToWidth(LENGTH,#asByteStack(DATA)))

    rule #unparseDataByteArray( DATA ) => replaceFirst(Base2String(#asInteger(#asByteStack(1) ++ DATA), 16), "1", "0x")

    syntax String ::= Hex2Raw ( String ) [function]
                    | Raw2Hex ( String ) [function]
 // -----------------------------------------------
    rule Hex2Raw ( S ) => #unparseByteStack( #parseByteStack ( S ) )
    rule Raw2Hex ( S ) => #unparseDataByteArray( #parseByteStackRaw ( S ) )
endmodule

module BUF-SYNTAX
    imports EVM

    syntax ByteArray ::= #bufStrict ( Int , Int ) [function]
    syntax ByteArray ::= #buf ( Int , Int ) [function, functional, smtlib(buf)]

endmodule

module BUF
    imports BUF-SYNTAX
    imports BUF-KORE

    syntax Int ::= #powByteLen ( Int ) [function, no-evaluators]
 // ------------------------------------------------------------
    rule #powByteLen(SIZE) => 2 ^Int (SIZE *Int 8)
    rule 2 ^Int (SIZE *Int 8) => #powByteLen(SIZE) [symbolic(SIZE), simplification]

    rule 0    <Int #powByteLen(SIZE) => true requires 0 <=Int SIZE [simplification]
    rule SIZE <Int #powByteLen(SIZE) => true requires 0 <=Int SIZE [simplification]

    rule #bufStrict(SIZE, DATA) => #buf(SIZE, DATA)
      requires #range(0 <= DATA < (2 ^Int (SIZE *Int 8)))

    rule #buf(SIZE, DATA) => #padToWidth(SIZE, #asByteStack(DATA %Int (2 ^Int (SIZE *Int 8))))
      [concrete]

endmodule

module BUF-KORE [kore, symbolic]
    imports BUF-SYNTAX

    rule #bufStrict(_, _) => #Bottom              [owise]

endmodule

module HASHED-LOCATIONS
    imports EVM
    imports BUF

    syntax Int ::= #hashedLocation( String , Int , IntList ) [function, klabel(hashLoc), smtlib(hashLoc)]
 // -----------------------------------------------------------------------------------------------------
    rule #hashedLocation(_LANG, BASE, .IntList      ) => BASE
    rule #hashedLocation( LANG, BASE, OFFSET OFFSETS) => #hashedLocation(LANG, #hashedLocation(LANG, BASE, OFFSET .IntList), OFFSETS) requires OFFSETS =/=K .IntList

    //rule #hashedLocation("Vyper",    BASE, OFFSET .IntList) => keccak(#bufStrict(32, BASE)   ++ #bufStrict(32, OFFSET)) requires #rangeUInt(256, BASE) andBool #rangeUInt(256, OFFSET)
    rule #hashedLocation("Solidity", BASE, OFFSET .IntList) => keccak(#bufStrict(32, OFFSET) ++ #bufStrict(32, BASE))   requires #rangeUInt(256, BASE) andBool #rangeUInt(256, OFFSET)
    //rule #hashedLocation("Array",    BASE, OFFSET .IntList) => keccak(#bufStrict(32, BASE)) +Word OFFSET                requires #rangeUInt(256, BASE) andBool #rangeUInt(256, OFFSET)

    syntax IntList ::= List{Int, ""} [klabel(intList), smtlib(intList)]
 // -------------------------------------------------------------------
endmodule
```