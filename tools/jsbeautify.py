#!/usr/bin/env python
import os, sys, requests, argparse, jsbeautifier

def parser_error(errmsg):
    print("Usage: python3 " + sys.argv[0] + " [Options] use -h for help")
    print("Error: " + errmsg)
    sys.exit()

def parse_args():    
    parser = argparse.ArgumentParser(epilog='\tExample: \r\npython3 ' + sys.argv[0] + " -u google.com")
    parser.error = parser_error
    parser._optionals.title = "OPTIONS"
    parser.add_argument('-u', '--url', help='JS URL', required=False)
    parser.add_argument('-ul', '--urllist', help='List of JS URLs', required=False)
    return parser.parse_args()

def beautifyjs(content):
    try:
        return jsbeautifier.beautify(content)
    except:
        pass

def getjsresponse(url):
    try:
        return requests.get("{}".format(url), timeout=10)
    except:
        pass

if __name__ == "__main__":
    args = parse_args()
    if args.url:
        if args.url.startswith("http://") or args.url.startswith("https://"):
            response = getjsresponse(args.url)
            if response.status_code == 200:
                # print(args.url)
                print(beautifyjs(response.text) + "\n")
            else:
                print(args.url + " [" + str(response.status_code) + "] ")
        elif args.url.startswith("view-source:"):
            response = getjsresponse(args.url.split("view-source:")[1])
            if response.status_code == 200:
                # print(args.url.split("view-source:")[1])
                print(beautifyjs(response.text) + "\n")
        else:
            parser_error(args.url + " not in valid format")
    elif args.urllist:
        if os.path.isfile(args.urllist):
            f = open(args.urllist, "r")
            for jsurl in f:
                jsurl = jsurl.rstrip()
                response = getjsresponse(jsurl)
                if response.status_code == 200:
                    # print(jsurl)
                    print(beautifyjs(response.text) + "\n")
                else:
                    print(jsurl + " [" + str(response.status_code) + "] ")
        else:
            parser_error(args.urllist + " not valid file")