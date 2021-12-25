info? installing jq $(dim 'https://stedolan.github.io/jq/')
sudo apt install -y jq 2>>$logfile 1>&2 &
wait_job
