#!/bin/bash


# list of platforms
platforms=(Bluesky Facebook Instagram LINE LinkedIn Parler Pinterest Quora Reddit
           Snapchat Spotify Telegram Threads TikTok TruthSocial Twitch
           Twitter X WeChat WhatsApp YouTube)

# policy types available for (almost) all platforms
policy_types=("Terms of Service" "Privacy Policy" "Community Guidelines")


echo "$(date '+[%Y-%m-%d %H:%M:%S]') Unrolling PGA-Versions"

target_prefix="$PWD/tmp-pga-versions-history"
if [ -d "$target_prefix" ]; then
    echo "Cleaning up $target_prefix/"
    rm -r "$target_prefix"/*
else
    mkdir -p "$target_prefix"
fi


cd pga-versions


# pull latest changes
git pull origin main

# count policy types
ls */*.md | cut -d/ -f3 | sort | uniq -c | sort -k1,1nr


for platform in "${platforms[@]}"; do
    mkdir -p "$target_prefix"/$platform
    for ptype in "${policy_types[@]}"; do
        policy=$platform/"$ptype".md
        echo "Checking out versions of $platform's $ptype"
        _ptype=${ptype// /_}
        mkdir "$target_prefix"/"$platform"/${_ptype}
        git log --pretty=format:"%h %aI" --date=short "$policy" | cut -d'+' -f1 | tr -d ':-' \
            | while read commithash date; do
            target="$target_prefix"/$platform/${_ptype}/${date}_${commithash}_${platform}_${_ptype}.md
            if [ -e "$target" ]; then
                continue
            fi
            # echo "$commithash  $date  $policy"
            git checkout $commithash "$policy"
            cp -p "$policy" $target
        done
        # checkout latest version again
        git checkout main "$policy"
    done
done

cd -


echo "Moving policies of Twitter to X"
for ptype in $(ls "$target_prefix"/Twitter/); do
    mv -v "$target_prefix"/Twitter/"$ptype"/* "$target_prefix"/X/"$ptype"/
done
rm -r "$target_prefix"/Twitter/


echo "Policies versions are in: $target_prefix"
