# plan42-ai/xml

This is a fork of the go standard library encoding/xml package, extracted into a standalone library, as of go 1.25.5.

The contents of this repo were extracted using:

```
git clone https://github.com/golang/go.git go-upstream
cd go-upstream
git checkout -b 1.25.5 go1.25.5

git filter-repo \
    --subdirectory-filter src/encoding/xml \
    --path PATENTS \
    --path LICENSE \
    --force
```


## What's the motivation for a fork?

Go's xml.Marshal doesn't support emitting empty tags. It will always generating something like `<true></true>`
rather than `<true/>`. That's because it's easier to emit an open tag followed by a close tag (fewer special cases)
and the two forms are supposed to be semantically equivalent. 

However, we want to use this to generate Apple LaunchCtrl agents, which are described via xml "plist" fiels.
Apple's launchctl implementation, however, won't parse `<true></true>`. It requires empty tags ('<true/>').

The fork allows us to add support for omitting empty tags to the library, without having to fork the entire go runtime.
Using `git filter-repo` gives us only the contents of encoding/xml, but with all the git history preserved.

## Why bother? Why not just use a string builder or sprintf?

It's usually a bad idea to generate executable artifacts (like launchctl plists) using string manipulation functions,
because they make it very easy to introduce injection / xss vulnerabilities.

Generating structs, and then marshaling them with a standard conformant encoder ensures that you can embed tainted
user data in executable artifacts and things will be escaped properly.

This is the same pattern go libraries use for json, yaml, toml, sql, and xml. 

The only issue is that the built-in xml library is missing a feature we need. 

It also turns out that other people have implemented fixes, and we can just steal their fixes and add them to our fork,
so we can do the right thing without much effort.

## Ok. Why not just send a PR to google?

Google doesn't seem very interested in fixing this.
This has been broken since at least 2012, and they keep ignoring PRS and Proposals people send them:

* https://groups.google.com/g/golang-nuts/c/guG6iOCRu08
* https://go-review.googlesource.com/c/go/+/59830 
* https://go-review.googlesource.com/c/go/+/469495
* https://github.com/golang/go/issues/69273

There's been no movement from the go maintainers for 14 years, despite several prs from different people.

The hardest part about this fork has been writing this readme. It will take 5 mins to make it work,
whereas getting the go team to take action on this could take 20 years.

## How are branches organized?

We use the go version the library is extracted from as the branch name. The default branch is then set to the latest
such branch. For example 1.25.5 is the branch for the library derived from go 1.25.5.

If / when we rebase on top of a new version of the library, we will re-extract the code into a new branch,
(for example 1.26.0), cherry-pick our changes to that branch, then update the default branch to be the latest one.

To make the semantic versioning work, our changes will then be released as patches on top of the go version.
For example v1.25.5-1, v.1.25.5-2, etc.

## What about all the fomo you might be feeling? Won't this diverge from the go standard library over time?

Probably. We care enough to make sure we use secure coding practices, but not enough to spend a lot of time watching
the tip of the go library. We are ok with that though. 

XML is icky, and it's not something we would ever use by choice.

If there's something you need from the standard lib that is missing, just ping us and we can probably pull it in.
