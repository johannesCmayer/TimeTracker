#!/usr/bin/fish

set data_dir "$HOME/time_tracker"
set log_file "$data_dir/times.csv"

[ ! -d $data_dir ] && mkdir $data_dir

function git-commit
    begin
        cd $data_dir
        git add .
        git commit -m "-"
    end > /dev/null
end

function show
    trks
    echo "========================================"
    tail $log_file
end

if [ "$argv[1]" = show ]
    show
    exit 0
else if [ "$argv[1]" = edit -o "$argv[1]" = ed ]
    vi $log_file
    git-commit
    show
    exit 0
else
    echo (date '+%z  %Y-%m-%d  %H:%M:%S'), $argv >> $log_file
    git-commit
    show
    exit 0
end
