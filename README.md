# z-alda

Playing with [Alda](https://alda.io/)

---

## [Justfile](https://just.systems/man/en/)

### Test

```console
just t
```

### Play file

```console
just r <FILE>
```

---

## Or run by setting up environment

### 1. Setup

```console
source ./setup.sh
```

### 2. Play file

```console
alda play --file <FILE>
```

#### Hello World

```console
alda play --file examples/hello_world.alda
```

#### Z.alda

```console
alda play --file examples/z.alda
```

---

## References

-   [alda.io](https://alda.io/)
-   [alda-lang/alda GitHub](https://github.com/alda-lang/alda)
    -   [List of Instruments](https://github.com/alda-lang/alda/blob/master/doc/list-of-instruments.md)
    -   [Installing a good soundfont](https://github.com/alda-lang/alda/blob/master/doc/installing-a-good-soundfont.md)
    -   [Editor Plugins](https://github.com/alda-lang/alda/blob/master/doc/editor-plugins.md)
