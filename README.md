# alpine-builder
Docker image with alpine linux to build apk's

Created user `builder` with with no password because `abuild -r` cannot be executed on root account.


## Usage:

### With external artifacts storage upload

Here is illustration how to integrate this image with your CI/CD software,
in this case i use GitLab CE + Sonatype Nexus as artifacts storage. Only one
tricky thing is to create variable in GitLab CI with plain http auth to your
Nexus server named `APK_REPO_CRED`.

`.gitlab-ci.yml`

```yaml
image: jar3b/alpine-builder:3.7
stages:
  - release

release:
  stage: release
  variables:
    RV: "1.0.1-r1"
    REPO: "https://nexus.example.org/repository/apk/myrepo"
  script:
    - abuild checksum
    - abuild -r
    - cd /home/builder/packages/${CI_PROJECT_NAMESPACE}/x86_64
    - curl -v -u ${APK_REPO_CRED} --upload-file myrepo-$RV.apk $REPO/myrepo-$RV.apk
    - curl -v -u ${APK_REPO_CRED} --upload-file myrepo-lib-$RV.apk $REPO/myrepo-lib-$RV.apk
```

### With gitlab build artifacts
 
Another option for gitlab-ci is using build artifacts like so:

```yaml
image: jar3b/alpine-builder:3.7
stages:
  - release

release:
  stage: release
  variables:
    RV: "1.0.1-r1"
  script:
    - abuild checksum
    - abuild -r
    - cd /home/builder/packages/${CI_PROJECT_NAMESPACE}/x86_64
``` 

## Available versions:
- 3.5
- 3.6
- 3.7
- 3.8 (latest)