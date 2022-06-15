principal_id="none"
account_id="none"
wallet_id="none"
github_url="https://github.com/Psychedelic/DIP20.git"

function installHomebrew() {
  echo "";
  echo "Check Homebrew...";
  if ! [ -x "$(command -v brew)" ];
  then
    echo "Homebrew has not installed.";
    echo "Homebrew installing...";
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [ -x "$(command -v brew)" ];
  then
    echo "Homebrew installed.";
  else
    echo "Homebrew install failed.";
    exit 1;
  fi
}

function installGit() {
  echo "";
  echo "Check Git...";
  if ! [ -x "$(command -v git)" ];
  then
    echo "Git has not installed.";
    echo "Git installing...";
    brew install git
  fi
  if [ -x "$(command -v git)" ];
  then
    echo "Git installed.";
  else
    echo "Git install failed.";
    exit 1;
  fi
}

function installDfx() {
  echo "";
  echo "Check Dfx...";
  if ! [ -x "$(command -v dfx)" ];
  then
   echo "Dfx has not installed.";
   echo "Dfx installing...";
   sh -ci "$(curl -fsSL https://smartcontracts.org/install.sh)"
  fi
  if [ -x "$(command -v dfx)" ];
  then
    echo "Dfx installed.";
  else
    echo "Dfx install failed.";
    exit 1;
  fi
}

function createWallet() {
  echo "";
  echo "It need at least 1.00 ICP for creating a wallet canister.";
  user_balance=`dfx ledger --network ic balance`;
  echo "Your current balance:" $user_balance;
  read -p "Please make sure your identity has 1.00 ICP or more. y/n " has_icp;
  if [ "$has_icp" == y ]
  then
    principal_id=$1;
    create_result=`dfx ledger --network ic create-canister $principal_id --amount 1`;
    echo "$create_result";
    if [[ $create_result == Error* ]]
    then
      echo "Sorry, there are some errors in creating wallet canister. Please check it, and then restart the shell.";
      exit 1;
    fi
    wallet_canister=${create_result#*id: }
    wallet_id=${wallet_canister:1:27}
    dfx identity --network ic deploy-wallet $wallet_id
  else
    echo "Please transfer some ICP to your account, and then restart the shell.";
    exit 1;
  fi
  return $wallet_id
}

function checkWallet() {
  echo "";
  identity=`dfx identity whoami`;
  echo "Your current identity is" $identity;
  read -p "Do you change your identity? y/n " change_identity
  if [ "$change_identity" == y ]
  then
    read -p "Please input your identity: " identity
    dfx identity use $identity
  fi
  principal_id=`dfx identity get-principal`;
  echo "The principal of your current identity is" $principal_id;
  account_id=`dfx ledger account-id`;
  echo "The account identifier of your current identity is" $account_id;
  read -p "Do you have a wallet canister for your current identity? y/n " has_wallet
  if [ "$has_wallet" == y ]
  then
    read -p "Please input your wallet canister id: " input_wallet_id
    while [[ ${#input_wallet_id} -ne 27 ]]
    do
      echo "Input an error canister id...";
      read -p "Please input your wallet canister id: " input_wallet_id
    done
    wallet_id=$input_wallet_id
  else
    createWallet $principal_id
    wallet_id=$?
  fi

  wallet_cycles=`dfx wallet --network=ic balance`;
  echo "Your current available cycles:" $wallet_cycles;
  current_cycles=${wallet_cycles% cycles.*}
  while [[ "$current_cycles" -lt 4000000000000 ]]
  do
    read -p "You have not enough cycles, please swap some cycles. Continue? y/n " go_swap
    if [ "$go_swap" == y ]
    then
      read -p "Please input the icp amount that you want to swap to cycles: " swap_amount
      echo `dfx ledger --network ic top-up $wallet_id --amount $swap_amount`;
      wallet_cycles=`dfx wallet --network=ic balance`;
      echo "Your current available cycles:" $wallet_cycles;
      current_cycles=${wallet_cycles% cycles.*}
    else
      echo "Sorry, you have not enough cycles. The shell will exit.";
      echo "When you have enough cycles, you can restart the shell.";
      exit 1;
    fi
  done
}

function transfer() {
  echo "";
  read -p "Do you want to transfer some amount of your mint token to others? y/n " need_transfer
  if [ "$need_transfer" == y ]
  then
    read -p "Please input to principal-id: " to_principal_id
    echo "Please input the transfer amount. For example, the token with 8 decimal, you want to transfer 0.25 amount, then you need to input 25000000.";
    read -p "Please input your transfer amount: " amount
    symbol=$1
    dfx canister --network=ic call token transfer '(principal '"$to_principal_id"', '$amount')'
    echo "transfer finished.";
  fi
  echo "You can execute follow command to transfer you mint token:";
  echo "dfx canister --network=ic call token transfer '(principal \"to_principal_id\", amount)'";
}

function mintToken() {
  echo "";
  read -p "Have you ever downloaded the token project? y/n " has_downloaded
  if [ "$has_downloaded" == y ]
  then
    read -p "Please input your token project dir path: " project_path
  else
    echo "Download token project from GitHub.";
    read -p "Please input your download dir: " project_path
    git clone $github_url $project_path
  fi
  cd $project_path"/motoko" || exit
  read -p "Please input your token logo that base64 code: " token_logo
  read -p "Please input your token name: " token_name
  read -p "Please input your token symbol: " token_symbol
  read -p "Please input your token decimal: " token_decimal
  read -p "Please input your token supply: " token_supply
  read -p "Please input your token fee: " token_fee
  dfx deploy --network=ic --wallet=$wallet_id token --argument="(\"$token_logo\", \"$token_name\", \"$token_symbol\", $token_decimal, $token_supply, principal \"$(dfx identity get-principal)\", $token_fee)"
  echo "Please save your token canister id!";
  transfer $token_symbol
}

echo "Mint Token Starting...";
echo "System Environment Checking...";
installHomebrew
installGit
installDfx
checkWallet
mintToken
echo "Mint Token finished...";
