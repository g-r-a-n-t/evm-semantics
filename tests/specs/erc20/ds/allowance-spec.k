module ALLOWANCE-SPEC
  imports VERIFICATION

  // allowance
  claim
    <kevm>
    <k> #execute => #halt </k>
    <exit-code> 1 </exit-code>
    <mode> NORMAL </mode>
    <schedule> ISTANBUL </schedule>

    <ethereum>
      <evm>
        <output> _ => #buf(32, ALLOWANCE) </output>
        <statusCode> _ => EVMC_SUCCESS </statusCode>
        <callStack> _ </callStack>
        <interimStates> _ </interimStates>
        <touchedAccounts> _ => ?_ </touchedAccounts>

        <callState>
          <program> #parseByteStack("") </program>
          <jumpDests> #computeValidJumpDests(#parseByteStack("")) </jumpDests>

          <id> ACCT_ID </id> // contract owner
          <caller> CALLER_ID </caller> // who called this contract; in the begining, origin // msg.sender

          <callData> #abiCallData("allowance", #address(OWNER), #address(SPENDER)) </callData>

          <callValue> 0 </callValue>
          <wordStack> .WordStack => ?_ </wordStack>
          <localMem> .Bytes => ?_ </localMem>
          <pc> 0 => ?_ </pc>
          <gas> #gas(_VGAS) => ?_ </gas>
          <memoryUsed> 0 => ?_ </memoryUsed>
          <callGas> _ => ?_ </callGas>

          <static> false </static> // NOTE: non-static call
          <callDepth> CALL_DEPTH </callDepth>
        </callState>

        <substate>
          <selfDestruct> _ </selfDestruct>
          <log> _ </log>
          <refund> _ </refund> // TODO: more detail
          <accessedAccounts> _ => ?_ </accessedAccounts>
          <accessedStorage> _ => ?_ </accessedStorage>
        </substate>

        <gasPrice> _ </gasPrice>
        <origin> ORIGIN_ID </origin> // who fires tx

        <blockhashes> _ </blockhashes>
        <block>
          <previousHash> _ </previousHash>
          <ommersHash> _ </ommersHash>
          <coinbase> _ </coinbase>
          <stateRoot> _ </stateRoot>
          <transactionsRoot> _ </transactionsRoot>
          <receiptsRoot> _ </receiptsRoot>
          <logsBloom> _ </logsBloom>
          <difficulty> _ </difficulty>
          <number> _ </number>
          <gasLimit> _ </gasLimit>
          <gasUsed> _ </gasUsed>
          <timestamp> _ </timestamp>
          <extraData> _ </extraData>
          <mixHash> _ </mixHash>
          <blockNonce> _ </blockNonce>
          <baseFee> _ </baseFee>
          <ommerBlockHeaders> _ </ommerBlockHeaders>
        </block>
      </evm>

      <network>
        <chainID> _ </chainID>

        <activeAccounts> SetItem(ACCT_ID) _:Set </activeAccounts>

        <accounts>
          <account>
            <acctID> ACCT_ID </acctID>
            <balance> _ </balance>
            <code> #parseByteStack("") </code>
            <storage> #hashedLocation("Solidity", 2, OWNER SPENDER) |-> ALLOWANCE
_:Map </storage>
            <origStorage> _ </origStorage>
            <nonce> _ </nonce>
          </account>
       // ... // TODO: fix
        </accounts>

        <txOrder> _ </txOrder>
        <txPending> _ </txPending>
        <messages> _ </messages>
      </network>
    </ethereum>
    </kevm>
    requires 0 <=Int ACCT_ID    andBool ACCT_ID    <Int (2 ^Int 160)
     andBool 0 <=Int CALLER_ID  andBool CALLER_ID  <Int (2 ^Int 160)
     andBool 0 <=Int ORIGIN_ID  andBool ORIGIN_ID  <Int (2 ^Int 160)
     andBool 0 <=Int CALL_DEPTH andBool CALL_DEPTH <Int 1024
     andBool 0 <=Int OWNER     andBool OWNER     <Int (2 ^Int 160)
andBool 0 <=Int SPENDER   andBool SPENDER   <Int (2 ^Int 160)
andBool 0 <=Int ALLOWANCE andBool ALLOWANCE <Int (2 ^Int 256)


endmodule

