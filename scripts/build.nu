#!/usr/bin/env nu

ls | where type == "file" | sort-by modified
