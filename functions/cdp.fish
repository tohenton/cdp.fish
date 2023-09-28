function rpath --description "Show a project path under repo"
    set -l argv1 (status function)
    if test (count $argv) -eq 0
        __echo_error "$argv1: missing argument"
        __echo_error "Usage: $argv1 REPO_PROJECT_NAME"
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

    set -l safe_arg (string escape -- $argv[1])
    echo (repo manifest | grep $safe_arg | string match -r 'path="[^"]*' | string replace 'path="' '')
    return 0
end

function cdp --description "cd with project name under repo"
    if test (count $argv) -eq 0
        if not __is_repo_initialized
            __echo_error "fatal: not a repo tree"
            return 1
        end
        cd (__find_repo_root)
        return 0
    end

    set -l repository_path (rpath $argv[1])
    if test $status -ne 0
        return 1
    end

    if test -z $repository_path
        __echo_error "$argv[1] is missing"
        return 1
    end

    cd $repository_path
end

function __is_repo_initialized
    if repo help | grep -q "repo is not yet installed"
        return 1
    else
        return 0
    end
end

function __find_repo_root
    set -l current_dir (pwd)
    while test $current_dir != "/"
        if test -d $current_dir/.repo
            echo $current_dir
            return 0
        end
        set current_dir (dirname $current_dir)
    end
    return 1
end

function __echo_error
    echo $argv[1] > /dev/stderr
end
