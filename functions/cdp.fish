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
    if not __is_repo_initialized
        __echo_error "fatal: not a repo repository: .repo"
        return 1
    end

    builtin cd (repo manifest | grep $argv[1] | grep -o 'path="[^"]*' | sed 's/path="//')
    return 0
end

function __is_repo_initialized
    if repo help | grep -q "repo is not yet installed"
        return 1
    else
        return 0
    end
end

function __echo_error
    echo $argv[1] > /dev/stderr
end
