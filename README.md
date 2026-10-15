# w3-nft-mint

Internal corporate milestone NFT and digital certificate issuing platform built for HR and event coordinators. Enables verifiable badge issuance directly to employee Web3 wallet addresses for company events, performance awards, and tenure milestones.

![Dashboard Preview](docs/images/dashboard-preview.png)

## System Architecture

- **Smart Contract Layer**: Hardhat project with Solidity `0.8` ERC-721 implementation using `AccessControl` for role-based permissions (`MINTER_ROLE`).
- **Frontend Application**: Next.js 16 (App Router) built with TypeScript 5.0, Wagmi v2, and Viem for RPC interaction and wallet signatures.

## Features

- **Role-Based Smart Contract**: Standardized ERC-721 token metadata structure with `DEFAULT_ADMIN_ROLE` and `MINTER_ROLE` management.
- **HR Admin Portal**: Batch minting interface allowing HR staff to upload target employee wallet addresses (`alamat_dompet`) and assign award metadata (`acara_kantor`, `sertifikat_karyawan`).
- **Employee Badge Viewer**: Public-facing viewer within the internal network for staff to view token details, mint date, and verification status on the private EVM explorer.

## Prerequisites

- Node.js 20.x or 22.x LTS
- Access to internal corporate Ethereum testnet RPC node (`RPC_URL_INTERNAL`)
- MetaMask or corporate Web3 wallet extension

## Project Setup

### 1. Repository Installation

```bash
git clone https://github.com/internal-corp/w3-nft-mint.git
cd w3-nft-mint
npm install
```

### 2. Environment Variables Configuration

Create a `.env.local` file in the root directory:

```env
NEXT_PUBLIC_RPC_URL=http://rpc.internal.corp:8545
NEXT_PUBLIC_CHAIN_ID=13370
NEXT_PUBLIC_NFT_CONTRACT_ADDRESS=0x0000000000000000000000000000000000000000
DEPLOYER_PRIVATE_KEY=0x0000000000000000000000000000000000000000000000000000000000000000
```

### 3. Smart Contract Deployment

Compile contracts and deploy to internal RPC node:

```bash
# Compile Solidity contracts
npx hardhat compile

# Run unit test suite
npx hardhat test

# Deploy to internal testnet
npx hardhat run scripts/deploy.ts --network internalTestnet
```

Copy the resulting contract address into `NEXT_PUBLIC_NFT_CONTRACT_ADDRESS` inside `.env.local`.

### 4. Running Web Application

Start local development server:

```bash
npm run dev
```

Build for production deployment:

```bash
npm run build
npm run start
```

## Framework Specific Notes

```typescript
// Workaround for Next.js 16 App Router server hydration issue with Wagmi v2 SSR state rehydration
// Next.js 16 static rendering passes dynamic state mismatch headers when reading wallet connectors during initial hydration
export function ClientProviders({ children, initialState }: { children: React.ReactNode, initialState?: State }) {
  const [mounted, setMounted] = useState(false);
  useEffect(() => setMounted(true), []);

  return (
    <WagmiProvider config={config} initialState={initialState}>
      <QueryClientProvider client={queryClient}>
        {mounted ? children : null}
      </QueryClientProvider>
    </WagmiProvider>
  );
}
```

## Scripts

- `npm run dev`: Launches Next.js dev server on port 3000
- `npm run build`: Compiles production Next.js build
- `npm run contract:compile`: Compiles Solidity contracts via Hardhat
- `npm run contract:deploy`: Executes `scripts/deploy.ts` against target network
