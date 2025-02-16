
# Ping Check Script

## Overview

This repository contains a simple Bash script to monitor the reachability of a list of websites. If all the websites are unreachable, the script will attempt to reboot the router by calling another script.

## Features

- Checks the reachability of specified websites using the `ping` command.
- Retries rebooting the router if the initial attempt fails.
- Configurable list of websites and retry count.

## Prerequisites

- Bash shell
- `ping` command available in the system
- Executable permission for the scripts

## Usage

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/ping-check.git
   cd ping-check
   ```

2. **Make the scripts executable:**

   ```bash
   chmod +x ping_check.sh reboot_router.sh
   ```

3. **Run the ping check script:**

   ```bash
   ./ping_check.sh
   ```

## Configuration

- **WEBSITES:** An array of website URLs to check. You can modify this array to include any websites you want to monitor.
- **RETRY_COUNT:** The number of times the script will attempt to reboot the router if all websites are unreachable.

## Scripts

### `ping_check.sh`

This is the main script that performs the ping checks. It uses the `ping` command to check the reachability of each website in the `WEBSITES` array. If all websites are unreachable, it calls the `take_action` function, which attempts to reboot the router by calling `reboot_router.sh`.

### `reboot_router.sh`

This script is called by `ping_check.sh` to reboot the router. You need to implement the logic for rebooting your specific router in this script.

## Contributing

Feel free to fork this repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

If you have any questions or suggestions, feel free to open an issue or contact me directly.
