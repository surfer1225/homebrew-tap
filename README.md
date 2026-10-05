# surfer1225/tap

Homebrew formulae for my open-source Mac apps.

```sh
brew install surfer1225/tap/<formula>
```

| Formula | App |
|---|---|
| `lens-window-manager` | [Lens](https://github.com/surfer1225/lens), a keyboard-driven window manager that remembers your layouts |

## How these install

The formulae build from source on your Mac, so you need Xcode. A locally built app is never
quarantined, so Gatekeeper doesn't prompt and no paid Apple Developer account is needed.

Each formula pins its source tag and every dependency to a git commit, and Homebrew builds without
network access, so what gets built is exactly what is pinned here.

Apps install into Homebrew's prefix. The caveats printed after install show how to link them into
`~/Applications`.
