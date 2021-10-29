# Contributing

## Via GitHub Codespaces

The easiest way to get started contributing to this project is [by creating a new codespace](https://docs.github.com/en/codespaces/getting-started/quickstart#creating-your-codespace).

After your codespace is ready, open a new integrated terminal and go to the example project:

```
cd ./feedback/example
```

Then download all dependencies and start the flutter web server:

```
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=3000
```

> **Note:** A popup will show up in the lower right corner notifying you that your application is ready and running on port 3000. **The "Open in browser" link will only work _after_ the compilation has succeeded!** 
> 
> When you see an error page, wait until the compilation succeeds and refresh the browser tab. Otherwise you may need to go to the "PORTS" menu next to the VS Code terminal and click on the little browser icon that appears next to the local address when you hover over the entry for port 3000.

Changes in the library or the example applications are reflected after hot restarting and reloading the browser tab.
