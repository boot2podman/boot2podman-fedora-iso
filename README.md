<a name="creating-a-boot2podman-fedora-iso"></a>
# Boot2podman Fedora ISO

This repository contains all the instructions and code to build a Live ISO based on Fedora
which can be used by [podman-machine](https://github.com/boot2podman/machine) as an alternative to
the Boot2podman ISO.

----

<!-- MarkdownTOC -->

- [Building the Fedora ISO](#building-the-fedora-iso)
	- [On Fedora](#on-fedora)
		- [Prerequisites](#prerequisites)
		- [Building the ISO](#building-the-iso)
	- [On hosts _other than Fedora_ \(OS X, Windows, CentOS ...\)](#non-fedora-hosts)
		- [Prerequisites](#prerequisites-1)
		- [Building the ISO](#building-the-iso-1)
  - [Manual release](#manual-release)
- [Further reading](#further-reading)
- [Community](#community)

<!-- /MarkdownTOC -->

----

<a name="building-the-fedora-iso"></a>
## Building the Fedora ISO

The following contains instructions on how to build the Fedora based ISO.
If you are able to install [livecd-tools](https://github.com/rhinstaller/livecd-tools)
directly on your machine, you can use the [Fedora](#on-fedora) instructions.

If you don't have _livecd-tools or using different linux distro other than Fedora_, follow the
[hosts other than Fedora](#non-fedora-hosts) instructions.

<a name="on-fedora"></a>
### On Fedora

<a name="prerequisites"></a>
#### Prerequisites
* Update your system before start and if there is kernel update then reboot your system to activate latest kernel.

        $ dnf update -y

* [Install livecd-tools](https://github.com/rhinstaller/livecd-tools)


<a name="building-the-iso"></a>
#### Building the ISO

```
$ git clone https://github.com/boot2podman/boot2podman-fedora-iso.git
$ cd boot2podman-fedora-iso
$ make
```

<a name="non-fedora-hosts"></a>
### On hosts _other than Fedora_ (macOS, Windows, CentOS ...)

<a name="prerequisites-1"></a>
#### Prerequisites

* [Vagrant](https://www.vagrantup.com/)
* [vagrant-sshfs](https://github.com/dustymabe/vagrant-sshfs)

        $ vagrant plugin install vagrant-sshfs

<a name="building-the-iso-1"></a>
#### Building the ISO

```
$ git clone https://github.com/boot2podman/boot2podman-fedora-iso.git
$ cd boot2podman-fedora-iso
$ vagrant up
$ vagrant ssh
$ cd <path to boot2podman-fedora-iso directory on the VM>/boot2podman-fedora-iso
$ make
```

<a name="manual-release"></a>
### Manual release

The manual release includes following steps:

- Assemble all the meaningful changes since the last release to create release notes.
- Bump the `VERSION` variable in the Makefile.
- Before you execute below command be sure to have a [Github personal access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use) defined in your environment as `GITHUB_ACCESS_TOKEN`.
- Run following command to perform release:

  ```shell
  $ make release
  ```

#### Build ISO

Setup your build environment by following the instructions provided in [Building the Fedora ISO](#building-the-fedora-iso) section as per your preferred OS.

Note: Building ISO might require you to have Vagrant environment if you are not using host other than Fedora.

<a name="further-reading"></a>
## Further reading

Once you are able to build the ISO, you are most likely interested to modify the
image itself. To do so you have to get familiar with
[pykickstart](https://github.com/rhinstaller/pykickstart/blob/master/docs/kickstart-docs.rst).

<a name="community"></a>
## Community

You can reach the Podman community by:

- Joining the `#podman` channel on [Freenode IRC](https://freenode.net/)
