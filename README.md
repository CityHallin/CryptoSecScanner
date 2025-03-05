# CryptoSecScanner
<img width="70" alt="favicon" src="https://raw.githubusercontent.com/CityHallin/Cityhallin/main/images/crypto_scanner/crypto_scanner_small.png">

### Overview
My personal project that scans the [SEC.gov EDGAR](https://www.sec.gov/search-filings) system for 8-K filings related to cryptocurrencies. The scanner reviews the EDGAR system every 10 minutes looking for relevant filings. Once a relevant filing is found, it will be posted to two areas:

 - **Social Media**: [CryptoSecScanner](https://infosec.exchange/@cryptosecscanner) bot account on the [Infosec.Exchange](https://infosec.exchange/about) Fediverse Mastodon Instance. 

 - **CSV File**: The [sec_8k_crypto.csv](https://github.com/CityHallin/CryptoSecScanner/blob/main/reports/sec_8k_crypto.csv) file in this GitHub repo. 

### Other Notes
This project is a work in progress in order to dial in the search parameters to capture as many relevant results as possible. 
