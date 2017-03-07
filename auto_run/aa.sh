#!/bin/sh
dmesg|tail -5 > /tmp/wrap.kmesg
expr index /tmp/wrap.kmesg "passwd"
if [$? -eq 0]
    echo "hahahahah"
fi

