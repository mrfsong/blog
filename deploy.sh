#!/bin/sh
echo "============ Clean old posts ============"
hexo clean
STATUS=$?
if [ $STATUS -eq 0 ]; then
    echo "============ Re-Generate posts ============"
    hexo generate
    STATUS=$?
    if [ $STATUS -eq 0 ]; then
        echo "============ Copy CNAME ============"
        cp CNAME public/ && hexo deploy
    else
        mvn release:rollback
    fi
else
    echo "============ Release dryRun Failed , exec clean phase ============"
    mvn release:clean
fi
