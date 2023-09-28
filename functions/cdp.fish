function cdp --description "cd with project name under repo"
    if [ (count $argv) -eq 0 ]
        __echo_error "cdp: missing argument"
        __echo_error "Usage: cdp REPO_PROJECT_NAME"
        return 1
    end

    # repo command is not installed
    if not type -q repo
        __echo_error "fatal: no repo command installed"
        return 1
    end

    # executed not in repo repository
    if repo help | grep -q "repo is not yet installed"
        __echo_error "fatal: not a repo repository: .repo"
        return 1
    end

    builtin cd (repo manifest | grep $argv[1] | grep -o 'path="[^"]*' | sed 's/path="//')
    return 0
end

function __echo_error
    echo $argv[1] > /dev/stderr
end
