#!/bin/sh

##
## USAGE: ./qs-init.sh --client UNIQUE_SLUG --git-repo GIT_REMOTE [--up]
## Include `--up` when setting up a fresh instance of this VM.
##

# Kicking things off!
printf '\nPreparing to initialize the VIP Go Quickstart environment...\n\n'

# Parse args and set necessary envars
printf '1) Parsing arguments...\n\n'
client=''
client_git_repo=''
wxr=0
needs_to_up=0

while :; do
    case $1 in
        --client)
            if [ -n "$2" ]; then
                client=$2
                shift 2
                continue
            else
                printf 'ERROR: "--client" is a required argument.\n' >&2
                exit 1
            fi
            ;;

        --git-repo)
            if [ -n "$2" ]; then
                client_git_repo=$2
                shift 2
                continue
            else
                printf 'ERROR: "--git-repo" is a required argument.\n' >&2
                exit 1
            fi
            ;;

        --wxr)
            if [ -n "$2" ]; then
                rm data/import.xml
                cp $2 data/import.xml
                wxr=1
                shift 2
                continue
            fi
            ;;

        --up)
            needs_to_up=1
            ;;

        *)
           break
    esac

    shift
done

if [ -z "$client" ]; then
    printf 'ERROR: "--client" is a required argument.\n' >&2
    exit 1
fi

if [ -z "$client_git_repo" ]; then
    printf 'ERROR: "--git-repo" is a required argument.\n' >&2
    exit 1
fi

if [ "$wxr" == 0 ]; then
    git checkout -- data/import.xml
fi

export VIP_GO_CLIENT=$client
export VIP_GO_CLIENT_GIT=$client_git_repo

printf "CLIENT: %s\nGIT REMOTE: %s\nVAGRANT UP REQUESTED: %d\n\n" "$client" "$client_git_repo" "$needs_to_up"

# Load client's custom code into VM's NFS shares
# Can't simply delete `go-client-repo` and replace it, as removing the synced folders sends Vagrant into a tizzy
printf '2) Loading new client code...\n\n'
rm -rf go-client-repo-new/
rm -rf go-client-repo/languages/*
rm -rf go-client-repo/plugins/*
rm -rf go-client-repo/themes/*
git clone "$client_git_repo" go-client-repo-new
cp -r go-client-repo-new/* go-client-repo
rm -rf go-client-repo-new/

# Ensure optional languages directory exists
# Vagrant doesn't respond well if the directory exists sometimes but not always
if [ ! -d "./go-client-repo/languages/" ]; then
    mkdir ./go-client-repo/languages/
fi

# Provision the VM
if [ $needs_to_up == 1 ]; then
    printf '\n3) Starting to provision VM. vagrant up can take some time...\n\n'
    vagrant up
else
    printf '\n3) Starting to re-provision VM...\n\n'
    vagrant provision
fi

# Done!
printf '\n4) DONE!\nYour VIP Go Quickstart is ready at http://go-vip.local/\n'
printf 'Synchronized git checkout is at ./go-client-code/\n'
