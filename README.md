Composer ctags
==============

Automatically (re)generates ctag indexes for your composer based PHP project.

Setup
-----

Somewhere your `.vimrc`:
```
set tags+=vendor.tags
```

Run
---

From the project's root directory:

```
docker run -it --rm -v $PWD:/app herzult/composer-ctags
```
