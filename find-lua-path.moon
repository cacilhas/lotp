for path in package.path\gmatch "[^;]+"
    if path\match "/share/lua/"
        path = path\gsub "^(.+)/[^/]*$", "%1"
        path = path\sub 0, #path - 1 if path\match "?$"
        io.write path
        os.exit 0

error "could not determinate shared directory"
