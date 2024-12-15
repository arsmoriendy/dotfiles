# Waybar Configuration

This is the `waybar` configuration directory.

## Initial system specific config

`sysconfig.d/sysconfig.jsonc` should exist.

- Symlink `sysconfig.d/<template>Sysconfig.jsonc`
- Or create `sysconfig.d/sysconfig.jsonc` from scratch

## Transpile SASS/SCSS To CSS Files

> [!info]
> This command will watch for changes in `style.scss` (along with its includes) and transpile it all into `style.css`.
> Before commiting changes, make sure to transpile and include both files.

`sass --watch --no-source-map --style=compressed style.scss:style.css`
