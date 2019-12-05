#!/bin/env python3


from subprocess import check_output
import json

repository = 'registry.svc.ci.openshift.org/origin/release'
initial_tag = '4.2'


def read_cache(key):
    with open(f"cache/{key}") as f:
        return f.readline()


def write_cache(key, value):
    with open(f"cache/{key}", 'w') as f:
        f.write(value)


def get_tags(repository, initial_tag):
    tags = json.loads(check_output(['skopeo', 'inspect', f"docker://{repository}:{initial_tag}"]))['RepoTags']
    return [tag for tag in sorted(tags) if tag.startswith('4.2.0-0.okd')]


def get_digest(repository, tag):
    print(f"Getting digest for {tag}", end=' -- ')
    try:
        digest = read_cache(tag)
        print('found from cache')
        return digest
    except FileNotFoundError:
        print('did not find from cache, fetching')
        digest = json.loads(check_output(['skopeo', 'inspect', f"docker://{repository}:{tag}"]))['Digest']
        write_cache(tag, digest)
        return digest


nodes = []

for tag in get_tags(repository, initial_tag):
    digest = get_digest(repository, tag)

    nodes.append({
        "version": tag,
        "payload": f"{repository}@{digest}"
    })

edges = []

for index in range(1, len(nodes)):
    edges.append([index-1, index])

with open('metadata.json', 'w') as f:
    f.write(json.dumps({
        "nodes": nodes,
        "edges": edges
    }))
