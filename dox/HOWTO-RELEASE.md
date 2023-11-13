# HOWTO-RELEASE mulle-objc

In theory mulle-objc is separate from mulle-sde and mulle-c/concurrent/core and
also from MulleFoundation. But it ain't so in praxis. API changes in lower
libraries affect changes in upper libraries and changes in mulle-sde affect
changes in the cmake files (sometimes). This means one has to release
everything in one swoop.

Changes in the cmake files are mostly due to `mulle-sde upgrade`, which
often adds functionality. It is desirable IMO to have an up-to-date mulle-sde
project for all projects, so a small push of all is required, if there are
changes anyway. This also means, that a small patch increment, is to be done
on all projects. Most of this can be automated.

## Order

1. mulle-sde
2. mulle-clang
2. mulle-c
3. mulle-concurrent
4. mulle-core
5. mulle-objc
6. MulleFoundation
7. MulleWeb
8. MulleUI


## Prepare for prerelease

Use `mulle-project-all --repos-file PUBLIC_REPOS` or a simple loop over the
repositories to perform multiple actions on all repositories.
A project can contain one or more test directories, which by themselves are
little projects. And then there is MulleObjCOSFoundation which contains subprojects. `mulle-project-all --repos-file PUBLIC_REPOS` can
iterate through them all.

Create a file `PUBLIC_REPOS` with the paths for all projects to publish.
Place them into the proper order:

```
mulle-c/mulle-c11
mulle-c/mulle-allocator
mulle-c/mulle-buffer
...
MulleWeb/mulle-web-developer
```

### Check that remotes are setup properly

We need one remote "origin" and one "github". Make sure that the URLs are
correct. When copying repositories for the sake of creating another project,
you may have URLs pointing into the old project. Which is not good!

```
mulle-project-all --repos-file PUBLIC_REPOS --lenient --project-only \
   git remote -v
```

Setup repositories on github for those project that don't have one yet.
Set the license to BSD3 usually and then merge the changes:

```
git remove add git@github.com/MulleFoundation/Whatever.git
git pull --allow-unrelated-histories github master
```

### Check that sourcetrees pass minimal sanity checks

```
mulle-project-all --if-exists-file .mulle/etc/sourcetree/config \
   mulle-project-sourcetree-doctor
```


### Check for changes in the github release branch

In theory there could be some patches there. Sometimes the image bot compresses
PNGs. Quite often there might be wording fixes in the `README.md`, that we
don't want to lose.

```
mulle-project-all --repos-file PUBLIC_REPOS --lenient --project-only \
   git pull --ff-only  github release
```

If there is no release branch there, it's not a problem. But if there isn't
a git repository at all, make sure that you have a "github" and "origin"
remote.

> #### Remedies to Observed Problems
>
> * merge manually on
>
> ```
> fatal: Not possible to fast-forward, aborting.
> ```
>
> * create repo on
>
> ```
> fatal: 'github' does not appear to be a git repository
> ```


### Check git status and commit changes

Add files that are missing. Ideally everything should be in `.gitignore` or
deleted:

```
mulle-project-all ---repos-file PUBLIC_REPOS --project-only \
   git status -s
```

All projects should be committed to "master" after this point, with proper
commit messages for the `RELEASENOTES.md`.

Now we can be sloppy with commit messages, which is important to keep things
moving at some pace.


### Tag the pre-prelease state

This may or may not be helpful later on. When we know the last committed
stage, we can later squash all the little "fix" commits into one for release:


```
mulle-project-all --project-only --repos-file PUBLIC_REPOS \
   git tag -f pre-prelease
```

### Upgrade all projects

Running this multiple times is harmless, with one caveat (see:
Upgrade all projects again)

```
mulle-project-all --repos-file PUBLIC_REPOS \
   mulle-sde upgrade
```

#### Use local symlinks to fetch dependencies.

I use a file in `~/bin/post-mulle-sde-init.sh` to set the
`MULLE_FETCH_SEARCH_PATH` to all the local folders, where dependencies
reside. It looks like this:

```
#! /bin/sh

SEARCH_PATH='/home/src/srcO/mulle-c'
SEARCH_PATH="${SEARCH_PATH}:/home/src/srcO/mulle-core"
SEARCH_PATH="${SEARCH_PATH}:/home/src/srcO/mulle-concurrent"
SEARCH_PATH="${SEARCH_PATH}:/home/src/srcO/mulle-objc"
SEARCH_PATH="${SEARCH_PATH}:/home/src/srcO/mulle-objc-ports"
SEARCH_PATH="${SEARCH_PATH}:/home/src/srcO/MulleFoundation"
SEARCH_PATH="${SEARCH_PATH}:/home/src/srcO/MulleWeb"

mulle-env \
      --search-nearest \
   environment \
      --host \
      set \
         MULLE_FETCH_SEARCH_PATH "${SEARCH_PATH}:\${MULLE_FETCH_SEARCH_PATH}"

```

This needs to be executed everywhere. It places a "per-host" environment
setting (which will not be part of the commited files) into `.mulle/etc/env`:


```
mulle-project-all --repos-file PUBLIC_REPOS \
   ~/bin/post-mulle-sde-init.sh
```

#### Wipe global (per-host) caches

Wipe all the mirrors and archives, just to sure that we are consistent and up
to date and that archives are still available.
Go to any mulle-sde project and clean. Archive and mirror are global, so
only do this once:

```
mulle-sde -v -f clean archive
mulle-sde -v -f clean mirror
```

#### Clean all projects with tidy

To get projects to refetch, clean them "tidy". This is a little awkward,
because we need to run `test clean tidy` for test projects. (Might change
this in the future):

```
mulle-project-all --repos-file PUBLIC_REPOS --no-tests \
   mulle-sde clean tidy

mulle-project-all --repos-file PUBLIC_REPOS --tests-only \
   mulle-sde test clean tidy
```

#### Fetch all projects

In order to use the parallel build feature, local projects have to be complete
so its a good time to fetch them into completeness:


```
mulle-project-all --repos-file PUBLIC_REPOS ---project-only \
   mulle-sde test fetch
```


### Build all projects with scan-build to catch more problems

Also check that remote fetched projects are third party only (like `expat` for
instance). If the aren't go back to "local symlinks":

```
mulle-project-all --repos-file PUBLIC_REPOS --project-only \
   mulle-sde craft --clean --analyze
```


### Test all projects

Use various sanitizers. On macOS we don't have valgrind, but there there is a
malloc checker library, that's used by default. Run this on all supported
platforms .


Force usage of "mulle-clang" as CC with `-DCC=mulle-clang`, if the default
compiler isn't clang or doesn't have sanitizer support built in:

```
for sanitizer in --valgrind \
                 --sanitize-address \
                 --sanitize-thread \
                 --sanitize-undefined
do
   mulle-project-all --repos-file PUBLIC_REPOS --tests-only \
      mulle-sde test clean all

   mulle-project-all --repos-file PUBLIC_REPOS --tests-only \
      mulle-sde -DCC=mulle-clang -v test ${sanitizer} || break
done
```

Library             | Known problems
--------------------|----------------------------
`mulle-allocator`   | can not be tested with valgrind or any other sanitizer
`mulle-objc-compat` | can not be used with the sanitizers, as the test is script based.


### Freshen extensions

Some extensions get installed, but may stale away, as a mulle-sde upgrade
won't update files in the project outside of share and reflect folders.

For example outside of the various `-developer` folders, there are probably
untouched but stale github actions. Freshen them like this (it's harmless
if the extension is not installed):

```
mulle-sde extension freshen github-actions
```

### Test all projects


## Create a prerelease

Now we know, that we are "reasonably" bug-free. We also know, that
external dependencies can be fetched and built. There are likely a lot of files
in the projects, that have been modified or have been created.

So far we haven't committed anything. We still need to bump the version number
amongst other things. We haven't create a release tag yet, nor should we have
done this.


### Update the environment-host-ci-prerelease.sh files

A push into github triggers an action. The github action (CI) of the
`prerelease` needs to use the prerelease branches of mulle-sde, mulle-c and so
forth.

The CI script in `.github/frameworks` "fakes" a host `ci-prerelease` for
actions on the prerelease branch. This fake host has its own environment
settings inside each project. These settings redirect the
dependencies, by changing the URL, branch and nodetype
(in effect changes from fetching a release archive to cloning a prerelease
git branch).

It's assumed you followed the directions step by step, so all repositiories and
tests are fetched and up to date, otherwise the produced files will be
incomplete:

```
mulle-project-all --repos-file PUBLIC_REPOS --lenient \
   mulle-project-ci-settings --mulle

mulle-project-all --repos-file PUBLIC_REPOS --lenient \
   git add .mulle/etc/env/environment-host-ci-prerelease.sh
```

> #### Severe pain point
>
> Remember for prerelease (only): Whenever you change the sourcetree of this
> project or change something relevant in the sourcetree of **any**
> recursive dependency, you have to **recreate** the
> `environment-host-ci-prerelease.sh` file of the project and also of the test
> and possibly some other subprojects. That involves a `clean tidy` and a
> `test clean tidy`. Then fetch all the dependencies anew and then you can
> execute another run of `mulle-project-ci-settings --mulle`.
>
> This is the most inconvenient part of the release process, as its slow and
> easy to forget.


### Check project version status

This is a command you will run repeatedly. You want all projects to either
say 'Project version needs a bump, as there are commits' or
'Project has never been tagged, so version is probably OK'. Everything else
means, that you still have commits to do before proceeding to prerelease!

```
mulle-project-all -l -m mulle-project-version --status
```

### Increment project versions for minor change

Incrementing project versions is a step one should do manually for each
project, that has API changes. For bug-fixes and other small changes, where
just the version patch is incremented, we can automate. Check the versions
of all projects:

```
mulle-project-all --repos-file PUBLIC_REPOS -v --project-only \
   mulle-project-version
```

The output for each project will be like this:

```
---------------------
mulle-dispense
---------------------
Version is 2.0.2. Last git tag is "2.0.1".
Last RELEASENOTES.md version is 2.0.2
2.0.2
```

Use `mulle-project-version ++` to update the version patch for mulle-sde
upgrades and bugfixes,

Use `mulle-project-version --increment-minor --write` for an API addition.


Use `mulle-project-version --increment-major --write` for an API change.


If you know that there aren't any API changes anymore
you can get sloppy with:

```
mulle-project-all -r PUBLIC_REPOS -v -m \
  mulle-project-version ++ --if-needed
```

This will bump only those project versions, that need it, due to commits
that aren't in the last git tag. Projects that haven't changed remain,
unaffected.


### Upgrade projects that check that project version

> MEMO...


Now projects may have changed and we have to loop back to
"Check project version status" until there are no more changes.


### Run mulle-project-versioncheck on selected projects

*mulle-container* currently is the only repository with an auto-generated
versioncheck. Freshen the file with:

```
mulle-project-versioncheck --reflect
```

Consider moving this more projects, since there checks stale away quickly.

### Push prerelease branch of mulle-sde

> **mulle-sde** only, don't push C/Objective-C projects yet.

Non-matching `RELEASENOTES.md` version is not a deal-breaker. If the git
tag is matching the version, you either tagged too early or you didn't up the
version. (Only OK, if nothing really changed).


### Run Github Actions locally on the mulle-c/mulle-c11 project

> MEMO:ignore act for now, it's too tricky to get files that work on 
> act and on github (`if: ${{ ! env.HAVE_MULLE_SDE }}`)
>
> This step is useful to get the prerelease mulle-sde running properly.
> If testing repositories locally with **act** you have to remember, that
> only files are copied that aren't ignored by `.gitignore`.

You can run github actions locally with [act](https://github.com/nektos/act)
on github **committed** repositories, but it's a little special.

To fake the proper branch (we need "prerelease") use the `-e` option
of `act`, we may also need to map ubuntu-latest, to what github says is latest
and not what act thinks:

```
act -P ubuntu-latest=catthehacker/ubuntu:act-20.04 -e <(cat <<EOF
{
   "push": {
        "ref": "refs/tags/prerelease"
   }
}
EOF
)
```

The "prerelease" is required for mulle-sde
[github-ci](https://github.com/mulle-sde/github-ci/blob/main/install.sh) to
pickup the proper prerelease version of **mulle-sde**.

Also ensure that the apt-get code needed for act only, installs what we need
`.github/workflows/mulle-sde-ci.yml`:

```
- name: Update stuff (for act)
  if: env.ACT
  run: apt-get update

- name: Install stuff (for act)
  if: env.ACT
  run: apt-get -y install cmake git curl lsb-release uuid-runtime
```

Pick a small working project like [mulle-mmap](//github.com/mulle-core/mulle-mmap) and
run aforementioned `act -v -e prerelease.json` command on it. This way you can
iterate on **mulle-sde** until it installs to a satisfactory level.


### Build compiler images and push them

For the tests to run, we need the newest compiler.
A new compiler archive is not a biggy, since the old compiler will still
be available.

We need the proper images for ubuntu and macOS. What OS versions they are,
needs to be determined on a per-release basis, these versions are moving targets.

#### Linux

The compiler is build for debian, which is compatible with ubuntu. But there
are less versions to worry about.

Figure out the [debian version](https://askubuntu.com/questions/445487/what-debian-version-are-the-different-ubuntu-versions-based-on) for
**ubuntu-latest** with `cat /etc/debian_version`. **ubuntu-latest** is, what we
use in the github wokflow CI. Create a VM for the proper debian version
(e.g. "bullseye"), if it don't exist.

Use [mulle-clang-cpack]() to build a release candidate compiler. Checkout the
README.md, if you use a fresh VM.

Ideally this command will do everything, but be sure that the prequisites are
installed: [install-prerequisites](https://raw.githubusercontent.com/Codeon-GmbH/mulle-clang-project/mulle/12.0.0/clang/bin/install-prerequisites)

```
RC=1 VERSION=12.0.0.0 ./create-deb "bullseye"
```

#### macOS

Figure out the OS version to build for **macos-latest**. At time of writing
this was **catalina** (though big-sur is available already).

Get a **catalina** VM happening (maybe with [macOS-Simple-KVM](//github.com/foxlet/macOS-Simple-KVM))

Check that the prequisites are installed: [install-prerequisites](https://raw.githubusercontent.com/Codeon-GmbH/mulle-clang-project/mulle/12.0.0/clang/bin/install-prerequisites).

We will use a homebrew formula to build a bottle. Use a formula like this
or better check the most recent one that was published:

```
class MulleClangProject < Formula
  desc "Objective-C compiler for the mulle-objc runtime"
  homepage "https://github.com/Codeon-GmbH/mulle-clang-project"
  license "BSD-3-Clause"
  version "12.0.0.0"
#  revision 1
  head "https://github.com/Codeon-GmbH/mulle-clang-project.git", branch: "mulle/12.0.0"

#
# MEMO:
#    0. Replace 12.0.0.0 with x.0.0.0 your version number (and check vendor)
#    1. Create a release on github
#    2. Download the tar.gz file from github like so
#       `curl -O -L "https://github.com/Codeon-GmbH/mulle-clang/archive/12.0.0.0.tar.gz"`
#    3. Run shasum over it `shasum -a 256 -b 10.0.0.2.tar.gz`
#    4. Remove bottle urls
#
  url "https://github.com/Codeon-GmbH/mulle-clang-project/archive/refs/tags/12.0.0.0.tar.gz"
  sha256 ""

  def vendor
    "mulle-clang 12.0.0.0 (runtime-load-version: 17)"
  end

#
# MEMO:
#    We need a local tap nowadays to build locally:
#
#    brew new-tap codeon-gmbh/software (or some such)
#    # mulle-clang-project.rb is this file
#    cp mulle-clang-project.rb /usr/local/Homebrew/Library/Taps/codeon-gmbh/homebrew-software/Formula/
#
#    For each OS X version, create bottles with:
#
#    `brew uninstall codeon-gmbh/software/mulle-clang-project`
#    `brew install --formula --build-bottle mulle-clang-project.rb`
#    `brew bottle --force-core-tap mulle-clang-project.rb`
#    `mv ./mulle-clang--12.0.0.0.catalina.bottle.tar.gz  ./mulle-clang-12.0.0.0.catalina.bottle.tar.gz`
#
#    Upload to github:
#
#     scp -i ~/.ssh/id_rsa_hetzner_pw \
#            ./mulle-clang-12.0.0.0.catalina.bottle.tar.gz \
#            codeon@www262.your-server.de:public_html/_site/bottles/
#
  bottle do
    root_url "https://github.com/Codeon-GmbH/mulle-clang-project/releases/download/12.0.0.0"

    sha256 cellar: :any, catalina: "279ae722f43d39c2cd4600caec7a0f335565e0e226b43b7dcd8d98a3b249a965"
  end

  depends_on 'cmake'   => :build
  depends_on 'ninja'   => :build

  #  compiler_rt doesn't build on macos
  def install
    mkdir "build" do
      args = std_cmake_args
      args << '-DLLVM_ENABLE_PROJECTS=libcxxabi;libcxx;clang'
      args << '-DCMAKE_BUILD_TYPE=Release'
      args << '-DCLANG_VENDOR=mulle'
      args << '-DCMAKE_INSTALL_MESSAGE=LAZY'
      args << "-DCMAKE_INSTALL_PREFIX='#{prefix}/root'"
      args << '../llvm'

      system "cmake", "-G", "Ninja", *args
      system "ninja", "install"
    end
    bin.install_symlink "#{prefix}/root/bin/clang" => "mulle-clang"
    bin.install_symlink "#{prefix}/root/bin/scan-build" => "mulle-scan-build"
  end

  def caveats
    str = <<~EOS
    To use mulle-clang inside homebrew formulae, you need a shim.
    See:
       https://github.com/Codeon-GmbH/mulle-clang-homebrew
    EOS
    str
  end

  test do
    system "#{bin}/mulle-clang", "--help"
  end
end
```

### Update mulle-objc/github-ci

This needs to be updated with a new version number for the compiler.
Create a new tag "v2" or so and then... change it in all project files, that
are based on mulle-objc.

```
mulle-project-all --repos-file PUBLIC_REPOS --no-tests \
  mulle-replace -n -v 'mulle-objc/github-ci@v1' 'mulle-cc/github-ci@v4' \
                      .github/workflows/mulle-sde-ci.yml
```

### Push prerelease branches of everything

One more time check, that everything looks good:

```
mulle-project-all --repos-file PUBLIC_REPOS --project-only \
   mulle-project-version --status

mulle-project-all --repos-file PUBLIC_REPOS --project-only \
   git status -s --untracked-files=no
```

Version number mismatches are what we are looking for. It's bad, if a
version needs to be changed. Also at this point the modified files, should
only be generated stuff (.mulle, cmake, reflect).

Now we can be sloppy. We just commit everything that's not committed with
some uninformative message. The previous "prerelease" contents will be
clobbered. This is is instrumental to keep the process clean. We don't want
to merge accidental, outdated commits here:

```
mulle-project-all --repos-file PUBLIC_REPOS --lenient --project-only \
   mulle-project-git-prerelease --mulle
```

This can be repeated again and again.


### Rerun all tests locally with host "ci-prerelease"

This will catch a lot of problems early, if wrong non-prerelease versions
are fetched. And it's faster than doing a full `act` run:

```
mulle-project-all --tests-only --parallel \
   MULLE_HOSTNAME="ci-prerelease" mulle-sde test clean tidy

mulle-project-all --tests-only \
   MULLE_HOSTNAME="ci-prerelease" mulle-sde test craft
```

### Create dockers for act

To make act running locally more bearable for future act calls, create a custom
docker that incorporates the apt-get calls and the mulle-objc install:

```
mkdir act
cat <<EOF > act/Dockerfile
FROM catthehacker/ubuntu:act-20.04

ENV HAVE_MULLE_OBJC=1

RUN DEBIAN_FRONTEND=noninteractive \
      apt-get update \
   && apt-get -y install cmake ninja-build build-essential uuid-runtime bsdmainutils wget \
\
   && wget "https://github.com/Codeon-GmbH/mulle-clang-project/releases/download/12.0.0.0-RC2/mulle-clang-12.0.0.0-bullseye-amd64.deb"  \
   && dpkg --install "mulle-clang-12.0.0.0-bullseye-amd64.deb"
EOF

docker -t mulle-objc:act ./act
```

> #### Tip create another mulle-sde docker
>
> It maybe also good to have mulle-sde already in there (for non -developer
> repositories).


### Build foundation-developer with prerelease mulle-sde

This will pretty much exercise everything (except tests):

```
cd MulleFoundation/Foundation
act -v -P ubuntu-latest=mulle-objc:act  -e <( echo '{"push": { "ref": "refs/tags/prerelease" } }' )
```

### Build everything with act


### Repeat until done

If you need to fix settings in the dependencies (sourcetree) or the
`Update the environment-host-ci-prerelease.sh files`, loop back to the
begging of this chapter.


## Release

This where things go "live". Pushes go to `release`, tags are being set.
Packages and formula appear in the official places.


### Update the RELEASENOTES.md

```
mulle-project-all --repos-file PUBLIC_REPOS --project-only --lenient \
   mulle-project-releasenotes RELEASENOTES.md
```

### Upgrade all projects

This is more or less a beauty thing, but the version number of the
various `mulle-sde-developer`, `mulle-objc-developer` extensions will likely
have been changed by the previous steps. Now you have projects with outdated
**mulle-sde** extension version numbers.

So do this at the very, very last moment, when all RELEASENOTES.md have been
written and everything is committed (but not tagged yet).

```
mulle-project-all --repos-file PUBLIC_REPOS --lenient \
   mulle-sde upgrade

mulle-project-all --repos-file PUBLIC_REPOS --project-only --lenient \
   git add -u

mulle-project-all --repos-file PUBLIC_REPOS --project-only --lenient \
   git commit --amend --no-edit
```

> #### MEMO
>
> Currently the main project version is replicated into each extension
> version file. That need not be. It should be possible to check, if files
> of an extension have changed and only bump that version, if needed. This
> would save a lot superflous changed versions.

## Release

### Push mulle-bashfunctions to release


```
mulle-project-distribute
```

### Push mulle-sde to release

This should now effortless push everything:

```
cd mulle-sde
mulle-project-all --repos-file PUBLIC_REPOS --project-only \
   mulle-project-distribute
```

### Push mulle-c/mulle-concurrent/mulle-core to release


### Release compiler (apt/homenbrew)


### Release mulle-objc

### Release MulleFoundation

### Release MulleWeb


## use mulle-project-release-entry -p "<lastreleasedate>"

To create entries for the announcement.

