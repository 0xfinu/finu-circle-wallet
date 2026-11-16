# finu-circle-wallet

![0xmuse logo](https://raw.githubusercontent.com/0xfinu/finu.muse/main/0xmuse-logo-160x160.jpg)

**finu.muse Circle agent-wallet claim script — draws testnet USDC from the Circle Arc faucet straight to the burner wallet. DYOR, don't trust — verify, not your keys, not your coins.**

🌐 [Live site](https://0xfinu.github.io/finu.muse/) · 💻 [finu.muse](https://github.com/0xfinu/finu.muse)

---

## What it is

One script, `arc-claim-to-burner.sh`, run every 2 hours:

1. `circle wallet fund` — claims the **20 test USDC** drip into the Circle agent wallet on Arc testnet.
2. `circle wallet transfer` — moves the full 20 straight to the burner EVM wallet.
3. Verifies the burner balance via the Arc testnet RPC.

Circle is **Arc-only**. Every other chain claims directly to its burner address — never via this wallet. The agent wallet holds a zero balance between claims by design.

| | |
| --- | --- |
| Circle agent wallet (Arc testnet) | `0xf1bfee7392a18cd9927b84e26560819c4676ae27` |
| Burner EVM (destination) | `0xBb87bD789Ca67562F531685e10EB78eC03dE3dEB` |
| Chain | Arc testnet (5042002) |
| Amount | 20 test USDC per claim, every 2 hours |
| CLI | `@circle-fin/cli` 1.3.0 |

## Install

```bash
npm install -g @circle-fin/cli
circle --version   # 1.3.0
```

Then log in — the CLI asks for an email OTP (no Console account, no API key, no KYC in the CLI flow). The session lasts **28 days**, then a fresh OTP re-login is needed — automation cannot re-auth without you.

## Usage

```bash
bash arc-claim-to-burner.sh
# or
npm run claim
```

The script logs to `~/workspace/goals/0xmuse-agent-and-website-build/hidden_files/arc-claim.log` on the build VM — adjust the `LOG` path if you run it elsewhere. It expects `circle` on your `PATH` (the script prepends `~/.local/bin`). It sets `CIRCLE_ACCEPT_TERMS=1` — read Circle's Terms yourself before running it; the script does not accept them on your behalf blindly.

Note the transfer uses the USDC predeploy address `0x3600000000000000000000000000000000000000` as `--token` (the `--token usdc` form 404s). Gas on Arc is sponsored by Circle ($0, capped, fair-use).

## Safety

- **Arc testnet only.** No mainnet, no real money. The CLI session is user-custodied 2-of-2 MPC — the agent never sees the keys.
- **Funds move straight to the burner.** Nothing accumulates in the agent wallet; the claim routing rule is: Circle claims Arc testnet USDC only, everything else claims directly to the burner.
- **No KYC.** The CLI flow needs only an email OTP. The fiat on-ramp (Transak) is KYC — avoid it; fund with crypto instead.
- **Testnet only, no subscription.** Circle Agent Wallets are EVM-only (9 chains) — no BTC/SOL/TRON; those live in [finu-wallet](https://github.com/0xfinu/finu-wallet).

---

*Built with [finu.muse](https://0xfinu.github.io/finu.muse/) — 0xfinu + muse. Testnet only — no real money, no mainnet funds.*
