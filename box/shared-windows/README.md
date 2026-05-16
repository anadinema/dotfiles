# shared-windows

Specifics on how to setup windows machine with git-bash, yak, and templated git commit picker.

## Usage

- Copy `bin` folder as it is and palace it under `C:\Users\<your-username>`
- Add path `C:\Users\<your-username>\bin` to the environment variable `PATH`. More help [here](https://www.wikihow.com/Change-the-PATH-Environment-Variable-on-Windows).
- Copy contents of `etc` folder to `C:\Users\<your-username>` and add `.` as prefix in name of all files and folders directly under `etc` folder.
  - So `bash` becomes `.bash`,  `bashrc` becomes `.bashrc` and `bash_profile` becomes `.bash_profile`
  - This is needed for Git and Windows to recognize these things correctly.
- Now close and reopen your shell, and run `yak generate` to generate the config in TOML format
  - Or you can run `yak generate --format yaml` to generate it in YAML format.
- Once generated, fill in the details and you are good to go.


## Notes

- Git commit picker is still having issues with `bash` shell compatibility. So that does not work right now.
