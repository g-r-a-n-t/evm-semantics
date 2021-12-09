requires "verification.k"

module DEAD-CODE-BASIC-BLOCKS
    imports VERIFICATION
    
    rule [BASIC-BLOCK-0-TO-1]: <kevm>
           <k>
             ( . => #pc[ JUMPI ] )
             ~> #execute
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   ( .WordStack => CALLVALUE_CELL : .WordStack )
                 </wordStack>
                 <localMem>
                   ( LOCALMEM_CELL => LOCALMEM_CELL [ 64 := (String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )):ByteArray ] )
                 </localMem>
                 <pc>
                   ( 0 => 11 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL -Int Cmem( ISTANBUL , #memoryUsageUpdate( MEMORYUSED_CELL , 64 , 32 ) ) +Int Cmem( ISTANBUL , MEMORYUSED_CELL ) +Int -30 )
                 </gas>
                 <memoryUsed>
                   ( MEMORYUSED_CELL => #memoryUsageUpdate( MEMORYUSED_CELL , 64 , 32 ) )
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( #rangeAddress( ACCT_ID )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( CALLVALUE_CELL =/=K 0
       andBool ( 0 <=Int GAS_CELL -Int Cmem( ISTANBUL , #memoryUsageUpdate( MEMORYUSED_CELL , 64 , 32 ) ) +Int Cmem( ISTANBUL , MEMORYUSED_CELL ) +Int -30
       andBool ( #rangeUInt( 256 , #memoryUsageUpdate( MEMORYUSED_CELL , 64 , 32 ) )
               ))))))))))
      
      [label(BASIC-BLOCK-0-TO-1), priority(30)]
    
    rule [BASIC-BLOCK-0-TO-2]: <kevm>
           <k>
             ( . => JUMP 16
             ~> #pc[ JUMPI ] )
             ~> #execute
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   ( .WordStack => 0 : .WordStack )
                 </wordStack>
                 <localMem>
                   ( LOCALMEM_CELL => LOCALMEM_CELL [ 64 := (String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )):ByteArray ] )
                 </localMem>
                 <pc>
                   ( 0 => 11 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL -Int Cmem( ISTANBUL , #memoryUsageUpdate( MEMORYUSED_CELL , 64 , 32 ) ) +Int Cmem( ISTANBUL , MEMORYUSED_CELL ) +Int -30 )
                 </gas>
                 <memoryUsed>
                   ( MEMORYUSED_CELL => #memoryUsageUpdate( MEMORYUSED_CELL , 64 , 32 ) )
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( #rangeAddress( ACCT_ID )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( CALLVALUE_CELL ==K 0
       andBool ( 0 <=Int GAS_CELL -Int Cmem( ISTANBUL , #memoryUsageUpdate( MEMORYUSED_CELL , 64 , 32 ) ) +Int Cmem( ISTANBUL , MEMORYUSED_CELL ) +Int -30
       andBool ( #rangeUInt( 256 , #memoryUsageUpdate( MEMORYUSED_CELL , 64 , 32 ) )
               ))))))))))
      
      [label(BASIC-BLOCK-0-TO-2), priority(30)]
    
    rule [BASIC-BLOCK-3-TO-5]: <kevm>
           <k>
             ( #pc[ JUMPI ]
             ~> #execute => #halt )
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <output>
                 ( _OUTPUT_CELL => String2Bytes( "" ) )
               </output>
               <statusCode>
                 ( _STATUSCODE_CELL => EVMC_REVERT )
               </statusCode>
               <endPC>
                 ( _ENDPC_CELL => 15 )
               </endPC>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   CALLVALUE_CELL : .WordStack
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 11 => 15 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -6 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( CALLVALUE_CELL =/=K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( 0 <=Int GAS_CELL +Int -6
               ))))))))))
      
      [label(BASIC-BLOCK-3-TO-5), priority(30)]
    
    rule [BASIC-BLOCK-4-TO-6]: <kevm>
           <k>
             ( JUMP 16 => . )
             ~> #pc[ JUMPI ]
             ~> #execute
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   ( 0 : .WordStack => .WordStack )
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 11 => 25 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -24 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( 4 <=Int #sizeByteArray( CALLDATA_CELL )
       andBool ( 0 <=Int GAS_CELL +Int -24
               )))))))))))
      
      [label(BASIC-BLOCK-4-TO-6), priority(30)]
    
    rule [BASIC-BLOCK-4-TO-7]: <kevm>
           <k>
             ( JUMP 16 => JUMP 43 )
             ~> #pc[ JUMPI ]
             ~> #execute
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   ( 0 : .WordStack => .WordStack )
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 11 => 25 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -24 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( #sizeByteArray( CALLDATA_CELL ) <Int 4
       andBool ( 0 <=Int GAS_CELL +Int -24
               )))))))))))
      
      [label(BASIC-BLOCK-4-TO-7), priority(30)]
    
    rule [BASIC-BLOCK-8-TO-10]: <kevm>
           <k>
             #pc[ JUMPI ]
             ~> #execute
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   ( .WordStack => #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray ) : .WordStack )
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 25 => 42 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -34 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( 4 <=Int #sizeByteArray( CALLDATA_CELL )
       andBool ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( 4174037826 =/=K #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray )
       andBool ( 0 <=Int GAS_CELL +Int -34
       andBool ( #rangeUInt( 256 , #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray ) )
               )))))))))))))
      
      [label(BASIC-BLOCK-8-TO-10), priority(30)]
    
    rule [BASIC-BLOCK-8-TO-11]: <kevm>
           <k>
             ( . => JUMP 48 )
             ~> #pc[ JUMPI ]
             ~> #execute
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   ( .WordStack => #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray ) : .WordStack )
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 25 => 42 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -34 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( 4 <=Int #sizeByteArray( CALLDATA_CELL )
       andBool ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( 4174037826 ==K #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray )
       andBool ( 0 <=Int GAS_CELL +Int -34
       andBool ( #rangeUInt( 256 , #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray ) )
               )))))))))))))
      
      [label(BASIC-BLOCK-8-TO-11), priority(30)]
    
    rule [BASIC-BLOCK-9-TO-12]: <kevm>
           <k>
             ( JUMP 43
             ~> #pc[ JUMPI ]
             ~> #execute => #halt )
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <output>
                 ( _OUTPUT_CELL => String2Bytes( "" ) )
               </output>
               <statusCode>
                 ( _STATUSCODE_CELL => EVMC_REVERT )
               </statusCode>
               <endPC>
                 ( _ENDPC_CELL => 47 )
               </endPC>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   .WordStack
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 25 => 47 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -7 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( #sizeByteArray( CALLDATA_CELL ) <Int 4
       andBool ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( 0 <=Int GAS_CELL +Int -7
               )))))))))))
      
      [label(BASIC-BLOCK-9-TO-12), priority(30)]
    
    rule [BASIC-BLOCK-13-TO-15]: <kevm>
           <k>
             ( #pc[ JUMPI ]
             ~> #execute => #halt )
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <output>
                 ( _OUTPUT_CELL => String2Bytes( "" ) )
               </output>
               <statusCode>
                 ( _STATUSCODE_CELL => EVMC_REVERT )
               </statusCode>
               <endPC>
                 ( _ENDPC_CELL => 47 )
               </endPC>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray ) : .WordStack
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 42 => 47 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -7 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( 4174037826 =/=K #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray )
       andBool ( 4 <=Int #sizeByteArray( CALLDATA_CELL )
       andBool ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray ) )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( 0 <=Int GAS_CELL +Int -7
               )))))))))))))
      
      [label(BASIC-BLOCK-13-TO-15), priority(30)]
    
    rule [BASIC-BLOCK-14-TO-16]: <kevm>
           <k>
             ( JUMP 48 => . )
             ~> #pc[ JUMPI ]
             ~> #execute
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   ( #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray ) => 0 ) : ( .WordStack => 4 : chop( #sizeByteArray( CALLDATA_CELL ) ) : 69 : 74 : 4174037826 : .WordStack )
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 42 => 215 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -79 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( 4174037826 ==K #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray )
       andBool ( 4 <=Int #sizeByteArray( CALLDATA_CELL )
       andBool ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray ) )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( 0 =/=K ( (chop( #sizeByteArray( CALLDATA_CELL ) +Int -4 )) s<Word (32) )
       andBool ( 0 <=Int GAS_CELL +Int -79
       andBool ( #rangeUInt( 256 , chop( #sizeByteArray( CALLDATA_CELL ) ) )
               )))))))))))))))
      
      [label(BASIC-BLOCK-14-TO-16), priority(30)]
    
    rule [BASIC-BLOCK-14-TO-17]: <kevm>
           <k>
             ( JUMP 48 => JUMP 224 )
             ~> #pc[ JUMPI ]
             ~> #execute
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   ( #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray ) => 0 ) : ( .WordStack => 4 : chop( #sizeByteArray( CALLDATA_CELL ) ) : 69 : 74 : 4174037826 : .WordStack )
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 42 => 215 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -79 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( 4174037826 ==K #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray )
       andBool ( 4 <=Int #sizeByteArray( CALLDATA_CELL )
       andBool ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray ) )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( 0 ==K ( (chop( #sizeByteArray( CALLDATA_CELL ) +Int -4 )) s<Word (32) )
       andBool ( 0 <=Int GAS_CELL +Int -79
       andBool ( #rangeUInt( 256 , chop( #sizeByteArray( CALLDATA_CELL ) ) )
               )))))))))))))))
      
      [label(BASIC-BLOCK-14-TO-17), priority(30)]
    
    rule [BASIC-BLOCK-18-TO-20]: <kevm>
           <k>
             ( #pc[ JUMPI ]
             ~> #execute => #halt )
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <output>
                 ( _OUTPUT_CELL => String2Bytes( "" ) )
               </output>
               <statusCode>
                 ( _STATUSCODE_CELL => EVMC_REVERT )
               </statusCode>
               <endPC>
                 ( _ENDPC_CELL => 147 )
               </endPC>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   ( 0 => 223 ) : ( 4 => 0 ) : ( chop( #sizeByteArray( CALLDATA_CELL ) ) => 4 ) : ( 69 => chop( #sizeByteArray( CALLDATA_CELL ) ) ) : ( 74 => 69 ) : ( 4174037826 => 74 ) : ( .WordStack => 4174037826 : .WordStack )
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 215 => 147 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -21 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( 0 =/=K ( (chop( #sizeByteArray( CALLDATA_CELL ) +Int -4 )) s<Word (32) )
       andBool ( 4174037826 ==K #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray )
       andBool ( 4 <=Int #sizeByteArray( CALLDATA_CELL )
       andBool ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , chop( #sizeByteArray( CALLDATA_CELL ) ) )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( 0 <=Int GAS_CELL +Int -21
               ))))))))))))))
      
      [label(BASIC-BLOCK-18-TO-20), priority(30)]
    
    rule [BASIC-BLOCK-19-TO-21]: <kevm>
           <k>
             ( JUMP 224 => . )
             ~> #pc[ JUMPI ]
             ~> #execute
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   0 : ( 4 => #asWord( (CALLDATA_CELL [ 4 .. 32 ]):ByteArray ) ) : ( chop( #sizeByteArray( CALLDATA_CELL ) ) => 74 ) : ( 69 => 4174037826 ) : ( 74 : 4174037826 : .WordStack => .WordStack )
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 215 => 107 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -225 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( 0 ==K ( (chop( #sizeByteArray( CALLDATA_CELL ) +Int -4 )) s<Word (32) )
       andBool ( 4174037826 ==K #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray )
       andBool ( 4 <=Int #sizeByteArray( CALLDATA_CELL )
       andBool ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , chop( #sizeByteArray( CALLDATA_CELL ) ) )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( #asWord( (CALLDATA_CELL [ 4 .. 32 ]):ByteArray ) <Int 10
       andBool ( 0 <=Int GAS_CELL +Int -225
       andBool ( #rangeUInt( 256 , #asWord( (CALLDATA_CELL [ 4 .. 32 ]):ByteArray ) )
               ))))))))))))))))
      
      [label(BASIC-BLOCK-19-TO-21), priority(30)]
    
    rule [BASIC-BLOCK-19-TO-22]: <kevm>
           <k>
             ( JUMP 224 => JUMP 133 )
             ~> #pc[ JUMPI ]
             ~> #execute
             ...
           </k>
           <mode>
             NORMAL
           </mode>
           <schedule>
             ISTANBUL
           </schedule>
           <ethereum>
             <evm>
               <callState>
                 <program>
                   BYTES_32d123e7
                 </program>
                 <jumpDests>
                   ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( SetItem( 16 ) SetItem( 43 ) ) SetItem( 48 ) ) SetItem( 69 ) ) SetItem( 74 ) ) SetItem( 87 ) ) SetItem( 96 ) ) SetItem( 124 ) ) SetItem( 133 ) ) SetItem( 138 ) ) SetItem( 143 ) ) SetItem( 148 ) ) SetItem( 158 ) ) SetItem( 167 ) ) SetItem( 178 ) ) SetItem( 181 ) ) SetItem( 196 ) ) SetItem( 202 ) ) SetItem( 223 ) ) SetItem( 224 ) ) SetItem( 238 ) ) SetItem( 247 ) ) SetItem( 256 ) ) SetItem( 262 ) ) SetItem( 283 ) ) SetItem( 321 ) )
                 </jumpDests>
                 <id>
                   ACCT_ID
                 </id>
                 <caller>
                   CALLER_ID
                 </caller>
                 <callData>
                   CALLDATA_CELL
                 </callData>
                 <callValue>
                   CALLVALUE_CELL
                 </callValue>
                 <wordStack>
                   0 : ( 4 => #asWord( (CALLDATA_CELL [ 4 .. 32 ]):ByteArray ) ) : ( chop( #sizeByteArray( CALLDATA_CELL ) ) => 74 ) : ( 69 => 4174037826 ) : ( 74 : 4174037826 : .WordStack => .WordStack )
                 </wordStack>
                 <localMem>
                   _LOCALMEM_CELL [ 64 := (BYTES_f7984f36):ByteArray ]
                 </localMem>
                 <pc>
                   ( 215 => 107 )
                 </pc>
                 <gas>
                   ( GAS_CELL => GAS_CELL +Int -225 )
                 </gas>
                 <memoryUsed>
                   MEMORYUSED_CELL
                 </memoryUsed>
                 ...
               </callState>
               ...
             </evm>
             <network>
               <accounts>
                 ( <account>
                   <acctID>
                     ACCT_ID
                   </acctID>
                   <balance>
                     ACCT_BALANCE
                   </balance>
                   <nonce>
                     ACCT_NONCE
                   </nonce>
                   ...
                 </account>
                 _ACCOUNTS )
               </accounts>
               ...
             </network>
           </ethereum>
           ...
         </kevm>
      requires ( 0 ==K ( (chop( #sizeByteArray( CALLDATA_CELL ) +Int -4 )) s<Word (32) )
       andBool ( 4174037826 ==K #asWord( (CALLDATA_CELL [ 0 .. 4 ]):ByteArray )
       andBool ( 4 <=Int #sizeByteArray( CALLDATA_CELL )
       andBool ( CALLVALUE_CELL ==K 0
       andBool ( BYTES_32d123e7 ==K String2Bytes( "`\x80`@R4\x80\x15a\x00\x10W`\x00\x80\xfd[P`\x046\x10a\x00+W`\x005`\xe0\x1c\x80c\xf8\xca\xc3B\x14a\x000W[`\x00\x80\xfd[a\x00J`\x04\x806\x03\x81\x01\x90a\x00E\x91\x90a\x00\xcaV[a\x00`V[`@Qa\x00W\x91\x90a\x01\x06V[`@Q\x80\x91\x03\x90\xf3[`\x00`\n\x82\x10\x15a\x00\x85W\x81`\n\x11a\x00|W`\x00\x90Pa\x00\x8aV[`\x01\x90Pa\x00\x8aV[`\x02\x90P[\x91\x90PV[`\x00\x80\xfd[`\x00\x81\x90P\x91\x90PV[a\x00\xa7\x81a\x00\x94V[\x81\x14a\x00\xb2W`\x00\x80\xfd[PV[`\x00\x815\x90Pa\x00\xc4\x81a\x00\x9eV[\x92\x91PPV[`\x00` \x82\x84\x03\x12\x15a\x00\xe0Wa\x00\xdfa\x00\x8fV[[`\x00a\x00\xee\x84\x82\x85\x01a\x00\xb5V[\x91PP\x92\x91PPV[a\x01\x00\x81a\x00\x94V[\x82RPPV[`\x00` \x82\x01\x90Pa\x01\x1b`\x00\x83\x01\x84a\x00\xf7V[\x92\x91PPV\xfe\xa2dipfsX\"\x12 \x9a0:oN7\xbf-\xe3\xf9\xed|\x83E~\x02\xc37\x99^\xd6[D\f\xd3:{\xeb\x1d_n!dsolcx(0.8.10-develop.2021.12.2+commit.fc410830\x00Y" )
       andBool ( BYTES_f7984f36 ==K String2Bytes( "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80" )
       andBool ( #rangeUInt( 256 , ACCT_BALANCE )
       andBool ( #rangeAddress( ACCT_ID )
       andBool ( #rangeUInt( 256 , ACCT_NONCE )
       andBool ( #rangeAddress( CALLER_ID )
       andBool ( #rangeUInt( 256 , chop( #sizeByteArray( CALLDATA_CELL ) ) )
       andBool ( #rangeUInt( 256 , CALLVALUE_CELL )
       andBool ( #rangeUInt( 256 , MEMORYUSED_CELL )
       andBool ( 10 <=Int #asWord( (CALLDATA_CELL [ 4 .. 32 ]):ByteArray )
       andBool ( 0 <=Int GAS_CELL +Int -225
       andBool ( #rangeUInt( 256 , #asWord( (CALLDATA_CELL [ 4 .. 32 ]):ByteArray ) )
               ))))))))))))))))
      
      [label(BASIC-BLOCK-19-TO-22), priority(30)]
endmodule
