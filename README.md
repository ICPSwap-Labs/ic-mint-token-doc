# Mint Token Doc

## Start Mint Token

### Mint DIP20 Token

1. Download the `mint-dip20-token.sh`.

2. Open a terminal shell on your local computer, if you don’t already have one open.

3. Execute the following command, and follow the prompts to enter content.
```shell
sh mint-dip20-token.sh
```

### Mint EXT Token

1. Download the `mint-ext-token.sh`.

2. Open a terminal shell on your local computer, if you don’t already have one open.

3. Execute the following command, and follow the prompts to enter content.
```shell
sh mint-ext-token.sh
```

## System Environment

### IC Environment

#### Install DFX

[IC Official Docs](https://internetcomputer.org/docs/current/developer-docs/quickstart/network-quickstart)

You can download the latest version of the SDK directly from within a terminal shell on your local computer. If you have previously installed the SDK, you can skip this section and start with Create a wallet.

##### Download and install

1. Open a terminal shell on your local computer.
For example, open Applications, Utilities, then double-click **Terminal** or press ⌘+spacebar to open Search, then type `terminal`.

2. Download and install the SDK package by running the following command:
```shell
sh -ci "$(curl -fsSL https://smartcontracts.org/install.sh)"
```
This command prompts you to read and accept the license agreement before installing the DFINITY execution command-line interface (CLI) and its dependencies on your local computer.

3. Type `y` and press Return to continue with the installation.

 The command displays information about the components being installed on the local computer.

##### Verify the SDK is ready to use

1. Open a terminal shell on your local computer, if you don’t already have one open.

2. Check that you have the DFINITY execution command-line interface (CLI) installed and the dfx executable is available in your PATH by running the following command:
```shell
dfx --version
```
The command displays version information for the dfx command-line executable.

#### Create a wallet

[IC Official Docs](https://internetcomputer.org/docs/current/developer-docs/quickstart/network-quickstart)

##### Connect to the ledger to get account information
For the purposes of this tutorial—where there’s no hardware wallet or external application to connect to the ledger—we’ll use your developer identity to retrieve your ledger account identifier, then transfer ICP tokens from the ledger account identifier to a cycles wallet canister controlled by your developer identity.

To look up your account in the ledger:

1. Confirm the developer identity you are currently using by running the following command:
```shell
dfx identity whoami
```
In most cases, you should see that you are currently using default developer identity. For example:
```shell
default
```

2. View the textual representation of the principal for your current identity by running the following command:
```shell
dfx identity get-principal
```
This command displays output similar to the following:
```shell
tsqwz-udeik-5migd-ehrev-pvoqv-szx2g-akh5s-fkyqc-zy6q7-snav6-uqe
```

3. Get the account identifier for your developer identity by running the following command:
```shell
dfx ledger account-id
```
This command displays the ledger account identifier associated with your developer identity. For example, you should see output similar to the following:
```shell
03e3d86f29a069c6f2c5c48e01bc084e4ea18ad02b0eec8fccadf4487183c223
```

##### Convert ICP tokens to cycles
Now that you have confirmed your account information and current ICP token balance, you can convert some of those ICP tokens to cycles and move them into a cycles wallet.

To transfer ICP tokens to create a cycles wallet:

1. Create a new canister with cycles by transferring ICP tokens from your ledger account by running a command similar to the following:
```shell
dfx ledger --network ic create-canister <principal-identifier> --amount <icp-tokens>
```
This command converts the number of ICP tokens you specify for the --amount argument into cycles, and associates the cycles with a new canister identifier controlled by the principal you specify.

  For example, the following command converts .25 ICP tokens into cycles and specifies the principal identifier for the default identity as the controller of the new canister:
```shell
dfx ledger --network ic create-canister tsqwz-udeik-5migd-ehrev-pvoqv-szx2g-akh5s-fkyqc-zy6q7-snav6-uqe --amount .25
```
If the transaction is successful, the ledger records the event and you should see output similar to the following:
```shell
Transfer sent at BlockHeight: 20
Canister created with id: "gastn-uqaaa-aaaae-aaafq-cai"
```

2. Install the cycles wallet code in the newly-created canister placeholder by running a command similar to the following:
```shell
dfx identity --network ic deploy-wallet <canister-identifer>
```
For example:
```shell
dfx identity --network ic deploy-wallet gastn-uqaaa-aaaae-aaafq-cai
```
This command displays output similar to the following:
```shell
Creating a wallet canister on the IC network.
The wallet canister on the "ic" network for user "default" is "gastn-uqaaa-aaaae-aaafq-cai"
```

### Git Environment

#### Download and install

Go to [Git](https://git-scm.com/download/mac), download and install it.

1. Install homebrew if you don't already have it. Open a terminal shell on your local computer, if you don’t already have one open.
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install Git.

```shell
brew install git
```

#### Verify the Git is ready to use

1. Open a terminal shell on your local computer, if you don’t already have one open.

2. Check that you have the **git** execution command-line interface (CLI) installed and the **git** executable is available in your PATH by running the following command:
```shell
git --version
```
The command displays version information for the git command-line executable.
