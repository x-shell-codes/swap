# Swap Manager
A tool you can use to use swap spaces.

## Features
* User-friendly installation and configuration process,
* Automatic swap space calculation.

## Requirements
* Ubuntu (tested on Ubuntu 22.04, Ubuntu 20.04, Ubuntu 18.04, Ubuntu 16.04, Ubuntu 14.04)
* CentOS (tested on CentOS 8, CentOS 7)

## Creating
### Basic & Settings
```
wget https://raw.githubusercontent.com/x-shell-codes/swap/master/swap.sh
sudo bash swap.sh
```

### Advanced
```
wget https://raw.githubusercontent.com/x-shell-codes/swap/master/create_swap.sh
sudo bash create_swap.sh -s=1024 -p=/swapfile
```

#### Options
- -s | --size :  Length for range operations, in Megabytes
- -p | --path :  Swap file. (Default: /swapfile)
- -f | --force: If you already have swap, delete it and create it again.


## Settings
### Basic
```
wget https://raw.githubusercontent.com/x-shell-codes/swap/master/setting_swap.sh
sudo bash setting_swap.sh
```

### Advanced
```
wget https://raw.githubusercontent.com/x-shell-codes/swap/master/setting_swap.sh
sudo bash setting_swap.sh -s=60 -p=80
```

#### Options
- -s | --swappiness: vm.swappiness value. (Default: 10)
- -p | --pressure  :   vm.vfs_cache_pressure value. (Default: 50)


## Removing
### Basic
```
wget https://raw.githubusercontent.com/x-shell-codes/swap/master/remove_swap.sh
sudo bash remove_swap.sh
```

### Advanced
```
wget https://raw.githubusercontent.com/x-shell-codes/swap/master/remove_swap.sh
sudo bash remove_swap.sh -p=/swapfile
```

#### Options
- -p | --path: Swap file. (Default: /swapfile)


## Attentions
* When creating a swap area, there must be enough space for the file to be created.
* DO NOT RUN THIS SCRIPT ON YOUR PC OR MAC!

## Security Vulnerabilities

If you discover a security vulnerability within project, please send an e-mail to Mehmet ÖĞMEN via [www@mehmetogmen.com.tr](mailto:www@mehmetogmen.com.tr). All security vulnerabilities will be promptly addressed.

## License
Copyright (C) 2022 [Mehmet ÖĞMEN](https://github.com/X-Adam)
This work is licensed under the [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/)  
Attribution Required: please include my name in any derivative and let me know how you have improved it!
