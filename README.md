# Script to synchronize data from LIBRIS to EDS

Script to fetch daily updates from LIBRIS that sends them over to EDS for further processing.

## Requirements

Copy settings.example to settings and fill in the values.

FTP-Username and Password for EDS should be saved in ~/.netrc for this script to work.
Fill in as example below. Do not keep the curly brackets.

```
machine {edshostname}
login {edsusername}
password {edspassword}
```

Change the slack notifying according to your requirements.
