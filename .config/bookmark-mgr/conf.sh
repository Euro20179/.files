#!/bin/bash

bookmark_mgr_url_handler () {
    read -r url
    case "$url" in
        *) linkhandler "$url" ;;
    esac
}
