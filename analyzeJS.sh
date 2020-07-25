#!/bin/bash

banner(){
	echo -e "\t                                               v1.0\t"
	echo -e "\t                     __                     _______\t"
	echo -e "\t  ____  ____  ____  / /_  ______  ___      / / ___/\t"
	echo -e "\t / __ \/ __ \/ __ \/ / / / /_  / / _ \__  / /\__ \ \t"
	echo -e "\t/ /_/ / / / / /_/ / / /_/ / / /_/  __/ /_/ /___/ / \t"
	echo -e "\t\__,_/_/ /_/\__,_/_/\__, / /___/\___/\____//____/  \t"
	echo -e "\t                   /____/                          \t"
	echo -e "\t                                                   \t"
	echo -e "\t                 By @_YashGoti_                    \t"
}

help(){
	banner
	echo -e ""
	echo -e "[Options]:"
	echo -e "\t-d\tspecify target domain [required]\n"
	echo -e "\t-j\tfind JS urls for your target [gau, subjs, hakrawler]\n"
	echo -e "\t-l\tfind live JS urls for your target [httpx]\n"
	echo -e "\t-c\tprint content of JS urls [jsbeautify.py]\n"
	echo -e "\t-e\tfind endpoints from JS urls\n"
	echo -e "\t-s\tfind secrets from JS urls\n"
	echo -e "\t-n\tsend notification to telegram bot\n"
	echo -e "\t-h\thelp"
}

checkDirectories(){
	mkdir -p ./js-recon
	mkdir -p ./js-recon/$1
}

log(){
	echo -e $1
}

print(){
	cat ./js-recon/$1/$2
}

getJSurls(){
	#gau
	./tools/gau $1 | grep $1 | sort -u > ./js-recon/$1/gau.txt
	cat ./js-recon/$1/gau.txt | grep -iE "\.js$" > ./js-recon/$1/gau.jsurls.txt
	#gal
	./tools/gal.sh -u $1 | grep $1 | sort -u > ./js-recon/$1/gal.txt
	cat ./js-recon/$1/gal.txt | grep $1 | grep -iE "\.js$" | sort -u > ./js-recon/$1/gal.jsurls.txt
	#subjs
	./tools/subjs -i ./js-recon/$1/gau.txt -c 25 -ua "JS-analyzer" | grep $1 | sort -u > ./js-recon/$1/subjs.txt
	#hakrawler
	./tools/hakrawler -js -url $1 -plain -depth 3 -scope strict -insecure | grep $1 > ./js-recon/$1/hakrawler.txt
	#Merging
	cat ./js-recon/$1/gau.jsurls.txt ./js-recon/$1/gal.jsurls.txt ./js-recon/$1/subjs.txt ./js-recon/$1/hakrawler.txt | grep $1 | sort -u > ./js-recon/$1/jsurls.txt
}

getLiveJSurls(){
	#httpx
	./tools/httpx -l ./js-recon/$1/jsurls.txt -silent -status-code | grep "[200]" | cut -d ' ' -f1 > ./js-recon/$1/live.jsurls.txt
}

getJSurlsContent(){
	#jsbeautify.py
	./tools/jsbeautify.py -ul ./js-recon/$1/jsurls.txt > ./js-recon/$1/jsurls.content.txt
}

getJSurlsEndpoints(){
	#linkfinder
	while read -r jsurl; do python3 ./tools/linkfinder.py -d -i $jsurl -o cli > ./js-recon/$1/jsurls.endpoints.txt; done < ./js-recon/$1/jsurls.txt
}

getJSurlsSecrets(){
	#secretfinder
	while read -r jsurl; do python3 ./tools/secretfinder.py -i $jsurl -o cli > ./js-recon/$1/jsurls.secrets.txt; done < ./js-recon/$1/jsurls.txt
}

notifyMe(){
	# Follow this to find your token and chatid
    # https://medium.com/@ManHay_Hong/how-to-create-a-telegram-bot-and-send-messages-with-python-4cf314d9fa3e
	notification=$1
	token="CHANGEME"
	chatid="CHANGEME"
	curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chatid -d text="$notification" > /dev/null
}

if [[ -z $1 ]]; then help; fi

while getopts "d:jlcesnh" OPT; do
    case ${OPT} in
        d  ) target=$OPTARG ; checkDirectories $target ; getJSurls $target ;;
		j  ) print $target "jsurls.txt" ;;
		l  ) getLiveJSurls $target && print $target "live.jsurls.txt" ;;
		c  ) getJSurlsContent $target && print $target "jsurls.content.txt" ;;
		e  ) getJSurlsEndpoints $target ;;
		s  ) getJSurlsSecrets $target ;;
		n  ) notifyMe "JS-analyzer is done for $target, go and grab a spoon." ;;
		h  ) help ;;
    esac
done
shift $((OPTIND -1))
