
# Firebase Exploit Bash Script

This script automates the exploitation of common Firebase vulnerabilities, including:

- Open Firebase Realtime Database
- Firebase Remote Config exposure
- Unauthorized user signups

## Usage

```bash
./firebase_exploit.sh -k <API_KEY> -u <FIREBASE_URL> -a <APP_ID> -e <EMAIL>
```

### Arguments

- `-k`: Google API Key (required)
- `-u`: Firebase Realtime Database URL (e.g., https://yourapp.firebaseio.com)
- `-a`: Firebase App ID (required for Remote Config check)
- `-e`: Email address to test unauthorized signup

## Example

```bash
./firebase_exploit.sh -k AIzaSyXXXXXXX -u https://test.firebaseio.com -a 1:1234567890:android:abcdef123456 -e test@example.com
```

## Output

The script will:
- Print results of the open database check
- Attempt to fetch Firebase Remote Config
- Try unauthorized signup and send a verification email
