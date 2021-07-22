```k
requires "krypto.md"
requires "json.md"
```

FILE: evm.md

EVM Execution
=============

### Overview

The EVM is a stack machine over some simple opcodes.
Most of the opcodes are "local" to the execution state of the machine, but some of them must interact with the world state.
This file only defines the local execution operations, the file `driver.md` will define the interactions with the world state.

```k
//requires "data.md"
//requires "network.md"

module EVM
    imports STRING
    imports EVM-DATA
    //imports NETWORK
```

Configuration
-------------

The configuration has cells for the current account id, the current opcode, the program counter, the current gas, the gas price, the current program, the word stack, and the local memory.
In addition, there are cells for the callstack and execution substate.

We've broken up the configuration into two components; those parts of the state that mutate during execution of a single transaction and those that are static throughout.
In the comments next to each cell, we've marked which component of the YellowPaper state corresponds to each cell.

```k
    configuration
      <kevm>
        <k> $PGM:EthereumSimulation </k>
        //<exit-code exit=""> 1 </exit-code>
        //<mode> $MODE:Mode </mode>
        //<schedule> $SCHEDULE:Schedule </schedule>

        <ethereum>

          // EVM Specific
          // ============

          <evm>

            // Mutable during a single transaction
            // -----------------------------------

            //<output>          .ByteArray  </output>           // H_RETURN
            //<statusCode>      .StatusCode </statusCode>
            //<endPC>           0           </endPC>
            //<callStack>       .List       </callStack>
            //<interimStates>   .List       </interimStates>
            //<touchedAccounts> .Set        </touchedAccounts>

            <callState> // KEEP 
              <program> .ByteArray </program> // KEEP
              <jumpDests> .Set </jumpDests> // KEEP

              // I_*
              //<id>        .Account   </id>                    // I_a
              //<caller>    .Account   </caller>                // I_s
              //<callData>  .ByteArray </callData>              // I_d
              //<callValue> 0          </callValue>             // I_v

              // \mu_*
              //<wordStack>   .WordStack </wordStack>           // \mu_s
              //<localMem>    .Memory    </localMem>            // \mu_m
              <pc>          0          </pc>                  // \mu_pc
              //<gas>         0          </gas>                 // \mu_g
              //<memoryUsed>  0          </memoryUsed>          // \mu_i
              //<callGas>     0          </callGas>

              //<static>    false </static>
              //<callDepth> 0     </callDepth>
            </callState>

            // A_* (execution substate)
            //<substate>
            //  <selfDestruct> .Set  </selfDestruct>            // A_s
            //  <log>          .List </log>                     // A_l
            //  <refund>       0     </refund>                  // A_r
            //</substate>

            // Immutable during a single transaction
            // -------------------------------------

            //<gasPrice> 0        </gasPrice>                   // I_p
            //<origin>   .Account </origin>                     // I_o

            // I_H* (block information)
            //<blockhashes> .List </blockhashes>
            //<block>
            //  <previousHash>     0          </previousHash>     // I_Hp
            //  <ommersHash>       0          </ommersHash>       // I_Ho
            //  <coinbase>         0          </coinbase>         // I_Hc
            //  <stateRoot>        0          </stateRoot>        // I_Hr
            //  <transactionsRoot> 0          </transactionsRoot> // I_Ht
            //  <receiptsRoot>     0          </receiptsRoot>     // I_He
            //  <logsBloom>        .ByteArray </logsBloom>        // I_Hb
            //  <difficulty>       0          </difficulty>       // I_Hd
            //  <number>           0          </number>           // I_Hi
            //  <gasLimit>         0          </gasLimit>         // I_Hl
            //  <gasUsed>          0          </gasUsed>          // I_Hg
            //  <timestamp>        0          </timestamp>        // I_Hs
            //  <extraData>        .ByteArray </extraData>        // I_Hx
            //  <mixHash>          0          </mixHash>          // I_Hm
            //  <blockNonce>       0          </blockNonce>       // I_Hn
            //
            //  <ommerBlockHeaders> [ .JSONs ] </ommerBlockHeaders>
            //</block>

          </evm>

          // Ethereum Network
          // ================

          <network>

            // Chain identifier
            // ----------------
            //<chainID> $CHAINID:Int </chainID>

            // Accounts Record
            // ---------------

            //<activeAccounts> .Set </activeAccounts>
            <accounts> // KEEP
              <account multiplicity="*" type="Map">
                //<acctID>      0                      </acctID>
                //<balance>     0                      </balance>
                //<code>        .ByteArray:AccountCode </code>
                <storage>     .Map                   </storage> // KEEP
                //<origStorage> .Map                   </origStorage>
                //<nonce>       0                      </nonce>
              </account>
            </accounts>

            // Transactions Record
            // -------------------

            //<txOrder>   .List </txOrder>
            //<txPending> .List </txPending>

            //<messages>
            //  <message multiplicity="*" type="Map">
            //    <msgID>      0          </msgID>
            //    <txNonce>    0          </txNonce>            // T_n
            //    <txGasPrice> 0          </txGasPrice>         // T_p
            //    <txGasLimit> 0          </txGasLimit>         // T_g
            //    <to>         .Account   </to>                 // T_t
            //    <value>      0          </value>              // T_v
            //    <sigV>       0          </sigV>               // T_w
            //    <sigR>       .ByteArray </sigR>               // T_r
            //    <sigS>       .ByteArray </sigS>               // T_s
            //    <data>       .ByteArray </data>               // T_i/T_e
            //  </message>
            //</messages>

          </network>

        </ethereum>
      </kevm>
```

```k
syntax EthereumSimulation

syntax AccountCode ::= ByteArray

//syntax Mode ::= "NORMAL"  [klabel(NORMAL), symbol]
//              | "VMTESTS" [klabel(VMTESTS), symbol]

//syntax InternalOp ::= "#pushCallStack"
//syntax InternalOp ::= "#popCallStack"
//syntax InternalOp ::= "#dropCallStack"
//syntax Accounts ::= "{" AccountsCellFragment "|" Set "|" SubstateCellFragment "}"
//syntax InternalOp ::= "#pushWorldState"
//syntax InternalOp ::= "#popWorldState"
//syntax InternalOp ::= "#dropWorldState"
//syntax KItem ::= "#halt" | "#end" StatusCode
//syntax KItem ::= "#execute"
//syntax InternalOp ::= "#next" "[" OpCode "]"
//syntax Bool ::= #stackUnderflow ( WordStack , OpCode ) [function]
//                  | #stackUnderflow ( WordStack , Int    ) [function, functional]
//                  | #stackOverflow  ( WordStack , OpCode ) [function]
//syntax Int ::= #stackNeeded ( OpCode ) [function]
//syntax Int ::= #stackAdded ( OpCode ) [function]
//syntax Int ::= #stackDelta ( OpCode ) [function]
//syntax Bool ::= #changesState ( OpCode , WordStack ) [function]
//syntax InternalOp ::= "#exec" "[" OpCode "]"
//syntax KItem  ::= OpCode
//syntax OpCode ::= NullStackOp | UnStackOp | BinStackOp | TernStackOp | QuadStackOp
//                | InvalidOp | StackOp | InternalOp | CallOp | CallSixOp | PushOp
//syntax InternalOp ::= UnStackOp   Int
//                        | BinStackOp  Int Int
//                        | TernStackOp Int Int Int
//                        | QuadStackOp Int Int Int Int
//syntax InternalOp ::= StackOp WordStack
//syntax InternalOp ::= CallSixOp Int Int     Int Int Int Int
//                        | CallOp    Int Int Int Int Int Int Int
//syntax InternalOp ::= "#addr" "[" OpCode "]"
//syntax Bool ::= isAddr1Op ( OpCode ) [function, functional]
//                  | isAddr2Op ( OpCode ) [function, functional]
//syntax InternalOp ::= "#pc" "[" OpCode "]"
//syntax Int ::= #widthOp ( OpCode ) [function]
//syntax InternalOp ::= #finalizeStorage ( List )
//syntax InternalOp ::= #finalizeTx ( Bool )
//                        | #deleteAccounts ( List )
//syntax EthereumCommand ::= "#startBlock"
//syntax EthereumCommand ::= "#finalizeBlock" | #rewardOmmers ( JSONs )
//syntax ByteArray ::= #bloomFilter(List)      [function]
//                       | #bloomFilter(List, Int) [function, klabel(#bloomFilterAux)]
//syntax List ::= listAsByteArrays(List) [function]
//syntax Int ::= "M3:2048" "(" ByteArray ")" [function]
//syntax Int ::= setBloomFilterBits(ByteArray) [function]
//syntax Int ::= getBloomFilterBit(ByteArray, Int) [function]
//syntax InternalOp ::= "#push" | "#setStack" WordStack
//syntax InternalOp ::= "#newAccount" Int
//                        | "#newExistingAccount" Int
//                        | "#newFreshAccount" Int
//syntax InternalOp ::= "#transferFunds" Int Int Int
//syntax InvalidOp ::= "INVALID" | "UNDEFINED" "(" Int ")"
//syntax UnStackOp ::= "POP"
//syntax StackOp ::= DUP ( Int ) | SWAP ( Int )
//syntax PushOp ::= PUSH ( Int )
//syntax UnStackOp ::= "MLOAD"
//syntax BinStackOp ::= "MSTORE" | "MSTORE8"
//syntax UnStackOp ::= "ISZERO" | "NOT"
//syntax BinStackOp ::= "ADD" | "MUL" | "SUB" | "DIV" | "EXP" | "MOD"
//syntax BinStackOp ::= "SDIV" | "SMOD"
//syntax TernStackOp ::= "ADDMOD" | "MULMOD"
//syntax BinStackOp ::= "BYTE" | "SIGNEXTEND"
//syntax BinStackOp ::= "SHL" | "SHR" | "SAR"
//syntax BinStackOp ::= "AND" | "EVMOR" | "XOR"
//syntax BinStackOp ::= "LT" | "GT" | "EQ"
//syntax BinStackOp ::= "SLT" | "SGT"
//syntax BinStackOp ::= "SHA3"
//syntax NullStackOp ::= "PC" | "GAS" | "GASPRICE" | "GASLIMIT"
//syntax NullStackOp ::= "COINBASE" | "TIMESTAMP" | "NUMBER" | "DIFFICULTY"
//syntax NullStackOp ::= "ADDRESS" | "ORIGIN" | "CALLER" | "CALLVALUE" | "CHAINID" | "SELFBALANCE"
//syntax NullStackOp ::= "MSIZE" | "CODESIZE"
//syntax TernStackOp ::= "CODECOPY"
//syntax UnStackOp ::= "BLOCKHASH"
//syntax Int ::= #blockhash ( List , Int , Int , Int ) [function]
//syntax NullStackOp ::= "JUMPDEST"
//syntax UnStackOp ::= "JUMP"
//syntax BinStackOp ::= "JUMPI"
//syntax InternalOp ::= "#endBasicBlock"
//syntax NullStackOp ::= "STOP"
//syntax BinStackOp ::= "RETURN"
//syntax BinStackOp ::= "REVERT"
//syntax NullStackOp ::= "CALLDATASIZE"
//syntax UnStackOp ::= "CALLDATALOAD"
//syntax TernStackOp ::= "CALLDATACOPY"
//syntax NullStackOp ::= "RETURNDATASIZE"
//syntax TernStackOp ::= "RETURNDATACOPY"
//syntax BinStackOp ::= LogOp
//syntax LogOp ::= LOG ( Int )
//syntax UnStackOp ::= "BALANCE"
//syntax UnStackOp ::= "EXTCODESIZE"
//syntax UnStackOp ::= "EXTCODEHASH"
//syntax QuadStackOp ::= "EXTCODECOPY"
//syntax UnStackOp ::= "SLOAD"
//syntax BinStackOp ::= "SSTORE"
//syntax InternalOp ::= "#checkCall" Int Int
//                        | "#call"         Int Int Int Int Int ByteArray Bool
//                        | "#callWithCode" Int Int Int ByteArray Int Int ByteArray Bool
//                        | "#mkCall"       Int Int Int ByteArray     Int ByteArray Bool
//syntax InternalOp ::= "#precompiled?" "(" Int "," Schedule ")"
//syntax Bool ::= #isPrecompiledAccount ( Int , Schedule ) [function, functional, smtlib(isPrecompiledAccount)]
//syntax KItem ::= "#initVM"
//syntax KItem ::= "#loadProgram" ByteArray
//syntax KItem ::= "#touchAccounts" Account | "#touchAccounts" Account Account

//syntax Int ::= #widthOpCode(Int) [function]
//syntax KItem ::= "#return" Int Int
//syntax InternalOp ::= "#refund" Exp [strict]
//                        | "#setLocalMem" Int Int ByteArray
//syntax CallOp ::= "CALL"
//syntax CallOp ::= "CALLCODE"
//syntax CallSixOp ::= "DELEGATECALL"
//syntax CallSixOp ::= "STATICCALL"
//syntax InternalOp ::= "#create"   Int Int Int ByteArray
//                        | "#mkCreate" Int Int Int ByteArray
//                        | "#incrementNonce" Int
//syntax KItem ::= "#codeDeposit" Int
//                   | "#mkCodeDeposit" Int
//                   | "#finishCodeDeposit" Int ByteArray
//syntax TernStackOp ::= "CREATE"
//syntax QuadStackOp ::= "CREATE2"
//syntax UnStackOp ::= "SELFDESTRUCT"
//syntax NullStackOp   ::= PrecompiledOp
//syntax PrecompiledOp ::= #precompiled ( Int ) [function]
//syntax Set ::= #precompiledAccounts ( Schedule ) [function, functional]
//syntax PrecompiledOp ::= "ECREC"
//syntax ByteArray ::= #ecrec ( Account ) [function]
//syntax PrecompiledOp ::= "SHA256"
//syntax PrecompiledOp ::= "RIP160"
//syntax PrecompiledOp ::= "ID"
//syntax PrecompiledOp ::= "MODEXP"
//syntax ByteArray ::= #modexp1 ( Int , Int , Int , ByteArray ) [function]
//                       | #modexp2 ( Int , Int , Int , ByteArray ) [function]
//                       | #modexp3 ( Int , Int , Int , ByteArray ) [function]
//                       | #modexp4 ( Int , Int , Int )             [function]
//syntax PrecompiledOp ::= "ECADD"
//syntax InternalOp ::= #ecadd(G1Point, G1Point)
//syntax PrecompiledOp ::= "ECMUL"
//syntax InternalOp ::= #ecmul(G1Point, Int)
//syntax ByteArray ::= #point ( G1Point ) [function]
//syntax PrecompiledOp ::= "ECPAIRING"
//syntax InternalOp ::= #ecpairing(List, List, Int, ByteArray, Int)
//syntax InternalOp ::= "#checkPoint"
//syntax PrecompiledOp ::= "BLAKE2F"
//syntax InternalOp ::= "#gas" "[" OpCode "," OpCode "]"
//syntax InternalOp ::= "#gas"    "[" OpCode "]" | "#deductGas" | "#deductMemoryGas"
//                        | "#memory" "[" OpCode "]" | "#deductMemory"
//syntax Int ::= #memory ( OpCode , Int ) [function]
//syntax Bool ::= #usesMemory ( OpCode ) [function]
//syntax Int ::= #memoryUsageUpdate ( Int , Int , Int ) [function, functional]
//syntax InternalOp ::= #gasExec ( Schedule , OpCode )
//syntax InternalOp ::= "#allocateCallGas"
//syntax InternalOp ::= "#allocateCreateGas"
//syntax Exp     ::= Int
//syntax KResult ::= Int
//syntax Exp ::= Ccall         ( Schedule , BExp , Int , Int , Int ) [strict(2)]
//              | Ccallgas      ( Schedule , BExp , Int , Int , Int ) [strict(2)]
//              | Cselfdestruct ( Schedule , BExp , Int )             [strict(2)]
//syntax Int ::= Cgascap ( Schedule , Int , Int , Int ) [function, functional, smtlib(gas_Cgascap)   ]
//                 | Csstore ( Schedule , Int , Int , Int ) [function, functional, smtlib(gas_Csstore)   ]
//                 | Rsstore ( Schedule , Int , Int , Int ) [function, functional, smtlib(gas_Rsstore)   ]
//                 | Cextra  ( Schedule , Bool , Int )      [function, functional, smtlib(gas_Cextra)    ]
//                 | Cnew    ( Schedule , Bool , Int )      [function, functional, smtlib(gas_Cnew)      ]
//                 | Cxfer   ( Schedule , Int )             [function, functional, smtlib(gas_Cxfer)     ]
//                 | Cmem    ( Schedule , Int )             [function, functional, smtlib(gas_Cmem), memo]
//syntax BExp    ::= Bool
//syntax KResult ::= Bool
//syntax BExp ::= #accountNonexistent ( Int )
//syntax Bool ::= #accountEmpty ( AccountCode , Int , Int ) [function, klabel(accountEmpty), symbol]
//syntax Int ::= #allBut64th ( Int ) [function, functional, smtlib(gas_allBut64th)]
//syntax Int ::= G0 ( Schedule , ByteArray , Bool ) [function]
//syntax Int ::= "G*" "(" Int "," Int "," Int ")" [function]
//syntax Int ::= #multComplexity(Int) [function]
//syntax Int ::= #adjustedExpLength(Int, Int, ByteArray) [function]
//                 | #adjustedExpLength(Int)                 [function, klabel(#adjustedExpLengthAux)]
//syntax Bool ::= ScheduleFlag "<<" Schedule ">>" [function, functional]
//syntax ScheduleFlag ::= "Gselfdestructnewaccount" | "Gstaticcalldepth" | "Gemptyisnonexistent" | "Gzerovaluenewaccountgas"
//                          | "Ghasrevert"              | "Ghasreturndata"   | "Ghasstaticcall"      | "Ghasshift"
//                          | "Ghasdirtysstore"         | "Ghascreate2"      | "Ghasextcodehash"     | "Ghasselfbalance"
//                          | "Ghassstorestipend"       | "Ghaschainid"
//syntax Int ::= ScheduleConst "<" Schedule ">" [function, functional]
//syntax ScheduleConst ::= "Gzero"        | "Gbase"          | "Gverylow"      | "Glow"          | "Gmid"        | "Ghigh"
//                           | "Gextcodesize" | "Gextcodecopy"   | "Gbalance"      | "Gsload"        | "Gjumpdest"   | "Gsstoreset"
//                           | "Gsstorereset" | "Rsstoreclear"   | "Rselfdestruct" | "Gselfdestruct" | "Gcreate"     | "Gcodedeposit"  | "Gcall"
//                           | "Gcallvalue"   | "Gcallstipend"   | "Gnewaccount"   | "Gexp"          | "Gexpbyte"    | "Gmemory"       | "Gtxcreate"
//                           | "Gtxdatazero"  | "Gtxdatanonzero" | "Gtransaction"  | "Glog"          | "Glogdata"    | "Glogtopic"     | "Gsha3"
//                           | "Gsha3word"    | "Gcopy"          | "Gblockhash"    | "Gquadcoeff"    | "maxCodeSize" | "Rb"            | "Gquaddivisor"
//                           | "Gecadd"       | "Gecmul"         | "Gecpairconst"  | "Gecpaircoeff"  | "Gfround"
//syntax Schedule ::= "DEFAULT" [klabel(DEFAULT_EVM), symbol, smtlib(schedule_DEFAULT)]
//syntax Schedule ::= "FRONTIER" [klabel(FRONTIER_EVM), symbol, smtlib(schedule_FRONTIER)]
//syntax Schedule ::= "HOMESTEAD" [klabel(HOMESTEAD_EVM), symbol, smtlib(schedule_HOMESTEAD)]
//syntax Schedule ::= "TANGERINE_WHISTLE" [klabel(TANGERINE_WHISTLE_EVM), symbol, smtlib(schedule_TANGERINE_WHISTLE)]
//syntax Schedule ::= "SPURIOUS_DRAGON" [klabel(SPURIOUS_DRAGON_EVM), symbol, smtlib(schedule_SPURIOUS_DRAGON)]
//syntax Schedule ::= "BYZANTIUM" [klabel(BYZANTIUM_EVM), symbol, smtlib(schedule_BYZANTIUM)]
//syntax Schedule ::= "CONSTANTINOPLE" [klabel(CONSTANTINOPLE_EVM), symbol, smtlib(schedule_CONSTANTINOPLE)]
//syntax Schedule ::= "PETERSBURG" [klabel(PETERSBURG_EVM), symbol, smtlib(schedule_PETERSBURG)]
//syntax Schedule ::= "ISTANBUL" [klabel(ISTANBUL_EVM), symbol, smtlib(schedule_ISTANBUL)]
//syntax OpCode ::= #dasmOpCode ( Int , Schedule ) [function, memo]

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

```

```k
endmodule
```

FILE: data.md

EVM Words
=========

```k
//requires "evm-types.md"
//requires "json-rpc.md"
//requires "serialization.md"
```

```k
module EVM-DATA
    imports EVM-TYPES
    imports SERIALIZATION
    imports STRING-BUFFER
    imports MAP-SYMBOLIC
    imports COLLECTIONS
    //imports JSON-EXT
```

```k
endmodule
```

```k
module ETHEREUM-SIMULATION
    imports EVM
endmodule
```

FILE: evm-types.md

Data-Structures over `Word`
===========================

EVM uses bounded 256 bit integer words, and sometimes also bytes (8 bit words).
Here we provide the arithmetic of these words, as well as some data-structures over them.
Both are implemented using K's `Int`.

```k
module EVM-TYPES
    imports INT
    imports STRING
    imports COLLECTIONS
```

```{.k .bytes}
    imports BYTES
```

Utilities
---------

### Important Powers

Some important numbers that are referred to often during execution.
These can be used for pattern-matching on the LHS of rules as well (`macro` attribute expands all occurances of these in rules).

```k
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
```

-   Range of types

```k
//     syntax Bool ::= #rangeBool    ( Int )
//                   | #rangeSInt    ( Int , Int )
//                   | #rangeUInt    ( Int , Int )
//                   | #rangeSFixed  ( Int , Int , Int )
//                   | #rangeUFixed  ( Int , Int , Int )
//                   | #rangeAddress ( Int )
//                   | #rangeBytes   ( Int , Int )
//  // -------------------------------------------
//     rule #rangeBool    (            X ) => X ==Int 0 orBool X ==Int 1                         [macro]
//     rule #rangeSInt    ( 128 ,      X ) => #range ( minSInt128      <= X <= maxSInt128      ) [macro]
//     rule #rangeSInt    ( 256 ,      X ) => #range ( minSInt256      <= X <= maxSInt256      ) [macro]
//     rule #rangeUInt    (   8 ,      X ) => #range ( minUInt8        <= X <  256             ) [macro]
//     rule #rangeUInt    (  16 ,      X ) => #range ( minUInt16       <= X <  pow16           ) [macro]
//     rule #rangeUInt    (  48 ,      X ) => #range ( minUInt48       <= X <  pow48           ) [macro]
//     rule #rangeUInt    (  96 ,      X ) => #range ( minUInt96       <= X <  pow96           ) [macro]
//     rule #rangeUInt    ( 128 ,      X ) => #range ( minUInt128      <= X <  pow128          ) [macro]
//     rule #rangeUInt    ( 160 ,      X ) => #range ( minUInt160      <= X <  pow160          ) [macro]
//     rule #rangeUInt    ( 168 ,      X ) => #range ( minUInt168      <= X <  pow168          ) [macro]
//     rule #rangeUInt    ( 208 ,      X ) => #range ( minUInt208      <= X <  pow208          ) [macro]
//     rule #rangeUInt    ( 224 ,      X ) => #range ( minUInt224      <= X <  pow224          ) [macro]
//     rule #rangeUInt    ( 256 ,      X ) => #range ( minUInt256      <= X <  pow256          ) [macro]
//     rule #rangeSFixed  ( 128 , 10 , X ) => #range ( minSFixed128x10 <= X <= maxSFixed128x10 ) [macro]
//     rule #rangeUFixed  ( 128 , 10 , X ) => #range ( minUFixed128x10 <= X <= maxUFixed128x10 ) [macro]
//     rule #rangeAddress (            X ) => #range ( minUInt160      <= X <  pow160          ) [macro]
//     rule #rangeBytes   (   N ,      X ) => #range ( 0               <= X <  1 <<Byte N      ) [macro]

//     syntax Bool ::= "#range" "(" Int "<"  Int "<"  Int ")"
//                   | "#range" "(" Int "<"  Int "<=" Int ")"
//                   | "#range" "(" Int "<=" Int "<"  Int ")"
//                   | "#range" "(" Int "<=" Int "<=" Int ")"
//  // ------------------------------------------------------
//     rule #range ( LB <  X <  UB ) => LB  <Int X andBool X  <Int UB [macro]
//     rule #range ( LB <  X <= UB ) => LB  <Int X andBool X <=Int UB [macro]
//     rule #range ( LB <= X <  UB ) => LB <=Int X andBool X  <Int UB [macro]
//     rule #range ( LB <= X <= UB ) => LB <=Int X andBool X <=Int UB [macro]
```

-   `chop` interprets an integer modulo $2^256$.

```k
    syntax Int ::= chop ( Int ) [function, functional, smtlib(chop)]
 // ----------------------------------------------------------------
    rule chop ( I:Int ) => I modInt pow256 [concrete, smt-lemma]
```

### Boolean Conversions

Primitives provide the basic conversion from K's sorts `Int` and `Bool` to EVM's words.

-   `bool2Word` interprets a `Bool` as a `Int`.
-   `word2Bool` interprets a `Int` as a `Bool`.

```k
    //syntax Int ::= bool2Word ( Bool ) [function, functional, smtlib(bool2Word)]
 // ---------------------------------------------------------------------------
    //rule bool2Word( B:Bool ) => 1 requires B
    //rule bool2Word( B:Bool ) => 0 requires notBool B

    //syntax Bool ::= word2Bool ( Int ) [function, functional]
 // --------------------------------------------------------
    //rule word2Bool( W ) => false requires W  ==Int 0
    //rule word2Bool( W ) => true  requires W =/=Int 0
```

-   `sgn` gives the twos-complement interperetation of the sign of a word.
-   `abs` gives the twos-complement interperetation of the magnitude of a word.

```k
    //syntax Int ::= sgn ( Int ) [function, functional]
    //             | abs ( Int ) [function, functional]
 // -------------------------------------------------
    //rule sgn(I) => -1 requires pow255 <=Int I andBool I <Int pow256
    //rule sgn(I) =>  1 requires 0 <=Int I andBool I <Int pow255
    //rule sgn(I) =>  0 requires I <Int 0 orBool pow256 <=Int I

    //rule abs(I) => 0 -Word I requires sgn(I) ==Int -1
    //rule abs(I) => I         requires sgn(I) ==Int  1
    //rule abs(I) => 0         requires sgn(I) ==Int  0
```

Word Operations
---------------

```k
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
```

A WordStack for EVM
-------------------

### As a cons-list

A cons-list is used for the EVM wordstack.

-   `.WordStack` serves as the empty worstack, and
-   `_:_` serves as the "cons" operator.

```k
    syntax WordStack [flatPredicate]
    syntax WordStack ::= ".WordStack"      [smtlib(_dotWS)]
                       | Int ":" WordStack [klabel(_:_WS), smtlib(_WS_)]
 // --------------------------------------------------------------------
```

```{.k .bytes}
    syntax Bytes ::= Int ":" Bytes [function]
 // -----------------------------------------
    rule I : BS => Int2Bytes(1, I, BE) ++ BS requires I <Int 256
```

-   `#take(N , WS)` keeps the first $N$ elements of a `WordStack` (passing with zeros as needed).
-   `#drop(N , WS)` removes the first $N$ elements of a `WordStack`.

```k
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
```

```{.k .bytes}
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
```

### Element Access

-   `WS [ N ]` accesses element $N$ of $WS$.
-   `WS [ N := W ]` sets element $N$ of $WS$ to $W$ (padding with zeros as needed).

```k
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
```

-   `#sizeWordStack` calculates the size of a `WordStack`.
-   `_in_` determines if a `Int` occurs in a `WordStack`.

```k
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
```

-   `#replicateAux` pushes `N` copies of `A` onto a `WordStack`.
-   `#replicate` is a `WordStack` of length `N` with `A` the value of every element.

```k
    syntax WordStack ::= #replicate    ( Int, Int )            [function, functional]
                       | #replicateAux ( Int, Int, WordStack ) [function, functional]
 // ---------------------------------------------------------------------------------
    rule #replicate   ( N,  A )     => #replicateAux(N, A, .WordStack)
    rule #replicateAux( N,  A, WS ) => #replicateAux(N -Int 1, A, A : WS) requires         N >Int 0
    rule #replicateAux( N, _A, WS ) => WS                                 requires notBool N >Int 0
```

-   `WordStack2List` converts a term of sort `WordStack` to a term of sort `List`.

```k
    syntax List ::= WordStack2List ( WordStack ) [function, functional]
 // -------------------------------------------------------------------
    rule WordStack2List(.WordStack) => .List
    rule WordStack2List(W : WS) => ListItem(W) WordStack2List(WS)
```

Local Memory
------------

Most of EVM data is held in local memory.

-   `WM [ N := WS ]` assigns a contiguous chunk of $WM$ to $WS$ starting at position $W$.
-   `#range(M, START, WIDTH)` reads off $WIDTH$ elements from $WM$ beginning at position $START$ (padding with zeros as needed).

```{.k .bytes}
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
```

Byte Arrays
-----------

The local memory of execution is a byte-array (instead of a word-array).

-   `#asWord` will interperet a stack of bytes as a single word (with MSB first).
-   `#asInteger` will interperet a stack of bytes as a single arbitrary-precision integer (with MSB first).
-   `#asAccount` will interpret a stack of bytes as a single account id (with MSB first).
    Differs from `#asWord` only in that an empty stack represents the empty account, not account zero.
-   `#asByteStack` will split a single word up into a `ByteArray`.
-   `_++_` acts as `ByteArray` append.
-   `WS [ N .. W ]` access the range of `WS` beginning with `N` of width `W`.
-   `#sizeByteArray` calculates the size of a `ByteArray`.
-   `#padToWidth(N, WS)` and `#padRightToWidth` make sure that a `WordStack` is the correct size.

```{.k .bytes}
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
```

Accounts
--------

### Empty Account

-   `.Account` represents the case when an account ID is referenced in the yellowpaper, but
    the actual value of the account ID is the empty set. This is used, for example, when
    referring to the destination of a message which creates a new contract.

```k
    syntax Account ::= ".Account" | Int
 // -----------------------------------
```

### Addresses

-   `#addr` turns an Ethereum word into the corresponding Ethereum address (160 LSB).

```k
    syntax Int ::= #addr ( Int ) [function]
 // ---------------------------------------
    rule #addr(W) => W %Word pow160
```

Storage/Memory Lookup
---------------------

`#lookup*` looks up a key in a map and returns 0 if the key doesn't exist, otherwise returning its value.

```k
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
```

Substate Log
------------

During execution of a transaction some things are recorded in the substate log (Section 6.1 in YellowPaper).
This is a right cons-list of `SubstateLogEntry` (which contains the account ID along with the specified portions of the `wordStack` and `localMem`).

```k
    syntax SubstateLogEntry ::= "{" Int "|" List "|" ByteArray "}" [klabel(logEntry)]
 // ---------------------------------------------------------------------------------
```

```k
endmodule
```

FILE: serialization.md

Parsing/Unparsing
=================

```k
//requires "krypto.md"
//requires "evm-types.md"
//requires "json-rpc.md"
```

```k
module SERIALIZATION
    imports KRYPTO
    imports EVM-TYPES
    imports STRING-BUFFER
    //imports JSON-EXT
```

Address/Hash Helpers
--------------------

-   `keccak` serves as a wrapper around the `Keccak256` in `KRYPTO`.

```k
    syntax Int ::= keccak ( ByteArray ) [function, functional, smtlib(smt_keccak)]
 // ------------------------------------------------------------------------------
    rule [keccak]: keccak(WS) => #parseHexWord(Keccak256(#unparseByteStack(WS)))
```

-   `#newAddr` computes the address of a new account given the address and nonce of the creating account.
-   `#sender` computes the sender of the transaction from its data and signature.
-   `#addrFromPrivateKey` computes the address of an account given its private key

```k
    //syntax Int ::= #newAddr ( Int , Int ) [function]
//                  | #newAddr ( Int , Int , ByteArray ) [function, klabel(#newAddrCreate2)]
//  // -------------------------------------------------------------------------------------
//     rule [#newAddr]:        #newAddr(ACCT, NONCE) => #addr(#parseHexWord(Keccak256(#rlpEncodeLength(#rlpEncodeBytes(ACCT, 20) +String #rlpEncodeWord(NONCE), 192))))
//     rule [#newAddrCreate2]: #newAddr(ACCT, SALT, INITCODE) => #addr(#parseHexWord(Keccak256("\xff" +String #unparseByteStack(#padToWidth(20, #asByteStack(ACCT))) +String #unparseByteStack(#padToWidth(32, #asByteStack(SALT))) +String #unparseByteStack(#parseHexBytes(Keccak256(#unparseByteStack(INITCODE)))))))

//     syntax Account ::= #sender ( Int , Int , Int , Account , Int , String , Int , ByteArray , ByteArray, Int ) [function]
//                      | #sender ( String , Int , String , String )                                              [function, klabel(#senderAux)]
//                      | #sender ( String )                                                                      [function, klabel(#senderAux2)]
//  // ------------------------------------------------------------------------------------------------------------------------------------------
//     rule #sender(TN, TP, TG, TT, TV, DATA, TW, TR, TS, _CID)
//       => #sender(#unparseByteStack(#parseHexBytes(#hashUnsignedTx(TN, TP, TG, TT, TV, #parseByteStackRaw(DATA)))), TW, #unparseByteStack(TR), #unparseByteStack(TS))
//       requires TW ==Int 27 orBool TW ==Int 28

//     rule #sender(TN, TP, TG, TT, TV, DATA, TW, TR, TS, CID)
//       => #sender(#unparseByteStack(#parseHexBytes(#hashUnsignedTx(TN, TP, TG, TT, TV, #parseByteStackRaw(DATA), CID))), 28 -Int (TW %Int 2), #unparseByteStack(TR), #unparseByteStack(TS))
//       requires TW ==Int CID *Int 2 +Int 35 orBool TW ==Int CID *Int 2 +Int 36

//     rule #sender(_, _, _, _, _, _, _, _, _, _) => .Account [owise]

//     rule #sender(HT, TW, TR, TS) => #sender(ECDSARecover(HT, TW, TR, TS))

//     rule #sender("")  => .Account
//     rule #sender(STR) => #addr(#parseHexWord(Keccak256(STR))) requires STR =/=String ""

//     syntax Int ::= #addrFromPrivateKey ( String ) [function]
//  // --------------------------------------------------------
//     rule #addrFromPrivateKey ( KEY ) => #addr( #parseHexWord( Keccak256 ( Hex2Raw( ECDSAPubKey( Hex2Raw( KEY ) ) ) ) ) )
```

-   `#blockHeaderHash` computes the hash of a block header given all the block data.

```k
//     syntax Int ::= #blockHeaderHash( Int , Int , Int , Int , Int , Int , ByteArray , Int , Int , Int , Int , Int , ByteArray , Int , Int ) [function, klabel(blockHeaderHash), symbol]
//                  | #blockHeaderHash(String, String, String, String, String, String, String, String, String, String, String, String, String, String, String) [function, klabel(#blockHashHeaderStr), symbol]
//  // -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//    rule #blockHeaderHash(HP, HO, HC, HR, HT, HE, HB, HD, HI, HL, HG, HS, HX, HM, HN)
//          => #blockHeaderHash(#asWord(#parseByteStackRaw(HP)),
//                              #asWord(#parseByteStackRaw(HO)),
//                              #asWord(#parseByteStackRaw(HC)),
//                              #asWord(#parseByteStackRaw(HR)),
//                              #asWord(#parseByteStackRaw(HT)),
//                              #asWord(#parseByteStackRaw(HE)),
//                                      #parseByteStackRaw(HB) ,
//                              #asWord(#parseByteStackRaw(HD)),
//                              #asWord(#parseByteStackRaw(HI)),
//                              #asWord(#parseByteStackRaw(HL)),
//                              #asWord(#parseByteStackRaw(HG)),
//                              #asWord(#parseByteStackRaw(HS)),
//                                      #parseByteStackRaw(HX) ,
//                              #asWord(#parseByteStackRaw(HM)),
//                              #asWord(#parseByteStackRaw(HN)))

//     rule #blockHeaderHash(HP, HO, HC, HR, HT, HE, HB, HD, HI, HL, HG, HS, HX, HM, HN)
//          => #parseHexWord(Keccak256(#rlpEncodeLength(         #rlpEncodeBytes(HP, 32)
//                                                       +String #rlpEncodeBytes(HO, 32)
//                                                       +String #rlpEncodeBytes(HC, 20)
//                                                       +String #rlpEncodeBytes(HR, 32)
//                                                       +String #rlpEncodeBytes(HT, 32)
//                                                       +String #rlpEncodeBytes(HE, 32)
//                                                       +String #rlpEncodeString(#unparseByteStack(HB))
//                                                       +String #rlpEncodeWordStack(HD : HI : HL : HG : HS : .WordStack)
//                                                       +String #rlpEncodeString(#unparseByteStack(HX))
//                                                       +String #rlpEncodeBytes(HM, 32)
//                                                       +String #rlpEncodeBytes(HN, 8),
//                                                     192)))

```

- `#hashSignedTx` Takes transaction data. Returns the hash of the rlp-encoded transaction with R S and V.
- `#hashUnsignedTx` Returns the hash of the rlp-encoded transaction without R S or V.

```k
//     syntax String ::= #hashSignedTx   ( Int , Int , Int , Account , Int , ByteArray , Int , ByteArray , ByteArray ) [function]
//                     | #hashUnsignedTx ( Int , Int , Int , Account , Int , ByteArray )                               [function]
//                     | #hashUnsignedTx ( Int , Int , Int , Account , Int , ByteArray, Int )                          [function]
//  // --------------------------------------------------------------------------------------------------------------------------
//     rule [hashTx]: #hashSignedTx(TN, TP, TG, TT, TV, TD, TW, TR, TS)
//                 => Keccak256( #rlpEncodeTransaction(TN, TP, TG, TT, TV, TD, TW, TR, TS) )

//     rule [hashFakeTx]: #hashUnsignedTx(TN, TP, TG, TT, TV, TD)
//                     => Keccak256( #rlpEncodeLength(         #rlpEncodeWord(TN)
//                                                     +String #rlpEncodeWord(TP)
//                                                     +String #rlpEncodeWord(TG)
//                                                     +String #rlpEncodeAccount(TT)
//                                                     +String #rlpEncodeWord(TV)
//                                                     +String #rlpEncodeString(#unparseByteStack(TD))
//                                                   , 192
//                                                   )
//                                 )

//     rule [hashFakeTx2]: #hashUnsignedTx(TN, TP, TG, TT, TV, TD, CID)
//                      => Keccak256( #rlpEncodeLength(         #rlpEncodeWord(TN)
//                                                      +String #rlpEncodeWord(TP)
//                                                      +String #rlpEncodeWord(TG)
//                                                      +String #rlpEncodeAccount(TT)
//                                                      +String #rlpEncodeWord(TV)
//                                                      +String #rlpEncodeString(#unparseByteStack(TD))
//                                                      +String #rlpEncodeWord(CID)
//                                                      +String #rlpEncodeString("")
//                                                      +String #rlpEncodeString("")
//                                                    , 192
//                                                    )
//                                  )
```

The EVM test-sets are represented in JSON format with hex-encoding of the data and programs.
Here we provide some standard parser/unparser functions for that format.

Parsing
-------

These parsers can interperet hex-encoded strings as `Int`s, `ByteArray`s, and `Map`s.

-   `#parseHexWord` interprets a string as a single hex-encoded `Word`.
-   `#parseHexBytes` interprets a string as a hex-encoded stack of bytes.
-   `#alignHexString` makes sure that the length of a (hex)string is even.
-   `#parseByteStack` interprets a string as a hex-encoded stack of bytes, but makes sure to remove the leading "0x".
-   `#parseByteStackRaw` casts a string as a stack of bytes, ignoring any encoding.
-   `#parseWordStack` interprets a JSON list as a stack of `Word`.
-   `#parseMap` interprets a JSON key/value object as a map from `Word` to `Word`.
-   `#parseAddr` interprets a string as a 160 bit hex-endcoded address.

```k
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
```

```{.k .bytes}
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
```

```{.k .nobytes}
    syntax ByteArray ::= #parseHexBytes     ( String ) [function]
                       | #parseHexBytesAux  ( String ) [function]
                       | #parseByteStack    ( String ) [function]
                       | #parseByteStackRaw ( String ) [function]
 // -------------------------------------------------------------
    rule #parseByteStack(S) => #parseHexBytes(replaceAll(S, "0x", ""))

    rule #parseHexBytes(S)  => #parseHexBytesAux(#alignHexString(S))
    rule #parseHexBytesAux("") => .WordStack
    rule #parseHexBytesAux(S)  => #parseHexWord(substrString(S, 0, 2)) : #parseHexBytesAux(substrString(S, 2, lengthString(S)))
       requires lengthString(S) >=Int 2

    rule #parseByteStackRaw(S) => ordChar(substrString(S, 0, 1)) : #parseByteStackRaw(substrString(S, 1, lengthString(S))) requires lengthString(S) >=Int 1
    rule #parseByteStackRaw("") => .WordStack
```

```k
    //syntax Map ::= #parseMap ( JSON ) [function]
 // --------------------------------------------
    //rule #parseMap( { .JSONs                      } ) => .Map
    //rule #parseMap( { _   : (VALUE:String) , REST } ) => #parseMap({ REST })                                                requires #parseHexWord(VALUE) ==K 0
    //rule #parseMap( { KEY : (VALUE:String) , REST } ) => #parseMap({ REST }) [ #parseHexWord(KEY) <- #parseHexWord(VALUE) ] requires #parseHexWord(VALUE) =/=K 0

    syntax Int ::= #parseAddr ( String ) [function]
 // -----------------------------------------------
    rule #parseAddr(S) => #addr(#parseHexWord(S))
```

Unparsing
---------

We need to interperet a `ByteArray` as a `String` again so that we can call `Keccak256` on it from `KRYPTO`.

-   `#unparseByteStack` turns a stack of bytes (as a `ByteArray`) into a `String`.
-   `#padByte` ensures that the `String` interperetation of a `Int` is wide enough.

```{.k .bytes}
    syntax String ::= #unparseByteStack ( ByteArray ) [function, klabel(unparseByteStack), symbol]
 // ----------------------------------------------------------------------------------------------
    rule #unparseByteStack(WS) => Bytes2String(WS)
```

```{.k .nobytes}
    syntax String ::= #unparseByteStack ( ByteArray )                [function, klabel(unparseByteStack), symbol]
                    | #unparseByteStack ( ByteArray , StringBuffer ) [function, klabel(#unparseByteStackAux)]
 // ---------------------------------------------------------------------------------------------------------
    rule #unparseByteStack ( WS ) => #unparseByteStack(WS, .StringBuffer)

    rule #unparseByteStack( .WordStack, BUFFER ) => StringBuffer2String(BUFFER)
    rule #unparseByteStack( W : WS, BUFFER )     => #unparseByteStack(WS, BUFFER +String chrChar(W modInt (2 ^Int 8)))
```

```k
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
```

String Helper Functions
-----------------------

- `Hex2Raw` Takes a string of hex encoded bytes and converts it to a raw bytestring
- `Raw2Hex` Takes a string of raw bytes and converts it to a hex representation

```k
    syntax String ::= Hex2Raw ( String ) [function]
                    | Raw2Hex ( String ) [function]
 // -----------------------------------------------
    rule Hex2Raw ( S ) => #unparseByteStack( #parseByteStack ( S ) )
    rule Raw2Hex ( S ) => #unparseDataByteArray( #parseByteStackRaw ( S ) )
```

Recursive Length Prefix (RLP)
=============================

RLP encoding is used extensively for executing the blocks of a transaction.
For details about RLP encoding, see the [YellowPaper Appendix B](http://gavwood.com/paper.pdf).

Encoding
--------

-   `#rlpEncodeWord` RLP encodes a single EVM word.
-   `#rlpEncodeString` RLP encodes a single `String`.

```k
//     syntax String ::= #rlpEncodeWord ( Int )            [function]
//                     | #rlpEncodeBytes ( Int , Int )     [function]
//                     | #rlpEncodeWordStack ( WordStack ) [function]
//                     | #rlpEncodeString ( String )       [function]
//                     | #rlpEncodeAccount ( Account )     [function]
//  // --------------------------------------------------------------
//     rule #rlpEncodeWord(0) => "\x80"
//     rule #rlpEncodeWord(WORD) => chrChar(WORD) requires WORD >Int 0 andBool WORD <Int 128
//     rule #rlpEncodeWord(WORD) => #rlpEncodeLength(#unparseByteStack(#asByteStack(WORD)), 128) requires WORD >=Int 128

//     rule #rlpEncodeBytes(WORD, LEN) => #rlpEncodeString(#unparseByteStack(#padToWidth(LEN, #asByteStack(WORD))))

//     rule #rlpEncodeWordStack(.WordStack) => ""
//     rule #rlpEncodeWordStack(W : WS)     => #rlpEncodeWord(W) +String #rlpEncodeWordStack(WS)

//     rule #rlpEncodeString(STR) => "\x80"                     requires lengthString(STR)  <Int 1
//     rule #rlpEncodeString(STR) => STR                        requires lengthString(STR) ==Int 1 andBool ordChar(substrString(STR, 0, 1)) <Int 128
//     rule #rlpEncodeString(STR) => #rlpEncodeLength(STR, 128) [owise]

//     rule #rlpEncodeAccount(.Account) => "\x80"
//     rule #rlpEncodeAccount(ACCT)     => #rlpEncodeBytes(ACCT, 20) requires ACCT =/=K .Account

//     syntax String ::= #rlpEncodeLength ( String , Int )          [function]
//                     | #rlpEncodeLength ( String , Int , String ) [function, klabel(#rlpEncodeLengthAux)]
//  // ----------------------------------------------------------------------------------------------------
//     rule #rlpEncodeLength(STR, OFFSET) => chrChar(lengthString(STR) +Int OFFSET) +String STR                                requires           lengthString(STR) <Int 56
//     rule #rlpEncodeLength(STR, OFFSET) => #rlpEncodeLength(STR, OFFSET, #unparseByteStack(#asByteStack(lengthString(STR)))) requires notBool ( lengthString(STR) <Int 56 )
//     rule #rlpEncodeLength(STR, OFFSET, BL) => chrChar(lengthString(BL) +Int OFFSET +Int 55) +String BL +String STR

//     syntax String ::= #rlpEncodeTransaction( Int , Int , Int , Account , Int , ByteArray , Int , ByteArray , ByteArray ) [function]
//  // -------------------------------------------------------------------------------------------------------------------------------
//     rule [rlpTx]: #rlpEncodeTransaction(TN, TP, TG, TT, TV, TD, TW, TR, TS)
//                => #rlpEncodeLength(         #rlpEncodeWord(TN)
//                                     +String #rlpEncodeWord(TP)
//                                     +String #rlpEncodeWord(TG)
//                                     +String #rlpEncodeAccount(TT)
//                                     +String #rlpEncodeWord(TV)
//                                     +String #rlpEncodeString(#unparseByteStack(TD))
//                                     +String #rlpEncodeWord(TW)
//                                     +String #rlpEncodeString(#unparseByteStack(#asByteStack(#asWord(TR))))
//                                     +String #rlpEncodeString(#unparseByteStack(#asByteStack(#asWord(TS))))
//                                   , 192
//                                   )

//     syntax String ::= #rlpEncodeFullAccount( Int, Int, Map, ByteArray ) [function]
//  // ------------------------------------------------------------------------------
//     rule [rlpAcct]: #rlpEncodeFullAccount( NONCE, BAL, STORAGE, CODE )
//                  => #rlpEncodeLength(         #rlpEncodeWord(NONCE)
//                                       +String #rlpEncodeWord(BAL)
//                                       +String #rlpEncodeString( Hex2Raw( Keccak256( #rlpEncodeMerkleTree( #storageRoot( STORAGE ) ) ) ) )
//                                       +String #rlpEncodeString( Hex2Raw( Keccak256( #unparseByteStack( CODE ) ) ) )
//                                     , 192
//                                     )

//     syntax String ::= #rlpEncodeReceipt ( Int , Int , ByteArray , List ) [function]
//                     | #rlpEncodeLogs    ( List )                         [function]
//                     | #rlpEncodeLogsAux ( List, String )                 [function]
//                     | #rlpEncodeTopics  ( List, String )                 [function]
//  // -------------------------------------------------------------------------------
//     rule [rlpReceipt]: #rlpEncodeReceipt(RS, RG, RB, RL)
//                     => #rlpEncodeLength(         #rlpEncodeWord(RS)
//                                          +String #rlpEncodeWord(RG)
//                                          +String #rlpEncodeString(#unparseByteStack(RB))
//                                          +String #rlpEncodeLogs(RL)
//                                        , 192
//                                        )

//     rule #rlpEncodeLogs( LOGS ) => #rlpEncodeLogsAux( LOGS, "" )

//     rule #rlpEncodeLogsAux( .List, OUT ) => #rlpEncodeLength(OUT,192)
//     rule #rlpEncodeLogsAux( ( ListItem({ ACCT | TOPICS | DATA }) => .List ) _
//                           , ( OUT => OUT +String #rlpEncodeLength(         #rlpEncodeBytes(ACCT,20)
//                                                                    +String #rlpEncodeTopics(TOPICS,"")
//                                                                    +String #rlpEncodeString(#unparseByteStack(DATA))
//                                                                  , 192
//                                                                  )
//                             )
//                           )

//     rule #rlpEncodeTopics( .List, OUT ) => #rlpEncodeLength(OUT,192)
//     rule #rlpEncodeTopics( ( ListItem( X:Int ) => .List ) _
//                          , ( OUT => OUT +String #rlpEncodeBytes(X,32) )
//                          )

//     syntax String ::= #rlpEncodeMerkleTree ( MerkleTree ) [function]
//  // ----------------------------------------------------------------
//     rule #rlpEncodeMerkleTree ( .MerkleTree ) => "\x80"

//     rule #rlpEncodeMerkleTree ( MerkleLeaf ( PATH, VALUE ) )
//       => #rlpEncodeLength(         #rlpEncodeString( #unparseByteStack( #HPEncode( PATH, 1 ) ) )
//                            +String #rlpEncodeString( VALUE )
//                          , 192
//                          )

//     rule #rlpEncodeMerkleTree ( MerkleExtension ( PATH, TREE ) )
//       => #rlpEncodeLength(         #rlpEncodeString( #unparseByteStack( #HPEncode( PATH, 0 ) ) )
//                            +String #rlpMerkleH( #rlpEncodeMerkleTree( TREE ) )
//                          , 192
//                          )

//     rule #rlpEncodeMerkleTree ( MerkleBranch ( M , VALUE ) )
//       => #rlpEncodeLength(         MerkleMapRLP(M, 0) +String MerkleMapRLP(M, 1)
//                            +String MerkleMapRLP(M, 2) +String MerkleMapRLP(M, 3)
//                            +String MerkleMapRLP(M, 4) +String MerkleMapRLP(M, 5)
//                            +String MerkleMapRLP(M, 6) +String MerkleMapRLP(M, 7)
//                            +String MerkleMapRLP(M, 8) +String MerkleMapRLP(M, 9)
//                            +String MerkleMapRLP(M,10) +String MerkleMapRLP(M,11)
//                            +String MerkleMapRLP(M,12) +String MerkleMapRLP(M,13)
//                            +String MerkleMapRLP(M,14) +String MerkleMapRLP(M,15)
//                            +String #rlpEncodeString( VALUE )
//                          , 192
//                          )

//     syntax String ::= MerkleMapRLP( Map, Int ) [function]
//  // -----------------------------------------------------
//     rule MerkleMapRLP(M, I) => #rlpMerkleH( #rlpEncodeMerkleTree( { M[I] orDefault .MerkleTree }:>MerkleTree ) )

//     syntax String ::= #rlpMerkleH ( String ) [function,klabel(MerkleRLPAux)]
//  // ------------------------------------------------------------------------
//     rule #rlpMerkleH ( X ) => #rlpEncodeString( Hex2Raw( Keccak256( X ) ) )
//       requires lengthString(X) >=Int 32

//     rule #rlpMerkleH ( X ) => X
//       requires notBool lengthString(X) >=Int 32
```

Decoding
--------

-   `#rlpDecode` RLP decodes a single `String` into a `JSON`.
-   `#rlpDecodeList` RLP decodes a single `String` into a `JSONs`, interpereting the string as the RLP encoding of a list.

```k
    // syntax JSON ::= #rlpDecode(String)               [function]
//                   | #rlpDecode(String, LengthPrefix) [function, klabel(#rlpDecodeAux)]
//  // ----------------------------------------------------------------------------------
//     rule #rlpDecode(STR) => #rlpDecode(STR, #decodeLengthPrefix(STR, 0))
//     rule #rlpDecode(STR,  #str( LEN, POS)) => substrString(STR, POS, POS +Int LEN)
//     rule #rlpDecode(STR, #list(_LEN, POS)) => [#rlpDecodeList(STR, POS)]

//     syntax JSONs ::= #rlpDecodeList(String, Int)               [function]
//                    | #rlpDecodeList(String, Int, LengthPrefix) [function, klabel(#rlpDecodeListAux)]
//  // ------------------------------------------------------------------------------------------------
//     rule #rlpDecodeList(STR, POS) => #rlpDecodeList(STR, POS, #decodeLengthPrefix(STR, POS)) requires POS <Int lengthString(STR)
//     rule #rlpDecodeList(  _,   _) => .JSONs [owise]
//     rule #rlpDecodeList(STR, POS, _:LengthPrefixType(L, P)) => #rlpDecode(substrString(STR, POS, L +Int P)) , #rlpDecodeList(STR, L +Int P)

//     syntax LengthPrefixType ::= "#str" | "#list"
//     syntax LengthPrefix ::= LengthPrefixType "(" Int "," Int ")"
//                           | #decodeLengthPrefix ( String , Int )                                [function]
//                           | #decodeLengthPrefix ( String , Int , Int )                          [function, klabel(#decodeLengthPrefixAux)]
//                           | #decodeLengthPrefixLength ( LengthPrefixType , String , Int , Int ) [function]
//                           | #decodeLengthPrefixLength ( LengthPrefixType , Int    , Int , Int ) [function, klabel(#decodeLengthPrefixLengthAux)]
//  // --------------------------------------------------------------------------------------------------------------------------------------------
//     rule #decodeLengthPrefix(STR, START) => #decodeLengthPrefix(STR, START, ordChar(substrString(STR, START, START +Int 1)))

//     rule #decodeLengthPrefix(  _, START, B0) => #str(1, START)                                   requires B0 <Int 128
//     rule #decodeLengthPrefix(  _, START, B0) => #str(B0 -Int 128, START +Int 1)                  requires B0 >=Int 128 andBool B0 <Int (128 +Int 56)
//     rule #decodeLengthPrefix(STR, START, B0) => #decodeLengthPrefixLength(#str, STR, START, B0)  requires B0 >=Int (128 +Int 56) andBool B0 <Int 192
//     rule #decodeLengthPrefix(  _, START, B0) => #list(B0 -Int 192, START +Int 1)                 requires B0 >=Int 192 andBool B0 <Int 192 +Int 56
//     rule #decodeLengthPrefix(STR, START, B0) => #decodeLengthPrefixLength(#list, STR, START, B0) [owise]

//     rule #decodeLengthPrefixLength(#str,  STR, START, B0) => #decodeLengthPrefixLength(#str,  START, B0 -Int 128 -Int 56 +Int 1, #asWord(#parseByteStackRaw(substrString(STR, START +Int 1, START +Int 1 +Int (B0 -Int 128 -Int 56 +Int 1)))))
//     rule #decodeLengthPrefixLength(#list, STR, START, B0) => #decodeLengthPrefixLength(#list, START, B0 -Int 192 -Int 56 +Int 1, #asWord(#parseByteStackRaw(substrString(STR, START +Int 1, START +Int 1 +Int (B0 -Int 192 -Int 56 +Int 1)))))
//     rule #decodeLengthPrefixLength(TYPE, START, LL, L) => TYPE(L, START +Int 1 +Int LL)
```

Merkle Patricia Tree
====================

- Appendix C and D from the Ethereum Yellow Paper
- https://github.com/ethereum/wiki/wiki/Patricia-Tree

```k
    //syntax KItem ::= Int | MerkleTree // For testing purposes

    //syntax MerkleTree ::= ".MerkleTree"
    //                    | MerkleBranch    ( Map, String )
    //                    | MerkleExtension ( ByteArray, MerkleTree )
    //                    | MerkleLeaf      ( ByteArray, String )
 // -----------------------------------------------------------

    //syntax MerkleTree ::= MerkleUpdate ( MerkleTree,     String, String ) [function]
    //                    | MerkleUpdate ( MerkleTree,  ByteArray, String ) [function,klabel(MerkleUpdateAux)]
    //                    | MerklePut    ( MerkleTree,  ByteArray, String ) [function]
    //                    | MerkleDelete ( MerkleTree,  ByteArray )         [function]
 // --------------------------------------------------------------------------------
    //rule MerkleUpdate ( TREE, S:String, VALUE ) => MerkleUpdate ( TREE, #nibbleize ( #parseByteStackRaw( S ) ), VALUE )

    //rule MerkleUpdate ( TREE, PATH:ByteArray, VALUE ) => MerklePut ( TREE, PATH, VALUE ) requires VALUE =/=String ""
    //rule MerkleUpdate ( TREE, PATH:ByteArray, ""    ) => MerkleDelete ( TREE, PATH )

    //rule MerklePut ( .MerkleTree, PATH:ByteArray, VALUE ) => MerkleLeaf ( PATH, VALUE )

    //rule MerklePut ( MerkleLeaf ( LEAFPATH, _ ), PATH, VALUE )
    //  => MerkleLeaf( LEAFPATH, VALUE )
    //  requires LEAFPATH ==K PATH

    //rule MerklePut ( MerkleLeaf ( LEAFPATH, LEAFVALUE ), PATH, VALUE )
    //  => MerklePut ( MerklePut ( MerkleBranch( .Map, "" ), LEAFPATH, LEAFVALUE ), PATH, VALUE )
    //  requires #sizeByteArray( LEAFPATH ) >Int 0
    //   andBool #sizeByteArray( PATH ) >Int 0
    //   andBool LEAFPATH[0] =/=Int PATH[0]

    //rule MerklePut ( MerkleLeaf ( LEAFPATH, LEAFVALUE ), PATH, VALUE )
    //  => #merkleExtensionBuilder( .ByteArray, LEAFPATH, LEAFVALUE, PATH, VALUE )
    //  requires #unparseByteStack( LEAFPATH ) =/=String #unparseByteStack( PATH )
    //   andBool #sizeByteArray( LEAFPATH ) >Int 0
    //   andBool #sizeByteArray( PATH )     >Int 0
    //   andBool LEAFPATH[0] ==Int PATH[0]

    //rule MerklePut ( MerkleExtension ( EXTPATH, EXTTREE ), PATH, VALUE )
    //  => MerkleExtension ( EXTPATH, MerklePut ( EXTTREE, .ByteArray, VALUE ) )
    //  requires EXTPATH ==K PATH

    //rule MerklePut ( MerkleExtension ( EXTPATH, EXTTREE ), PATH, VALUE )
    //  => #merkleExtensionBrancher( MerklePut( MerkleBranch( .Map, "" ), PATH, VALUE ), EXTPATH, EXTTREE )
    //  requires #sizeByteArray( PATH ) >Int 0
    //   andBool EXTPATH[0] =/=Int PATH[0]

    //rule MerklePut ( MerkleExtension ( EXTPATH, EXTTREE ), PATH, VALUE )
    //  => #merkleExtensionSplitter( .ByteArray, EXTPATH, EXTTREE, PATH, VALUE )
    //  requires #unparseByteStack( EXTPATH ) =/=String #unparseByteStack( PATH )
    //   andBool #sizeByteArray( PATH ) >Int 0
    //   andBool EXTPATH[0] ==Int PATH[0]

    //rule MerklePut ( MerkleBranch( M, _ ), PATH, VALUE )
    //  => MerkleBranch( M, VALUE )
    //  requires #sizeByteArray( PATH ) ==Int 0

    //rule MerklePut ( MerkleBranch( M, BRANCHVALUE ), PATH, VALUE )
    //  => #merkleUpdateBranch ( M, BRANCHVALUE, PATH[0], PATH[1 .. #sizeByteArray(PATH) -Int 1], VALUE )
    //  requires #sizeByteArray( PATH ) >Int 0

    //rule MerkleDelete( .MerkleTree, _ ) => .MerkleTree

    //rule MerkleDelete( MerkleLeaf( LPATH, _V ), PATH ) => .MerkleTree                           requires LPATH ==K  PATH
    //rule MerkleDelete( MerkleLeaf( LPATH,  V ), PATH ) => MerkleCheck( MerkleLeaf( LPATH, V ) ) requires LPATH =/=K PATH

    //rule MerkleDelete( MerkleExtension( EXTPATH, TREE ), PATH ) => MerkleExtension( EXTPATH, TREE ) requires notBool (#sizeByteArray(EXTPATH) <=Int #sizeByteArray(PATH) andBool PATH[0 .. #sizeByteArray(EXTPATH)] ==K EXTPATH)
    //rule MerkleDelete( MerkleExtension( EXTPATH, TREE ), PATH )
    //  => MerkleCheck( MerkleExtension( EXTPATH, MerkleDelete( TREE, PATH[#sizeByteArray(EXTPATH) .. #sizeByteArray(PATH) -Int #sizeByteArray(EXTPATH)] ) ) )
    //  requires #sizeByteArray(EXTPATH) <=Int #sizeByteArray(PATH) andBool PATH[0 .. #sizeByteArray(EXTPATH)] ==K EXTPATH

    //rule MerkleDelete( MerkleBranch( M, _V ), PATH ) => MerkleCheck( MerkleBranch( M, "" ) ) requires #sizeByteArray(PATH) ==Int 0
    //rule MerkleDelete( MerkleBranch( M,  V ), PATH ) => MerkleBranch( M, V )                 requires #sizeByteArray(PATH) >Int 0 andBool notBool PATH[0] in_keys(M)
    //rule MerkleDelete( MerkleBranch( M,  V ), PATH )
    //  => MerkleCheck( MerkleBranch( M[PATH[0] <- MerkleDelete( {M[PATH[0]]}:>MerkleTree, PATH[1 .. #sizeByteArray(PATH) -Int 1] )], V ) )
    //  requires #sizeByteArray(PATH) >Int 0 andBool PATH[0] in_keys(M)

    //syntax MerkleTree ::= MerkleCheck( MerkleTree ) [function]
 // ----------------------------------------------------------
    //rule MerkleCheck( TREE ) => TREE [owise]

    //rule MerkleCheck( MerkleLeaf( _, "" ) => .MerkleTree )

    //rule MerkleCheck( MerkleBranch( .Map                   , V  ) => MerkleLeaf( .ByteArray, V )                   )
    //rule MerkleCheck( MerkleBranch( X |-> T                , "" ) => MerkleExtension( #asByteStack(X)[0 .. 1], T ) ) requires T =/=K .MerkleTree
    //rule MerkleCheck( MerkleBranch( M => #cleanBranchMap(M), _  )                                                  ) requires .MerkleTree in values(M)

    //rule MerkleCheck( MerkleExtension( _, .MerkleTree                                      ) => .MerkleTree               )
    //rule MerkleCheck( MerkleExtension( P1, MerkleLeaf( P2, V )                             ) => MerkleLeaf( P1 ++ P2, V ) )
    //rule MerkleCheck( MerkleExtension( P1 => P1 ++ P2, MerkleExtension( P2, TREE ) => TREE )                              )
```

- `MerkleUpdateMap` Takes a mapping of `ByteArray |-> String` and generates a trie

```k
    //syntax MerkleTree ::= MerkleUpdateMap    ( MerkleTree , Map        ) [function]
    //                    | MerkleUpdateMapAux ( MerkleTree , Map , List ) [function]
 // -------------------------------------------------------------------------------
    //rule MerkleUpdateMap(TREE, MMAP) => MerkleUpdateMapAux(TREE, MMAP, keys_list(MMAP))

    //rule MerkleUpdateMapAux(TREE, _, .List ) => TREE
    //rule MerkleUpdateMapAux(TREE                                                    , MMAP, ListItem(KEY) REST)
    //  => MerkleUpdateMapAux(MerkleUpdate(TREE, #nibbleize(KEY), {MMAP[KEY]}:>String), MMAP,               REST)
```

Merkle Tree Aux Functions
-------------------------

```k
    //syntax ByteArray ::= #nibbleize ( ByteArray ) [function]
    //                   | #byteify   ( ByteArray ) [function]
 // --------------------------------------------------------
    //rule #nibbleize ( B ) => (      #asByteStack ( B [ 0 ] /Int 16 )[0 .. 1]
    //                           ++ ( #asByteStack ( B [ 0 ] %Int 16 )[0 .. 1] )
    //                         ) ++ #nibbleize ( B[1 .. #sizeByteArray(B) -Int 1] )
    //  requires #sizeByteArray(B) >Int 0

    //rule #nibbleize ( B ) => .ByteArray
    //  requires notBool #sizeByteArray(B) >Int 0

    //rule #byteify ( B ) =>    #asByteStack ( B[0] *Int 16 +Int B[1] )[0 .. 1]
    //                       ++ #byteify ( B[2 .. #sizeByteArray(B) -Int 2] )
    //  requires #sizeByteArray(B) >Int 0

    //rule #byteify ( B ) => .ByteArray
    //  requires notBool #sizeByteArray(B) >Int 0

    //syntax ByteArray ::= #HPEncode ( ByteArray, Int ) [function]
 // ------------------------------------------------------------
    //rule #HPEncode ( X, T ) => #asByteStack ( ( HPEncodeAux(T) +Int 1 ) *Int 16 +Int X[0] ) ++ #byteify( X[1 .. #sizeByteArray(X) -Int 1] )
    //  requires #sizeByteArray(X) %Int 2 =/=Int 0

    //rule #HPEncode ( X, T ) => #asByteStack ( HPEncodeAux(T) *Int 16 )[0 .. 1] ++ #byteify( X )
    //  requires notBool #sizeByteArray(X) %Int 2 =/=Int 0

    //syntax Int ::= HPEncodeAux ( Int ) [function]
 // ---------------------------------------------
    //rule HPEncodeAux ( X ) => 0 requires         X ==Int 0
    //rule HPEncodeAux ( X ) => 2 requires notBool X ==Int 0

    //syntax Map ::= #cleanBranchMap    ( Map )            [function]
    //             | #cleanBranchMapAux ( Map, List, Set ) [function]
 // ---------------------------------------------------------------
    //rule #cleanBranchMap( M ) => #cleanBranchMapAux( M, keys_list(M), .Set )

    //rule #cleanBranchMapAux(                   M,                        .List,                      S ) => removeAll( M, S )
    //rule #cleanBranchMapAux( X |-> .MerkleTree _, (ListItem(X) => .List) _    , (.Set => SetItem(X)) _ )
    //rule #cleanBranchMapAux(                   _, (ListItem(_) => .List) _    ,                      _ ) [owise]

    //syntax MerkleTree ::= #merkleUpdateBranch ( Map, String, Int, ByteArray, String ) [function]
 // --------------------------------------------------------------------------------------------
    //rule #merkleUpdateBranch ( X |-> TREE M, BRANCHVALUE, X, PATH, VALUE )
    //  => MerkleBranch( M[X <- MerklePut( TREE, PATH, VALUE )], BRANCHVALUE )

//     rule #merkleUpdateBranch ( M, BRANCHVALUE, X, PATH, VALUE )
//       => MerkleBranch( M[X <- MerkleLeaf( PATH, VALUE )], BRANCHVALUE ) [owise]

//     syntax MerkleTree ::= #merkleExtensionBuilder(    ByteArray , ByteArray , String , ByteArray , String ) [function]
//                         | #merkleExtensionBuilderAux( ByteArray , ByteArray , String , ByteArray , String ) [function]
//  // ------------------------------------------------------------------------------------------------------------------------
//     rule #merkleExtensionBuilder(PATH, P1, V1, P2, V2)
//       => #merkleExtensionBuilderAux(PATH, P1, V1, P2, V2)
//       requires #sizeByteArray(P1) >Int 0
//        andBool #sizeByteArray(P2) >Int 0

//     rule #merkleExtensionBuilder(PATH, P1, V1, P2, V2)
//       => MerkleExtension( PATH, MerklePut( MerklePut( MerkleBranch( .Map, "" ), P1, V1 ), P2, V2 ) )
//       [owise]

//     rule #merkleExtensionBuilderAux( PATH, P1, V1, P2, V2 )
//       => #merkleExtensionBuilder( PATH ++ (P1[0 .. 1])
//                                 , P1[1 .. #sizeByteArray(P1) -Int 1], V1
//                                 , P2[1 .. #sizeByteArray(P2) -Int 1], V2
//                                 )
//       requires P1[0] ==Int P2[0]

//     rule #merkleExtensionBuilderAux( PATH, P1, V1, P2, V2 )
//       => MerkleExtension( PATH, MerklePut( MerklePut( MerkleBranch( .Map, "" ), P1, V1 ), P2, V2 ) )
//       [owise]

//     syntax MerkleTree ::= #merkleExtensionBrancher ( MerkleTree, ByteArray, MerkleTree ) [function]
//  // -----------------------------------------------------------------------------------------------
//     rule #merkleExtensionBrancher( MerkleBranch(M, VALUE), PATH, EXTTREE )
//       => MerkleBranch( M[PATH[0] <- MerkleExtension( PATH[1 .. #sizeByteArray(PATH) -Int 1], EXTTREE )], VALUE )
//       requires #sizeByteArray(PATH) >Int 1

//     rule #merkleExtensionBrancher( MerkleBranch(M, VALUE), PATH, EXTTREE )
//       => MerkleBranch( M[PATH[0] <- EXTTREE], VALUE )
//       requires #sizeByteArray(PATH) ==Int 1

//     syntax MerkleTree ::= #merkleExtensionSplitter ( ByteArray, ByteArray, MerkleTree, ByteArray, String ) [function]
//  // -----------------------------------------------------------------------------------------------------------------
//     rule #merkleExtensionSplitter( PATH => PATH ++ (P1[0 .. 1])
//                                  , P1   => P1[1 .. #sizeByteArray(P1) -Int 1], _
//                                  , P2   => P2[1 .. #sizeByteArray(P2) -Int 1], _
//                                  )
//       requires #sizeByteArray(P1) >Int 0
//        andBool #sizeByteArray(P2) >Int 0
//        andBool P1[0] ==Int P2[0]

//     rule #merkleExtensionSplitter( PATH, P1, TREE, P2, VALUE )
//       => MerkleExtension( PATH, #merkleExtensionBrancher( MerklePut( MerkleBranch( .Map, "" ), P2, VALUE ), P1, TREE ) )
//       requires #sizeByteArray(P1) >Int 0
//        andBool #sizeByteArray(P2) >Int 0
//        andBool P1[0] =/=Int P2[0]

//     rule #merkleExtensionSplitter( PATH, P1, TREE, P2, VALUE )
//       => MerkleExtension( PATH, MerklePut( TREE, P2, VALUE ) )
//       requires #sizeByteArray(P1) ==Int 0

//     rule #merkleExtensionSplitter( PATH, P1, TREE, P2, VALUE )
//       => MerkleExtension( PATH, #merkleExtensionBrancher( MerklePut( MerkleBranch( .Map, "" ), P2, VALUE ), P1, TREE ) )
//       requires #sizeByteArray(P2) ==Int 0
```

Tree Root Helper Functions
--------------------------

### Storage Root

```k
    // syntax Map ::= #intMap2StorageMap( Map )               [function]
//                  | #intMap2StorageMapAux( Map, Map, List ) [function]
//  // -----------------------------------------------------------------
//     rule #intMap2StorageMap( M ) => #intMap2StorageMapAux( .Map, M, keys_list(M) )

//     rule #intMap2StorageMapAux( SMAP, _, .List ) => SMAP
//     rule #intMap2StorageMapAux( SMAP, IMAP, ListItem(K) REST )
//       => #intMap2StorageMapAux( #padToWidth( 32, #asByteStack(K) ) |-> #rlpEncodeWord({IMAP[K]}:>Int) SMAP, IMAP, REST )
//       requires {IMAP[K]}:>Int =/=Int 0

//     rule #intMap2StorageMapAux( SMAP, IMAP, ListItem(K) REST )
//       => #intMap2StorageMapAux( SMAP, IMAP, REST )
//       requires {IMAP[K]}:>Int ==Int 0


//     syntax MerkleTree ::= #storageRoot( Map ) [function]
//  // ----------------------------------------------------
//     rule #storageRoot( STORAGE ) => MerkleUpdateMap( .MerkleTree, #intMap2StorageMap( STORAGE ) )
```

### State Root

```k
//     syntax Map ::= #precompiledAccountsMap   ( Set )       [function]
//                  | #precompiledAccountsMapAux( List, Map ) [function]
//  // -----------------------------------------------------------------
//     rule #precompiledAccountsMap( ACCTS ) => #precompiledAccountsMapAux( Set2List( ACCTS ), .Map )

//     rule #precompiledAccountsMapAux( .List, M ) => M
//     rule #precompiledAccountsMapAux( (ListItem( ACCT ) => .List) _, M => M[#parseByteStackRaw( Hex2Raw( #unparseData( ACCT, 20 ) ) ) <- #emptyContractRLP] )

//     syntax String ::= "#emptyContractRLP" [function]
//  // ------------------------------------------------
//     rule #emptyContractRLP => #rlpEncodeLength(         #rlpEncodeWord(0)
//                                                 +String #rlpEncodeWord(0)
//                                                 +String #rlpEncodeString( Hex2Raw( Keccak256("\x80") ) )
//                                                 +String #rlpEncodeString( Hex2Raw( Keccak256("") ) )
//                                               , 192
//                                               )

endmodule
```

FILE: buf.md

Byte-Buffer Abstraction
=======================

```k
//requires "evm.md"

module BUF-SYNTAX
    imports EVM
```

Both `#bufStrict(SIZE, DATA)` and `#buf(SIZE, DATA)` represents a symbolic byte array of length `SIZE` bytes, left-padded with zeroes.
Version `#bufStrict` is partial and only defined when `DATA` is in the range given by `SIZE`.
It rewrites to `#buf` when data is in range, and is expected to immediately evaluate into `#buf` in all contexts.
Version `#buf` is total and artificially defined `modulo 2 ^Int (SIZE *Int 8)`.
This division is required to facilitate symbolic reasoning in Haskell backend, because Haskell has limitations
when dealing with partial functions.

**Usage:** All symbolic byte arrays must be originally created as `#bufStrict`.
This ensures `#buf` is never present in out of range mode.
For this, definition rule RHS should always use `#bufStrict` when array is first created, but may use `#buf` when array
is just carried on from LHS without changes. Definition rule LHS should only use `#buf`.
Claims should always use `#bufStrict` in LHS and `#buf` in RHS.

```k
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
```

FILE: hashed-locations.md

Hashed Storage Locations
========================

```k
//requires "evm.md"
//requires "buf.md"

module HASHED-LOCATIONS
    imports EVM
    imports BUF
```

### Hashed Location for Storage

The storage accommodates permanent data such as the `balances` map.
A map is laid out in the storage where the map entries are scattered over the entire storage space using the (256-bit) hash of each key to determine the location.
The detailed mechanism of calculating the location varies by compilers.
In Vyper, for example, `map[key1][key2]` is stored at the location:

```
  hash(hash(key1 ++ slot(map)) ++ key2)
```

where `slot(map)` is the position index of `map` in the program, and `++` is byte-array concatenation, while in Solidity, it is stored at:

```
  hash(key2 ++ hash(key1 ++ slot(map)))
```

The eDSL provides `#hashedLocation` that allows to uniformly specify the locations in a form parameterized by the underlying compilers.
For maps, the location of `map[key1][key2]` can be specified as follows, where `{COMPILER}` is a place-holder to be replaced by the name of the compiler.
Note that the keys are separated by the white spaces instead of commas.

```
  #hashedLocation({COMPILER}, slot(map), key1 key2)
```

This notation makes the specification independent of the underlying compilers, enabling it to be reused for differently compiled programs.

For dynamically sized arrays in Solidity, and both statically and dynamically sized arrays in Vyper, the length of the array is stored at:

```
  hash(slot(array))
```

and the element at index `i` is stored at:

```
  hash(slot(array)) + i
```

More information about how storage locations are defined in Solidity can be found [here](https://solidity.readthedocs.io/en/v0.5.11/miscellaneous.html#layout-of-state-variables-in-storage).

Specifically, `#hashedLocation` is defined as follows, capturing the storage layout schemes of Solidity and Vyper.

```k
    syntax Int ::= #hashedLocation( String , Int , IntList ) [function, klabel(hashLoc), smtlib(hashLoc)]
 // -----------------------------------------------------------------------------------------------------
    rule #hashedLocation(_LANG, BASE, .IntList      ) => BASE
    rule #hashedLocation( LANG, BASE, OFFSET OFFSETS) => #hashedLocation(LANG, #hashedLocation(LANG, BASE, OFFSET .IntList), OFFSETS) requires OFFSETS =/=K .IntList

    rule #hashedLocation("Vyper",    BASE, OFFSET .IntList) => keccak(#bufStrict(32, BASE)   ++ #bufStrict(32, OFFSET)) requires #rangeUInt(256, BASE) andBool #rangeUInt(256, OFFSET)
    rule #hashedLocation("Solidity", BASE, OFFSET .IntList) => keccak(#bufStrict(32, OFFSET) ++ #bufStrict(32, BASE))   requires #rangeUInt(256, BASE) andBool #rangeUInt(256, OFFSET)
    rule #hashedLocation("Array",    BASE, OFFSET .IntList) => keccak(#bufStrict(32, BASE)) +Word OFFSET                requires #rangeUInt(256, BASE) andBool #rangeUInt(256, OFFSET)

    syntax IntList ::= List{Int, ""} [klabel(intList), smtlib(intList)]
 // -------------------------------------------------------------------
```

```k
endmodule
```

FILE: json-rpc.md

JSON RPC
========

```k
//requires "json.md"
```

JSON Extensions
---------------

Some common functions and extensions of JSON are provided here.

```k
// module JSON-EXT
//     imports JSON
//     imports STRING
```

-   `+JSONs` appends two JSON lists.
-   `reverseJSONs` reverses a JSON list.

```k
//     syntax JSONs ::= JSONs "+JSONs" JSONs [function]
//  // ------------------------------------------------
//     rule .JSONs   +JSONs JS' => JS'
//     rule (J , JS) +JSONs JS' => J , (JS +JSONs JS')

//     syntax JSONs ::= reverseJSONs    ( JSONs         ) [function]
//                    | reverseJSONsAux ( JSONs , JSONs ) [function]
//  // -------------------------------------------------------------
//     rule reverseJSONs(JS) => reverseJSONsAux(JS, .JSONs)

//     rule reverseJSONsAux(.JSONs, JS') => JS'
//     rule reverseJSONsAux((J, JS:JSONs), JS') => reverseJSONsAux(JS, (J, JS'))
```

-   `qsortJSONs` quick-sorts a list of key-value pairs.
-   `sortedJSONs` is a predicate saying whether a given list of JSONs is sorted or not.

```k
//     syntax JSONs ::= qsortJSONs ( JSONs )          [function]
//                    | #entriesLT ( String , JSONs ) [function]
//                    | #entriesGE ( String , JSONs ) [function]
//  // ---------------------------------------------------------
//     rule qsortJSONs(.JSONs)            => .JSONs
//     rule qsortJSONs(KEY : VALUE, REST) => qsortJSONs(#entriesLT(KEY, REST)) +JSONs (KEY : VALUE , qsortJSONs(#entriesGE(KEY, REST)))

//     rule #entriesLT(_KEY, .JSONs)              => .JSONs
//     rule #entriesLT( KEY, (KEY': VALUE, REST)) => KEY': VALUE , #entriesLT(KEY, REST) requires         KEY' <String KEY
//     rule #entriesLT( KEY, (KEY':     _, REST)) =>               #entriesLT(KEY, REST) requires notBool KEY' <String KEY

//     rule #entriesGE(_KEY, .JSONs)              => .JSONs
//     rule #entriesGE( KEY, (KEY': VALUE, REST)) => KEY': VALUE , #entriesGE(KEY, REST) requires         KEY' >=String KEY
//     rule #entriesGE( KEY, (KEY':     _, REST)) =>               #entriesGE(KEY, REST) requires notBool KEY' >=String KEY

//     syntax Bool ::= sortedJSONs ( JSONs ) [function]
//  // ------------------------------------------------
//     rule sortedJSONs( .JSONs   ) => true
//     rule sortedJSONs( _KEY : _ ) => true
//     rule sortedJSONs( (KEY : _) , (KEY' : VAL) , REST ) => KEY <=String KEY' andThenBool sortedJSONs((KEY' : VAL) , REST)
```

**TODO**: Adding `Int` to `JSONKey` is a hack to make certain parts of semantics easier.

```k
    //syntax JSONKey ::= Int
 // ----------------------
```

```k
//endmodule
```

JSON-RPC
--------

```k
// module JSON-RPC
//     imports K-IO
//     imports LIST
//     imports JSON-EXT

//     configuration
//       <json-rpc>
//         <web3input> $INPUT:Int </web3input>
//         <web3output> $OUTPUT:Int </web3output>
//         <web3request>
//           <jsonrpc> "":JSON </jsonrpc>
//           <callid> 0:JSON </callid>
//           <method> "":JSON </method>
//           <params> [ .JSONs ] </params>
//           <batch> undef </batch>
//         </web3request>
//         <web3response> .List </web3response>
//       </json-rpc>

//     syntax JSON ::= "undef" [klabel(JSON-RPCundef), symbol]
//  // -------------------------------------------------------

//     syntax Bool ::= isProperJson     ( JSON  ) [function]
//                   | isProperJsonList ( JSONs ) [function]
//  // -----------------------------------------------------
//     rule isProperJson(_) => false [owise]

//     rule isProperJson(null) => true

//     rule isProperJson(_:Int)    => true
//     rule isProperJson(_:Bool)   => true
//     rule isProperJson(_:String) => true

//     rule isProperJson(_:JSONKey : J) => isProperJson(J)

//     rule isProperJson([ JS ]) => isProperJsonList(JS)
//     rule isProperJson({ JS }) => isProperJsonList(JS)

//     rule isProperJsonList(.JSONs) => true
//     rule isProperJsonList(J, JS)  => isProperJson(J) andBool isProperJsonList(JS)

//     syntax JSONs ::= flattenJSONs ( JSONs ) [function]
//  // --------------------------------------------------
//     rule flattenJSONs(.JSONs      ) => .JSONs
//     rule flattenJSONs([.JSONs], JL) => flattenJSONs(JL)
//     rule flattenJSONs([J,JS]  , JL) => J, flattenJSONs([JS], JL)
// endmodule
```