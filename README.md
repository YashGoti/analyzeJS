# analyzeJS

**analyzeJS** is a tool which is a combination of different tools and make **JavaScript[JS] Recon** more automate, if you are doing this _automate then it might take awhile to gather the information regarding JavaScript._

![analyzeJS](https://github.com/YashGoti/analyzeJS/blob/master/logo.svg)

### Setup
Don't need to 😂.
* Change the **token** and  **chat_id** in the file, So that you'll get a notification. [https://medium.com/@ManHay_Hong/how-to-create-a-telegram-bot-and-send-messages-with-python-4cf314d9fa3e]

### Features
* Gather JS URLs using many other tools [**gau, gal, subjs, hakrawler**].
* Checking for live JS urls using tool [**httpx**].
* Gather content/response from live JS urls [**jsbeautify.py**].
* Send notification to telegram once your scan will be done [**Telegram Bot API**].
* Many more are on the way.

### Usage
|**Options**|**Description**|
|---|---|
|**-d**|specify target domain [required]|
|**-j**|find JS urls for your target [gau, subjs, hakrawler]|
|**-l**|find live JS urls for your target [httpx]|
|**-c**|print content of JS urls [jsbeautify.py]|
|**-e**|find endpoints from JS urls|
|**-s**|find secrets from JS urls|
|**-n**|send notification to telegram bot|
|**-h**|help|

### Examples
* ./analyzeJS.sh **-d** _TARGET_DOMAIN_ **-j**
* ./analyzeJS.sh **-d** _TARGET_DOMAIN_ **-l**
* ./analyzeJS.sh **-d** _TARGET_DOMAIN_ **-j** **-c**
* ./analyzeJS.sh **-d** _TARGET_DOMAIN_ **-l** **-c**
* ./analyzeJS.sh **-d** _TARGET_DOMAIN_ **-l** **-c** **-n**

### References 
* [gal](https://github.com/YashGoti/gal)
* [jsbeautify.py](https://github.com/YashGoti/Hacks/blob/master/jsbeautify.py)

### Contact
* [Twitter](https://twitter.com/_YashGoti_)
