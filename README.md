# Contabo Command-Line Interface (CLI) 

`cntb` is a command-line interface (CLI) for managing your products from Contabo like VPS and VDS.

This is the fork for **FreeBSD.**

## Installation ( Build from Source )

```shell
pkg install npm go gmake openjdk16
git clone https://github.com/ddowse/cntb
cd cntb
gmake
```

## Getting Started

1. Configure `cntb` once to use your credentials. You can obtain them from [Customer Control Panel](https://my.contabo.com/api/details).

  ```sh
  cntb config set-credentials --oauth2-clientid=<ClientId from Customer Control Panel> --oauth2-client-secret=<ClientSecret from Customer Control Panel> --oauth2-user=<API User from Customer Control Panel> --oauth2-password=<API Password from Customer Control Panel>
  ```

2. Use the CLI, e.g.

```sh
cntb help
```

## Examples

### List available images

```sh
cntb get images
```

### Upload custom image

```sh
cntb create image --name 'CentOS Cloud Image' --description 'CentOS 7 Cloud Image' --url 'https://cloud.centos.org/altarch/7/images/CentOS-7-x86_64-GenericCloud.qcow2' --osType Linux --version 7
```

### Create / order new Compute Instance

Using Cloud-Init to set ssh public key

```sh
cntb create instance --imageId "ae423751-50fa-4bf6-9978-015673bf51c4" --productId "V1" --region "EU" --userData 'ssh_authorized_keys:
  - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAGEA3FSyQwBI6Z+nCSjUUk8EEAnnkhXlukKoUPND/RRClWz2s5TCzIkd3Ou5+Cyz71X0XmazM3l5WgeErvtIwQMyT1KjNoMhoJMrJnWqQPOt5Q8zWd9qG7PBl9+eiH5qV7NZ'
# once finished please login via ssh
# in case of the previously uploaded CentOS 7 Cloud Image please use `centos` as user
# for standard images please use `admin` as user
```

Using Cloud-Init to install apache2 with an already stored SSH public key

```sh
cntb create instance --imageId "ae423751-50fa-4bf6-9978-015673bf51c4" --productId "V1" --region "EU" --sshKeys '1,2' --userData 'package_update: true
package_upgrade: true
packages:
  - httpd'
```

### Start Compute Instance

```sh
cntb start instance 12345
```

### Stop Compute Instance

```sh
cntb stop instance 12345
```

## Enable Shell Completion

```sh
cntb completion
Bash:

        $ source <(cntb completion bash)
        
        # To load completions for each session, execute once with root privileges 
        
        cntb completion bash > /usr/local/share/bash-completion/completions/cntb


Zsh:

        # If shell completion is not already enabled in your environment,
        # you will need to enable it.  You can execute the following once:

        $ echo "autoload -U compinit; compinit" >> ~/.zshrc

        # To load completions for each session, execute once:
        $ cntb completion zsh > "${fpath[1]}/_cntb"

        # You will need to start a new shell for this setup to take effect.

fish:

        $ cntb completion fish | source

        # To load completions for each session, execute once:
        $ cntb completion fish > ~/.config/fish/completions/cntb.fish

```

## Runtime configuration

For `cntb` to work it uses some additional files and directories.

* default file for storing settings / preferences is `~/.cntb.yaml`
* caching directory is `~/.cache/cntb/`

## License

GNU GENERAL PUBLIC LICENSE, Version 3
