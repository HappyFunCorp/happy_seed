HappySeed React Install
=========================

### What does this do?

The happy_seed react generator

* Installs `react_on_rails` as well as npm.

### Why do you want this?

You want to be able to use react within your rails project and `react_on_rails` is great. Consult the docs for this gem [here.](https://github.com/shakacode/react_on_rails). Check out the Hello World react app at `http://localhost:3000/hello_world`. Reference the react_on_rails docs for a detailed explanation. You can start by looking in the `client` folder to see how the Hello World app was built.

### Environment Variables

na

### What needs to be done?

When running the generator, if you notice npm throwing errors like `npmERR! Error: EACCES: permission denied, mkdir`. Run `sudo chown -R $USER:$GROUP ~/.npm`. 
