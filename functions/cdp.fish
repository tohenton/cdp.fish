function cdp --description "cd with project name under repo"
    if [ (count $argv) -eq 0 ]
        echo "cdp: missing argument"
        echo "Usage: cdp REPO_PROJECT_NAME"
        return 1
    end

    # repo command is not installed
    if not type -q repo
        echo "fatal: no repo command installed"
        return 1
    end

    # executed not in repo repository
    if repo help | grep -q "repo is not yet installed"
        echo "fatal: not a repo repository: .repo" > /dev/stderr
        return 1
    end

    builtin cd (repo manifest | grep $argv[1] | grep -o 'path="[^"]*' | sed 's/path="//')
    return 0
end
