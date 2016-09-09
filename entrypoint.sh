#!/bin/sh

generate_source_tags () {
    echo "Generating source tags"
    rm tags
    ctags --options=/.ctags src
}

generate_vendor_tags () {
    echo "Generating vendor tags"
    rm vendor.tags
    ctags --options=/.ctags -fvendor.tags vendor
}

observe_source () {
    inotifywait -ecreate,delete,modify,move -m -q --format '%f' -r src/ | while read FILE
    do
        jobs -p | xargs kill -9
        (
            sleep 1 # debounce
            generate_source_tags
            echo "$EV"
        ) &
    done
}

observe_vendor () {
    inotifywait -ecreate,modify -m -q --format '%f' composer.lock | while read FILE
    do
        jobs -p | xargs kill -9
        (
            sleep 1 # debounce
            generate_vendor_tags
            echo "$EV"
        ) &
    done
}

observe_source_logs () {
    observe_source > /nohup.out 2>&1&
}

observe_vendor_logs () {
    observe_vendor > /nohup.out 2>&1&
}

build_all_logs () {
    generate_source_tags > /nohup.out 2>&1&
    generate_vendor_tags > /nohup.out 2>&1&
}

build_all_logs &
observe_source_logs &
observe_vendor_logs &

touch /nohup.out
tail -f /nohup.out
