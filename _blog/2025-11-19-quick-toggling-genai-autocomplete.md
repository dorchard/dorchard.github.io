---
layout: blog-post
title: "Quick toggling GenAI autocomplete"
date: "2025-11-19"
categories: [programming, productivity]
excerpt: "A simple keyboard shortcut to quickly toggle GitHub Copilot on and off in VS Code when you want temporary AI assistance."
---

A long-held view amongst programmers is that keeping your hands on the keyboard, using keyboard shortcuts, is much more efficient than
switching to the mouse and back. I certainly find its true for me, so I often seek to codify tasks into keyboard shortcuts.
I've used `emacs` for many years which is great for this as you can programme it in using `elisp` and build up complex macros. But I find
myself increasingly using [VS Code](https://code.visualstudio.com/) for programming these days, and so I've gradually migrated parts of my 
workflow.

With some caution, I find that the latest generative AI coding assistants (via LLMs) can sometimes be useful (a topic for another blog post),
once there is appropriate validation and verification in place. One mode of interaction with such tools is the 'auto complete' style. This
can be useful when working in an unfamiliar language or with an unfamiliar library, or when there is a repeated pattern of code or
something trivial you need doing. But it can also quickly become annoying and more of a hindrance
than a help. I realised that I needed an easy way to toggle gen-AI autocomplete on and off rapidly, without having to waste
time clicking through menus. 

Here's how I do it in VS Code in case it's useful for others:

## Adding the Keyboard Shortcut

Open your `keybindings.json` file in VS Code (you can access it via **Code → Settings → Keyboard Shortcuts**, then click the "Open Keyboard Shortcuts (JSON)" icon in the top right, or opening up the command palette and typing 'keyboard' should reduce the options to show you "Open Keyboard Shortcuts (JSON)").

This file contains a list of keybinding records in JSON format, e.g., `[{...}, {...}]`. Add the following entry anywhere inside the list:

```json
{
  "key": "shift+cmd+;",
  "command": "github.copilot.completions.toggle"
}
```

I've chosen the `Shift+Cmd+;` combination because it's easy to reach for me (and easy to remember) and doesn't overlap with anything else I need. 
I use a couple of Apple Macs hence the use of `Cmd`, but that could easily be `Ctrl` for a non-Mac keyboard; you can of course choose any other combination that suits you better.

So your file should look something like:

```json
[
  {
    "key": "shift+cmd+;",
    "command": "github.copilot.completions.toggle"
  },
  // ... your other keybindings ...
]
```

With this it is easy to toggle the auto complete on to get some help (hopefully just writing some code I was going to write anyway!)
and then I can easily toggle it off when things get annoying (often!), or I really need or want to figure
it out myself. I have it off a lot of the time, but it's useful to be able to flick it on, and then back off again, occasionally. Hope this helps someone! I'm always recommending to students to get proficient with keyboard shortcuts and customising their workflow to be as efficient as possible, to enable focussed work rather than losing time to navigating a UI and context-switch overhead.