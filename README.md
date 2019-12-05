Disclaimer
----------

Using nightly (or even more often) built CI images and forcing your cluster to upgrade to them
can break your cluster and this project was more out of curiosity than something actually usable.

Requirements
------------
- Python >= 3.6

Usage
-----

Run the `get_metadata.py` with python 3:

```
python3 get_metadata.py
```

This will create a `cache/` folder and a `metadata.json` in the current folder.

The cache will be used to prevent calls to the image registry 
after the image tag information has once been downloaded.

The metadata file will contain the update stream information wanted by Openshift 4.
This file should be stored on some web server accessible to the Openshift cluster.


Cluster upgrades
----------------

There are also scripts `update.sh` and a higher level script `update_loop.sh` which can be
used to upgrade the cluster. This is because the upgrades required a few more manual steps
because the CI built images are not signed or are missing some other information which
means that the CVO needs some convincing to use them to update.

Example metadata
----------------

```
{
  "nodes": [
    {
      "version": "4.2.0-0.okd-2019-10-26-063455",
      "payload": "registry.svc.ci.openshift.org/origin/release@sha256:1c842940aea6c0d0d0da772ffd7f08cfd8d6a5eb63477ce643b8fdcb8c4ec955"
    },
    {
      "version": "4.2.0-0.okd-2019-10-28-040635",
      "payload": "registry.svc.ci.openshift.org/origin/release@sha256:e8f16cc5fc5d653e284c7ad0df70c2add02d26aebdcf7b760d6e82d92c0e4845"
    },
    {
      "version": "4.2.0-0.okd-2019-10-29-035958",
      "payload": "registry.svc.ci.openshift.org/origin/release@sha256:0411230528645d2195f6684b385ced0a3a07311326e1a92efb59318369429f09"
    }
  ],
  "edges": [
    [
      0,
      1
    ],
    [
      1,
      2
    ]
  ]
}
```
