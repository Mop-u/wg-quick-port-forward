#!/bin/bash
POSTUP=0
POSTDN=0
while getopts 'ud' OPTION; do
    case "$OPTION" in
        u)
            POSTUP=1
        ;;
        d)
            POSTDN=1
        ;;
        ?)
            echo "Specify -u for PostUp or -d for PostDown"
            exit 1
        ;;
    esac
done

if [[ $POSTUP -eq $POSTDN ]]; then
    echo "Specify only one option"
    exit 1
fi

function port_rule(){
    PROTOCOL=$1
    SRCPORT=$2
    DSTIP=$3
    DSTPORT=$4
    if [[ $POSTUP -eq 1 ]]; then
        TABLEOP="-A"
        FIREOP="--add-port"
    else
        TABLEOP="-D"
        FIREOP="--remove-port"
    fi
    firewall-cmd --zone=public $FIREOP=$SRCPORT
    iptables -t nat $TABLEOP PREROUTING -p $PROTOCOL --dport $SRCPORT -j DNAT --to-destination $DSTIP:$DSTPORT
}
