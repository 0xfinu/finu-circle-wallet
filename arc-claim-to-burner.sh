#!/bin/bash
# Arc testnet faucet claim -> burner EVM wallet (0xmuse).
# Runs every ~2h via cron. Circle CLI lives at ~/.local/bin/circle (durable across VM restarts).
# Flow: claim the 20 test USDC drip into the Circle agent wallet, then transfer
# the full 20 straight to the burner EVM address. Circle is Arc-only; every
# other chain claims directly to its burner address (never via this wallet).
set -u
export PATH="$HOME/.local/bin:$PATH"
export CIRCLE_ACCEPT_TERMS=1
AGENT="0xf1bfee7392a18cd9927b84e26560819c4676ae27"
BURNER="0xBb87bD789Ca67562F531685e10EB78eC03dE3dEB"
LOG="$HOME/workspace/goals/0xmuse-agent-and-website-build/hidden_files/arc-claim.log"
mkdir -p "$(dirname "$LOG")"
{
  echo "=== $(date -u +%FT%TZ) ==="
  circle wallet fund --address "$AGENT" --chain ARC-TESTNET
  sleep 25
  circle wallet transfer "$BURNER" --amount 20 --token 0x3600000000000000000000000000000000000000 --address "$AGENT" --chain ARC-TESTNET
  echo "--- burner balance (native, hex wei) ---"
  curl -s --max-time 20 -X POST https://rpc.testnet.arc.io -H 'Content-Type: application/json' -d "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"$BURNER\",\"latest\"],\"id\":1}"
  echo
} >> "$LOG" 2>&1
